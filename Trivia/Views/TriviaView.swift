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
    @State var score = 0
    @State var dragOffset = CGFloat.zero
    
    var body: some View {
        
            VStack (spacing: 20) {
                Text(triviaManager.checkResults())
                    .lilacTitle()
                Text("Congratulations! You completed the game!🤓")
                    .multilineTextAlignment(.center)
                Text("Your score is:")
                    .font(.system(size: 18))
                Text("\(score) out of \(triviaManager.length)")
                    .font(.system(size: 20))
                    .lilacTitle()

                Button {
                    impact(type: .soft)
                    triviaManager.fetchTrivia()
                    triviaManager.openCategories = true
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        triviaManager.currentView = .start
                    }
                } label: {
                    PrimaryButton(text: "Change category", padding: 10)
                }
                
                Button {
                    impact(type: .soft)
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
                                    impact(type: .soft)
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
                    impact(type: .soft)
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        triviaManager.currentView = .game
                    }
                } label: {
                    PrimaryButton(text: "Play again")
                }
                
                
            }
            .onAppear(perform: {
                score = triviaManager.score
                triviaManager.fetchTrivia()
            })
            .foregroundColor(Color("text"))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("back"))
            .offset(y: dragOffset)
            .gesture(DragGesture()
                .onChanged({ value in
                    dragOffset = value.translation.height
                })
                    .onEnded { value in
                        if value.translation.height < -100 {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                triviaManager.currentView = .start
                            }
                            dragOffset = .zero
                        } else {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                dragOffset = .zero
                            }
                        }
                    }
            )
            
        
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
            .environmentObject(TriviaManager())
    }
}
