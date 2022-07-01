//
//  Trivia.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import Foundation

struct Trivia: Decodable {
    var results: [Result]
    
    struct Result: Identifiable, Decodable {
        var id: UUID {
            UUID()
        }
        var question, correctAnswer, category, type, difficulty: String
        var incorrectAnswers: [String]
        var formattedQuestion: AttributedString {
            do {
                return try AttributedString(markdown: question)
            } catch {
                print("Error making a question \(error.localizedDescription)")
                return ""
            }
        }
        var answers: [Answer] {
//            do {
//                let correct = [Answer(text: try AttributedString(markdown: correctAnswer), isCorrect: true)]
//                let incorrect = try incorrectAnswers.map { answer in
//                    Answer(text: try AttributedString(markdown: answer), isCorrect: false)
//                }
//                let allAnswers = correct + incorrect
//                return allAnswers.shuffled()
//
//            } catch {
//                print("Error setting answers \(error.localizedDescription)")
//                return []
//            }
            
            var all = [Answer]()
            do {
                let correct = Answer(text: try AttributedString(markdown: correctAnswer), isCorrect: true)
                all.append(correct)
                for answer in incorrectAnswers {
                    all.append(Answer(text: try AttributedString(markdown: answer), isCorrect: false))
                }
            } catch {}
            all.shuffle()
            return all
        }
    }
    
}


