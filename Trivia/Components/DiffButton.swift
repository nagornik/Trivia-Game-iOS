//
//  DiffButton.swift
//  Trivia
//
//  Created by Anton Nagornyi on 30.06.2022.
//

import SwiftUI

struct DiffButton: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    
    var isItDifficulty: Bool
    var text: String
    
    var body: some View {
        
        VStack {
            if isItDifficulty {
                Text(text)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(triviaManager.selectedDifficulty.rawValue == text ? Color("accent") : .gray.opacity(0.5))
            } else {
                Text(text.deletingPrefix("Entertainment: "))
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(triviaManager.selectedCategory.name == text ? Color("accent") : .gray.opacity(0.5))
            }
        }
        .foregroundColor(.white)
        .font(.body.bold())
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        
    }
}
