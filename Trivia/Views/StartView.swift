//
//  ContentView.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    
    @State var difficultyIndex = 0
    @State var selectCategory = false
    @State var selectDifficulty = false
    
    @Namespace var namespace
    @State var show = false
    
    var body: some View {
        ZStack {
            if selectCategory {
                categories
            } else {
                allData
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color("back"))
    }
    
    var categories: some View {
        VStack {
            
            Text("Choose a Catagory")
                .font(.system(size: 20))
                .lilacTitle()
                .padding(.top)
            
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
            .padding()
            
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(Color("text"))
                .frame(width: 36, height: 36)
                .onTapGesture {
                    impact(type: .soft)
                    withAnimation {
                        selectCategory = false
                    }
                }
            
        }
        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)).combined(with: .opacity)).animation(.spring(), value: selectCategory)
        .safeAreaInset(edge: .top) {
            Color.clear
                .frame(height: 64)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 64)
        }
    }
    
    var allData: some View {
            
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
                        
                        PrimaryButton(text: "\(triviaManager.selectedCategory.name.deletingPrefix("Entertainment: "))", padding: 10)
                            .onTapGesture {
                                impact(type: .soft)
                                withAnimation {
                                    selectCategory.toggle()
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
                        
                            HStack {
                                ForEach(Difficulties.allCases, id:\.self) { dif in
                                    
                                    DiffButton(isItDifficulty: true, text: dif.rawValue)
                                        .padding(.vertical, 2)
                                        .onTapGesture {
                                            impact(type: .soft)
                                            triviaManager.selectedDifficulty = dif
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                withAnimation {
                                                    selectDifficulty.toggle()
                                                }
                                            }
                                        }
                                }
                            }
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)).combined(with: .opacity)).animation(.spring(), value: selectDifficulty)

                    } else {
                        
                        PrimaryButton(text: triviaManager.selectedDifficulty.rawValue, padding: 10)
                            .onTapGesture {
                                impact(type: .soft)
                                withAnimation {
                                    selectDifficulty.toggle()
                                }
                            }
                        
                    }
                }
                
                
                // MARK: - Let's go button
       
                VStack {
                    PrimaryButton(text: triviaManager.index > 0 ? "Continue" : "Start", background: triviaManager.noQuestions ? .gray.opacity(0.5) : Color("accent"), fontStyle: .title)
                        .padding(.top, 36)
                        .onTapGesture {
                            impact(type: .heavy)
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                triviaManager.currentView = .game
                            }
                        }
                        .disabled(triviaManager.length == 0)
                    
                    Text("There's not enough questions of this difficulty")
                        .font(.footnote)
                        .opacity(triviaManager.noQuestions ? 0.5 : 0)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        // MARK: - Send request
        
        .onAppear(perform: {
            if !triviaManager.stopFetching {
                triviaManager.fetchTrivia()
            }
            triviaManager.stopFetching = false
            if triviaManager.openCategories {
                withAnimation {
                    selectCategory = true
                    triviaManager.openCategories = false
                }
                
            }
        })
        
        
    }
    
    
    
    private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(triviaManager.categories, id: \.self) { category in
                    self.item(for: category.name)
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width)
                            {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if category == self.triviaManager.categories.last! {
                                width = 0 //last item
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: {d in
                            let result = height
                            if category == self.triviaManager.categories.last! {
                                height = 0 // last item
                            }
                            return result
                        })
                }
            }
        }

    private func item(for text: String) -> some View {
        DiffButton(isItDifficulty: false, text: text)
            .onTapGesture {
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                let tappedCategoryIndex = triviaManager.categories.firstIndex { cat in
                    cat.name == text
                }
                triviaManager.selectedCategory = triviaManager.categories[tappedCategoryIndex!]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        selectCategory.toggle()
                    }
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
