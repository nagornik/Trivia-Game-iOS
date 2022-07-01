//
//  Extensions.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import Foundation
import SwiftUI

extension Text {
    func lilacTitle() -> some View {
        self.font(.title)
            .fontWeight(.heavy)
            .foregroundColor(Color("text"))
    }
    func forAccent() -> some View {
        self.foregroundColor(Color("text"))
    }
    func backAccent() -> some View {
        self.background(Color("text"))
    }
}
