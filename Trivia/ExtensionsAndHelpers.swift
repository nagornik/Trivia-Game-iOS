////
////  Extensions.swift
////  Trivia
////
////  Created by Anton Nagornyi on 29.06.2022.
////
//
//import Foundation
//import SwiftUI
//
//extension Text {
//    func lilacTitle() -> some View {
//        self.font(.title)
//            .fontWeight(.heavy)
//            .foregroundColor(Color("text"))
//    }
//    func forAccent() -> some View {
//        self.foregroundColor(Color("text"))
//    }
//    func backAccent() -> some View {
//        self.background(Color("text"))
//    }
//}
//
//enum AppViews {
//    case start
//    case game
//    case finish
//}
//
//enum Difficulties: String, CaseIterable {
//    case any = "Any"
//    case easy = "Easy"
//    case medium = "Medium"
//    case hard = "Hard"
//}
//
//extension String {
//    func deletingPrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self }
//        return String(self.dropFirst(prefix.count))
//    }
//}
//
//func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
//    UINotificationFeedbackGenerator()
//        .notificationOccurred(type)
//}
//
//func impact(type: UIImpactFeedbackGenerator.FeedbackStyle) {
//    UIImpactFeedbackGenerator(style: type)
//        .impactOccurred()
//}
