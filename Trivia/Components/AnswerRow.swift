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
            
            if isSelected || (answer.isCorrect && triviaManager.answerSelected) {
                
                Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .transition(.slide)
                    .foregroundColor(answer.isCorrect ? green : red)
                    .transition(.move(edge: .leading)).animation(.spring(), value: isSelected)
                
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(
            triviaManager.answerSelected ? (isSelected ? Color("text") : .gray) : Color("text")
        )
        .background(Color("back"))
        .cornerRadius(20)
        .shadow(color: isSelected ? (answer.isCorrect ? Color("accent") : red) : Color("text"), radius: 5, x: 0, y: 1)
        .shadow(color: isSelected ? (answer.isCorrect ? Color("accent") : .clear) : .clear, radius: 5, x: 0, y: 1)
        .onTapGesture {
            if !triviaManager.answerSelected {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    isSelected = true
                }
                triviaManager.selectAnswer(answer: answer)
                if !answer.isCorrect {
                    impact(type: .heavy)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {impact(type: .heavy)})
                } else {
                    impact(type: .heavy)
                }
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
