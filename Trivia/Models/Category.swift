//
//  Categories.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import Foundation

//struct TriviaCategories: Decodable {
//
//    var triviaCategories: [Category]
//
//    struct Category: Decodable, Identifiable {
//        var id: Int
//        var name: String
//    }
//}

struct Category: Decodable, Identifiable, Hashable {
    var id: Int
    var name: String
}


