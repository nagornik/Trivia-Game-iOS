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
                    .foregroundColor(.white)
                    .bold()
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(triviaManager.selectedDifficulty.rawValue == text ? Color("accent") : .gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                Text(text.deletingPrefix("Entertainment: "))
                    .foregroundColor(.white)
                    .bold()
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(triviaManager.selectedCategory.name == text ? Color("accent") : .gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        
    }
}
