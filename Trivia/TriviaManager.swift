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

class TriviaManager: ObservableObject {
    
    @Published var currentView: AppViews = .start
    
    private(set) var trivia: [Trivia.Result] = []
    @Published var categories: [Category] = []
    @Published private(set) var length = 0
    @Published private(set) var index = 0
    @Published private(set) var reachEnd = false
    @Published private(set) var answerSelected = false
    @Published private(set) var question: AttributedString = ""
    @Published private(set) var answersCoices: [Answer] = []
    @Published private(set) var progress: CGFloat = 0.00
    @Published private(set) var score = 0
    @Published var selectedCategory = Category(id: 9, name: "General Knowledge")
    @Published var selectedDifficulty = Difficulties.any
    @Published var finalText = ""
    @Published var currentContentSelected: Int?
    
    var ApiUrl: String {
        if selectedDifficulty == Difficulties.any {
            return "https://opentdb.com/api.php?amount=10&category=\(selectedCategory.id)"
        } else {
            return "https://opentdb.com/api.php?amount=10&category=\(selectedCategory.id)&difficulty=\(selectedDifficulty.rawValue.lowercased())"
        }
    }
    
//    enum Difficulties: String {
//        case any = "Any"
//        case easy = "Easy"
//        case medium = "Medium"
//        case hard = "Hard"
//    }
    
    
    init() {
        
        categories = TriviaManager.getCategories()
        
//        Task.init {
//            await fetchCategories()
//        }
    }
    
//    func nextDifficulty() {
//        if selectedDifficulty == .any {
//            selectedDifficulty = .easy
//        } else if selectedDifficulty == .easy {
//            selectedDifficulty = .medium
//        } else if selectedDifficulty == .medium {
//            selectedDifficulty = .hard
//        } else if selectedDifficulty == .hard {
//            selectedDifficulty = .any
//        }
//    }
    
    func checkResults() -> String {
        let score = Double(score) / Double(length)
        if score <= 0.1 {
            return "You're dumb!"
        } else if score > 0.1 && score <= 0.5 {
            return "You did well!"
        } else {
            return "Great result!"
        }
    }
    
    func assignFinalText() {
        self.finalText = checkResults()
    }
    
    static func getCategories() -> [Category] {

        // Parse local json file

        // Get a url path to the json file
        let pathString = Bundle.main.path(forResource: "Categories", ofType: "json")

        // Check if pathString is not nil, otherwise...
        guard pathString != nil else {
            return [Category]()
        }

        // Create a url object
        let url = URL(fileURLWithPath: pathString!)

        do {
            // Create a data object
            let data = try Data(contentsOf: url)

            // Decode the data with a JSON decoder
            let decoder = JSONDecoder()

            do {

                let quoteData = try decoder.decode([Category].self, from: data)

//                 Add the unique IDs
//                for r in quoteData {
//                    r.id = UUID()
//                }

                // Return the recipes
                return quoteData
            }
            catch {
                // error with parsing json
                print(error)
            }
        }
        catch {
            // error with getting data
            print(error)
        }

        return [Category]()
    }
    
    
//    func fetchCategories() async {
//        guard let url = URL(string: "https://opentdb.com/api_category.php") else {
//            fatalError("Missing URL")
//        }
//
//        let urlRequest = URLRequest(url: url)
//
//        do {
//
//            let (data, responce) = try await URLSession.shared.data(for: urlRequest)
//
//            guard (responce as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Fatal error") }
//
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            let decodedData = try decoder.decode(TriviaCategories.self, from: data)
//
//            DispatchQueue.main.async {
//                self.categories = decodedData.triviaCategories
//            }
//
//        } catch {
//            print(error.localizedDescription)
//        }
//
//    }
    
    
    func fetchTrivia() async {
        guard let url = URL(string: ApiUrl) else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            
            let (data, responce) = try await URLSession.shared.data(for: urlRequest)
            
            guard (responce as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Fatal error") }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(Trivia.self, from: data)
            
            DispatchQueue.main.async {
                self.index = 0
                self.score = 0
                self.progress = 0.0
                self.reachEnd = false
                self.trivia = decodedData.results
                self.length = self.trivia.count
                self.setQuestion()
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
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
        progress = CGFloat(Double(index + 1) / Double(length) * 350)
        
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
