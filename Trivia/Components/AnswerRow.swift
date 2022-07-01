//
//  AnswerRow.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

struct AnswerRow: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    
    var answer: Answer
    @State private var isSelected = false
    
    var green = Color.green
    var red = Color.red
    
    var body: some View {
        
        HStack (spacing: 20) {
            Image(systemName: "circle.fill")
                .font(.caption)
            Text(answer.text)
                .bold()
            
            Spacer()
            
            ZStack {
                if isSelected {
                    
                    Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                        .transition(.slide)
                        .foregroundColor(answer.isCorrect ? green : red)
                        .opacity(isSelected ? 1 : 0)
                    
                }
            }
            .transition(.move(edge: .leading)).animation(.spring(), value: isSelected)
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(
            triviaManager.answerSelected ? (isSelected ? Color("text") : .gray) : Color("text")
        )
        .background(Color("back"))
        .cornerRadius(20)
        .shadow(color: isSelected ? (answer.isCorrect ? green : red) : .gray, radius: 5, x: 0.5, y: 0.5)
        
        .onTapGesture {
            if !triviaManager.answerSelected {
                withAnimation {
                    isSelected = true
                }
                triviaManager.selectAnswer(answer: answer)
                
            }
            
        }
        
    }
}

struct AnswerRow_Previews: PreviewProvider {
    static var previews: some View {
        AnswerRow(answer: Answer(text: "Some text", isCorrect: false))
            .environmentObject(TriviaManager())
    }
}