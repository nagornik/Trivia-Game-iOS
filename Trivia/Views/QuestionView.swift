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
    @State var dragOffset = CGFloat.zero
    
    var body: some View {
        
        
        VStack {
            
            if noInternet {
                noInternetScreen
            } else if triviaManager.isLoading {
                loadingScreen
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                noInternet = true
                            }
                        }
                    }
            } else {
                content
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
        .offset(y: dragOffset)
        .gesture(DragGesture()
            .onChanged({ value in
                dragOffset = value.translation.height
            })
            .onEnded { value in
                if value.translation.height < -100 {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        triviaManager.stopFetching = true
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
    
    var loadingScreen: some View {
        VStack {
            Text("Loading Data...")
                .font(.system(size: 20))
                .lilacTitle()
            ProgressView()
        }
    }
    
    var noInternetScreen: some View {
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
                } label: {
                    DiffButton(isItDifficulty: true, text: "Try again")
                        .padding(.vertical, 20)
                        .onTapGesture {
                            impact(type: .heavy)
                        }
                }
            }
            .onChange(of: triviaManager.isLoading) { newValue in
                noInternet = newValue
            }
            
            VStack {
                Spacer()
                Image(systemName: "arrow.turn.right.up")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
            }
            
        }
    }
    
    var content: some View {
        
        VStack {
            
            // MARK: - Close button
            HStack {
                Spacer()
                Button {
                    impact(type: .soft)
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
            
            // MARK: - Title and questions number
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
            
            // MARK: - Question and answers
            Group {
                
                VStack (alignment: .leading, spacing: 20) {
                    Text(triviaManager.question)
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(Color("text"))
                    
                    
                    ForEach(triviaManager.answersCoices, id:\.id) { answer in
                        AnswerRow(answer: answer)
                            .onTapGesture {
                                impact(type: .soft)
                            }
                    }
                }
                .padding(.horizontal)
                
                
                // MARK: - "Next" button
                PrimaryButton(text: triviaManager.index + 1 == triviaManager.length ? "Show results" : "Next", background: triviaManager.answerSelected ? Color("accent") : .gray.opacity(0.5))
                    .onTapGesture {
                        impact(type: .soft)
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
            .onChange(of: isNextQuestion) { newValue in
                if isNextQuestion {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        questionsOffset = 400.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        questionsOffset = -400.0
                        triviaManager.goToNextQuestion()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            questionsOffset = 0.0
                        }
                    }
                }
                isNextQuestion = false
            }
            
            
            Spacer()
            
            
        }
        
    }
    
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
            .preferredColorScheme(.dark)
            .environmentObject(TriviaManager())
    }
}
