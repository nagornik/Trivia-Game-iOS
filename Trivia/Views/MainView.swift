//
//  MainView.swift
//  Trivia
//
//  Created by Anton Nagornyi on 02.07.2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var triviaManager: TriviaManager
    
    var body: some View {
        
        ZStack {
            Color("back")
            switch triviaManager.currentView {
                
            case .start:
                StartView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            case .game:
                QuestionView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            case .finish:
                TriviaView()
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
            }
            
        }
        .ignoresSafeArea()
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
            .environmentObject(TriviaManager())
    }
}
