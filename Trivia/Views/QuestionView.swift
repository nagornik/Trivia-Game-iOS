//
//  QuestionView.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

struct QuestionView: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        
            VStack (spacing: 40) {
                    HStack {
                        Text("Trivia Game")
                            .lilacTitle()
                        Spacer()
                        Text("\(triviaManager.index + 1) out of \(triviaManager.length)")
                            .fontWeight(.heavy)
                            .forAccent()
                        
                    }
                    
                    ProgressBar(progress: triviaManager.progress)
                    
                    VStack (alignment: .leading, spacing: 20) {
                        Text(triviaManager.question)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color("text"))
                        
                        ForEach(triviaManager.answersCoices, id:\.id) { answer in
                            AnswerRow(answer: answer)
                        }
                        
                        
                    }
                    
    //                Text("\(Double(triviaManager.score))")
    //                Text("\(Double(triviaManager.length))")
    //                Text("\(Double(triviaManager.score) / Double(triviaManager.length))")
    //                NavigationLink {
    //                    TriviaView()
    //                } label: {
    //                    PrimaryButton(text: triviaManager.index + 1 == triviaManager.length ? "Show results" : "Next", background: triviaManager.answerSelected ? Color("accent") : .gray.opacity(0.8))
    //                }
                    if triviaManager.index + 1 == triviaManager.length {
                        NavigationLink {
                            TriviaView()
                        } label: {
                            PrimaryButton(text: triviaManager.index + 1 == triviaManager.length ? "Show results" : "Next", background: triviaManager.answerSelected ? Color("accent") : .gray.opacity(0.8))
                        }

                    } else {
                        Button {
                            triviaManager.goToNextQuestion()
    //                        triviaManager.currentContentSelected = nil
                        } label: {
                            PrimaryButton(text: triviaManager.index + 1 == triviaManager.length ? "Show results" : "Next", background: triviaManager.answerSelected ? Color("accent") : .gray.opacity(0.8))
                        }
                        .disabled(!triviaManager.answerSelected)
                    }
                    
                    
                    Spacer()
                    
    //                Button {
    //                    dismiss()
    //                } label: {
    //                    HStack {
    //                        PrimaryButton(text: "Exit", background: Color.red)
    //                            .scaleEffect(0.7)
    //                        Spacer()
    //                    }
    //                }
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("back"))
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { // <2>
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            dismiss()
                            Task {
                                await triviaManager.fetchTrivia()
                            }
                            
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(Color("text"))
                        }
                        
                    }
                    
                }
        
        
        
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
            .environmentObject(TriviaManager())
    }
}
