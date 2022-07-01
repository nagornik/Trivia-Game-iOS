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
        
        
        switch triviaManager.currentView {
        case .start:
            StartView()
        case .game:
            QuestionView()
        case .finish:
            TriviaView()
        }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
