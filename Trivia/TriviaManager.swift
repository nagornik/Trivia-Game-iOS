//
//  TriviaManager.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import Foundation
import SwiftUI

enum AppViews {
    case start
    case game
    case finish
}

enum Difficulties: String, CaseIterable {
    case any = "Any"
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator()
        .notificationOccurred(type)
}

func impact(type: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: type)
        .impactOccurred()
}

class TriviaManager: ObservableObject {
    
    @Published var selectedCategory = Category(id: 9, name: "General Knowledge") {
        didSet {
            fetchTrivia()
        }
    }
    
    @Published var selectedDifficulty = Difficulties.any {
        didSet {
            fetchTrivia()
        }
    }
    
    @Published var isLoading = false
    @Published var currentView: AppViews = .start
    @Published var openCategories = false
    @Published var stopFetching = false
    private(set) var trivia: [Trivia.Result] = []
    @Published var categories: [Category] = []
    @Published private(set) var length = 0 {
        didSet {
            
                withAnimation {
                    if length == 0 {
                        noQuestions = true
                    } else {
                        noQuestions = false
                    }
                }
            
        }
    }
    @Published private(set) var index = 0
    @Published private(set) var reachEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question: AttributedString = ""
    @Published private(set) var answersCoices: [Answer] = []
    @Published private(set) var progress: CGFloat = 0.00
    @Published private(set) var score = 0
    
    @Published var finalText = ""
    @Published var noQuestions = false
    
    
    var ApiUrl: String {
        if selectedDifficulty == Difficulties.any {
            return "https://opentdb.com/api.php?amount=10&category=\(selectedCategory.id)"
        } else {
            return "https://opentdb.com/api.php?amount=10&category=\(selectedCategory.id)&difficulty=\(selectedDifficulty.rawValue.lowercased())"
        }
    }

    init() {
        categories = TriviaManager.getCategories()
    }
    
    func checkResults() -> String {
        let score = Double(score) / Double(length)
        if score <= 0.2 {
            return "You're dumb!"
        } else if score > 0.2 && score <= 0.5 {
            return "You did well!"
        } else {
            return "Great result!"
        }
    }
    
    func assignFinalText() {
        self.finalText = checkResults()
    }
    
    static func getCategories() -> [Category] {

        let pathString = Bundle.main.path(forResource: "Categories", ofType: "json")

        guard pathString != nil else {
            return [Category]()
        }

        let url = URL(fileURLWithPath: pathString!)

        do {
            
            let data = try Data(contentsOf: url)

            let decoder = JSONDecoder()

            do {
                let quoteData = try decoder.decode([Category].self, from: data)
                return quoteData
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }

        return [Category]()
    }
    
    func fetchTrivia() {
        DispatchQueue.main.async {
            self.index = 0
            withAnimation {
                self.isLoading = true
            }
        }
        guard let url = URL(string: ApiUrl) else {
            print("Missing URL")
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, responce, error in
            guard error == nil && data != nil else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.fetchTrivia()
                }
                return
            }
            guard let responce = responce as? HTTPURLResponse else { return }
            guard responce.statusCode >= 200 && responce.statusCode < 300 else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedData = try decoder.decode(Trivia.self, from: data!)
                DispatchQueue.main.async {
                    self.trivia = decodedData.results
                    self.length = self.trivia.count
                    self.setQuestion()
                    withAnimation {
                        self.isLoading = false
                    }
                }
            } catch {
                return
            }
            
        }.resume()
        
    }
 
    func goToNextQuestion() {
        if index + 1 < length {
            index += 1
            setQuestion()
        } else {
            reachEnd = true
        }
    }
    
    func setQuestion() {
        answerSelected = false
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            progress = CGFloat(Double(index+1) / Double(length+1) * 350)
        }
        
        if index < length {
            let currentTriviaQuestion  = trivia[index]
            question = currentTriviaQuestion.formattedQuestion
            answersCoices = currentTriviaQuestion.answers
        }
    }
    
    func selectAnswer(answer: Answer) {
        withAnimation {
            answerSelected = true
        }
        if answer.isCorrect {
            score += 1
        }
    }
    
}
