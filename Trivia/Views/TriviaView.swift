//
//  TriviaView.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

struct TriviaView: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    @State var changeDifficulty = false
    @State var resultsText = ""
    @State var score = 0
    
    var body: some View {
        
            VStack (spacing: 20) {
                Text(resultsText)
                    .lilacTitle()
                Text("Congratulations! You completed the game!🤓")
                Text("Your score is:")
                    .font(.system(size: 18))
                Text("\(score) out of \(triviaManager.length)")
                    .font(.system(size: 20))
                    .lilacTitle()

                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                    triviaManager.fetchTrivia()
//                    Task.init {
//                        await triviaManager.fetchTrivia()
//                    }
                    triviaManager.openCategories = true
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        triviaManager.currentView = .start
                    }
                } label: {
                    PrimaryButton(text: "Change category", padding: 10)
                }
                
                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                    withAnimation {
                        changeDifficulty.toggle()
                    }
                } label: {
                    PrimaryButton(text: "Change Difficulty", padding: 10)
                }
                
                if changeDifficulty {
                    HStack {
                        ForEach(Difficulties.allCases, id:\.self) { dif in
                            DiffButton(isItDifficulty: true, text: dif.rawValue)
                                .padding(.vertical, 2)
                                .onTapGesture {
                                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                                    impactMed.impactOccurred()
                                    triviaManager.selectedDifficulty = dif
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation {
                                            changeDifficulty.toggle()
                                        }
                                    }
                                }
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)).combined(with: .opacity)).animation(.spring(), value: changeDifficulty)
                }
                    
                
                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        triviaManager.currentView = .game
                    }
                } label: {
                    PrimaryButton(text: "Play again")
                }
                
                
            }
            .onAppear(perform: {
                resultsText = triviaManager.checkResults()
                score = triviaManager.score
                triviaManager.fetchTrivia()
//                Task.init {
//                    await triviaManager.fetchTrivia()
//                }
            })
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
