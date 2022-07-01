//
//  TriviaView.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

struct TriviaView: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    @Environment(\.dismiss) var dismiss
    @State var changeDifficulty = false
    
    
    
    var body: some View {
        
            VStack (spacing: 20) {
                Text("Trivia Game")
                    .lilacTitle()
                Text("Congratulations, you completed the game!🤓")
                Text("You scored \(triviaManager.score) out of \(triviaManager.length)")
                Text(triviaManager.finalText)

                Button {
                    Task.init {
                        await triviaManager.fetchTrivia()
                    }
                    triviaManager.currentContentSelected = nil
                } label: {
                    PrimaryButton(text: "Change category")
                }
                
                Button {
                    withAnimation {
                        changeDifficulty.toggle()
                    }
                } label: {
                    PrimaryButton(text: "Change difficulty")
                }
                
                if changeDifficulty {
                    HStack {
                        ForEach(Difficulties.allCases, id:\.self) { dif in
                            DiffButton(isItDifficulty: true, text: dif.rawValue)
                                .onTapGesture {
                                    triviaManager.selectedDifficulty = dif
                                }
                        }
                    }
//                    .transition(.move(edge: .leading)).animation(.spring(), value: changeDifficulty)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)).combined(with: .opacity)).animation(.spring(), value: changeDifficulty)
                }
                    
                
                Button {
                    Task.init {
                        await triviaManager.fetchTrivia()
                    }
                    dismiss()
                } label: {
                    PrimaryButton(text: "Play again")
                }
//                .transition(.move(edge: .top)).animation(.spring(), value: changeDifficulty)
                
                
            }
            .onAppear(perform: {
                triviaManager.assignFinalText()
            })
            .navigationBarHidden(true)
            .foregroundColor(Color("text"))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("back"))
        
        
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
            .environmentObject(TriviaManager())
    }
}
