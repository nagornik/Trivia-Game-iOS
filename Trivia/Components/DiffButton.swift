//
//  DiffButton.swift
//  Trivia
//
//  Created by Anton Nagornyi on 30.06.2022.
//

import SwiftUI

struct DiffButton: View {

    var isItDifficulty: Bool
    @EnvironmentObject var triviaManager: TriviaManager
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

//struct DiffButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DiffButton(isItDifficulty: true, text: "Easy")
//    }
//}
