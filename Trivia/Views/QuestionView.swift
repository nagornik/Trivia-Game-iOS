//
//  QuestionView.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

struct QuestionView: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    @State var questionsOffset = 0.0
    @State var isNextQuestion = false
    @State var noInternet = false
    
    var body: some View {
        
        
        VStack {

            if triviaManager.noInternet {
                if !noInternet {
                    VStack {
                        Text("Loading Data...")
                            .font(.system(size: 20))
                            .lilacTitle()
                        ProgressView()
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                noInternet = true
                            }
                        }
                    }
                } else {
                    ZStack {
                        VStack (spacing: 24) {
                            Text("Oops...")
                                .font(.system(size: 20))
                                .lilacTitle()
                            Text("Looks like the server is not responding...")
                                .font(.system(size: 16))
                            ProgressView()
                            Button {
                                triviaManager.fetchTrivia()
//                                Task.init {
//                                    await triviaManager.fetchTrivia()
//                                }
                            } label: {
                                DiffButton(isItDifficulty: true, text: "Try again")
                                    .padding(.vertical, 20)
                                    .onTapGesture {
                                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                            impactMed.impactOccurred()
                                    }
                            }
                        }
                        VStack {
                            Spacer()
                            Image(systemName: "arrow.turn.right.up")
                                .scaleEffect(1.9)
                        }
                        
                    }
                }
                
            } else {
                HStack {
                    Spacer()
                    Button {
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            triviaManager.currentView = .start
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(Color("text"))
                            .frame(width: 18, height: 18)
                    }
                    .padding(.trailing)
                }
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        noInternet = false
                    }
                }
                HStack {
                    Text("Trivia Game")
                        .lilacTitle()
                    Spacer()
                    Text("\(triviaManager.index + 1) out of \(triviaManager.length)")
                        .fontWeight(.heavy)
                        .forAccent()
                    
                }
                .padding()
                
                ProgressBar(progress: triviaManager.progress)
                    .padding()
                
                Group {
                    
                    VStack (alignment: .leading, spacing: 20) {
                        Text(triviaManager.question)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(Color("text"))
                            
                        
                        ForEach(triviaManager.answersCoices, id:\.id) { answer in
                            AnswerRow(answer: answer)
                                .onTapGesture {
                                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                                        impactMed.impactOccurred()
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    PrimaryButton(text: triviaManager.index + 1 == triviaManager.length ? "Show results" : "Next", background: triviaManager.answerSelected ? Color("accent") : .gray.opacity(0.5))
                        .onTapGesture {
                            let impactMed = UIImpactFeedbackGenerator(style: .soft)
                            impactMed.impactOccurred()
                            if triviaManager.index + 1 == triviaManager.length {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    triviaManager.currentView = .finish
                                }
                            } else {
                                isNextQuestion = true
                            }
                        }
                        .disabled(!triviaManager.answerSelected)
                        .padding()
                    
                }
                .offset(x: questionsOffset)
                //            .blur(radius: questionsBlur)
                .onChange(of: isNextQuestion) { newValue in
                    if isNextQuestion {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        questionsOffset = 400.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        questionsOffset = -400.0
                        triviaManager.goToNextQuestion()
    //                    triviaManager.goToNextQuestion()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            questionsOffset = 0.0
                        }
                    }
                    }
                    isNextQuestion = false
                }
                .onChange(of: isNextQuestion) { newValue in
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
    //                }
                }
                
                
                Spacer()

                
            }
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("back"))
        .safeAreaInset(edge: .top, content: {
            Color.clear
                .frame(height: 40)
        })
        .safeAreaInset(edge: .bottom, content: {
            Color.clear
                .frame(height: 40)
        })
        .gesture(DragGesture()
            .onEnded { value in
                if value.translation.height < -100 {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        triviaManager.stopFetching = true
                        triviaManager.currentView = .start
                    }
                }
            }
        )
        
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
            .preferredColorScheme(.dark)
            .environmentObject(TriviaManager())
    }
}

//struct Questions: View {
//
//    @EnvironmentObject var triviaManager: TriviaManager
//    @Binding var question: AttributedString
//    @Binding var answers: [Answer]
//
//    var body: some View {
//
//
//    }
//}
