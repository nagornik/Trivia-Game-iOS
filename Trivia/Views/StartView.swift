//
//  ContentView.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

enum Difficulties: String, CaseIterable {
    case any = "Any"
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}


struct StartView: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    
    @State var difficultyIndex = 0
    @State var selectCategory = false
    @State var selectDifficulty = false
    
    var rows = [
        
        //        GridItem(.adaptive(minimum: 30), spacing: 10)
        GridItem(.flexible(minimum: 30), spacing: 0, alignment: .leading),
        GridItem(.flexible(minimum: 30), spacing: 0, alignment: .leading),
        GridItem(.flexible(minimum: 30), spacing: 0, alignment: .leading),
        GridItem(.flexible(minimum: 30), spacing: 0, alignment: .leading),
        GridItem(.flexible(minimum: 30), spacing: 0, alignment: .leading),
        GridItem(.flexible(minimum: 30), spacing: 0, alignment: .leading)
        
    ]
    
    
    var body: some View {
        
        NavigationView {
            
            // MARK: - Title
            
            VStack (spacing: 40) {
                
                VStack (spacing: 20) {
                    
                    Text("Trivia Game")
                        .font(.system(size: 50))
                        .lilacTitle()
                    
                    Text("Are you ready to test out your trivia skills?")
                        .foregroundColor(Color("text"))
                    
                }
                
                
                // MARK: - Category
                
                if triviaManager.categories.count != 0 {
                    
                    VStack {
                        
                        Text("Category")
                            .font(.system(size: 20))
                            .lilacTitle()
                        
                        if selectCategory {
                            
                                
                            
                            ScrollView (.horizontal, showsIndicators: false) {
                                
                                LazyHGrid(rows: rows) {
                                    ForEach(0..<triviaManager.categories.count, id: \.self) { index in
                                        
                                        DiffButton(isItDifficulty: false, text: "\(triviaManager.categories[index].name)")
                                            .tag(triviaManager.categories[index])
                                            .padding()
                                            .onTapGesture {
                                                triviaManager.selectedCategory = triviaManager.categories[index]
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    withAnimation {
                                                        selectCategory.toggle()
                                                    }
                                                }
                                            }
                                        
                                    }
                                    
                                }
                                
                            }
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)).combined(with: .opacity)).animation(.spring(), value: selectCategory)
                            .frame(height: 280)
                            
                        } else {
                            PrimaryButton(text: "\(triviaManager.selectedCategory.name.deletingPrefix("Entertainment: "))", padding: 10)
                                .onTapGesture {
                                    withAnimation {
                                        selectCategory.toggle()
                                    }
                                }
                                
                        }
                        
                    }
                    
                }
                
                
                // MARK: - Difficulty
                VStack {
                    
                    Text("Difficulty")
                        .font(.system(size: 20))
                        .lilacTitle()
                    
                    if selectDifficulty {
                        VStack {
                            
                            HStack {
                                ForEach(Difficulties.allCases, id:\.self) { dif in
                                    DiffButton(isItDifficulty: true, text: dif.rawValue)
                                        .padding(.vertical, 2)
                                        .onTapGesture {
                                            triviaManager.selectedDifficulty = dif
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                withAnimation {
                                                    selectDifficulty.toggle()
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)).combined(with: .opacity)).animation(.spring(), value: selectDifficulty)
                    } else {
                        PrimaryButton(text: triviaManager.selectedDifficulty.rawValue, padding: 10)
                            .onTapGesture {
                                withAnimation {
                                    selectDifficulty.toggle()
                                }
                            }
                    }
                }
                
                
                // MARK: - Let's go button
                
                NavigationLink(tag: 0, selection: $triviaManager.currentContentSelected) {
                    QuestionView()
                } label: {
                    PrimaryButton(text: "Let's go", fontStyle: .title)
                        .padding(.top, 36)
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("back"))
            .navigationBarHidden(true)
            
        }
        .navigationViewStyle(.stack)
        
        
        
        // MARK: - Send request
        
        .onAppear(perform: {
            Task {
                await triviaManager.fetchTrivia()
            }
        })
        .onChange(of: triviaManager.selectedDifficulty, perform: { newValue in
            Task {
                await triviaManager.fetchTrivia()
            }
        })
        .onChange(of: triviaManager.selectedCategory) { newValue in
            Task {
                await triviaManager.fetchTrivia()
            }
        }
        
        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .preferredColorScheme(.dark)
            .environmentObject(TriviaManager())
    }
}
