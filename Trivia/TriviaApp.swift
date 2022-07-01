//
//  TriviaApp.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import SwiftUI

@main
struct TriviaApp: App {
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(TriviaManager())
        }
    }
}
