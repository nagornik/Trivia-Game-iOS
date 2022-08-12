//
//  Answer.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import Foundation

struct Answer: Identifiable, Equatable {
    var id = UUID()
    var text: AttributedString
    var isCorrect: Bool
}
