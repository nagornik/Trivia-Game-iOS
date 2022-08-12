//
//  Categories.swift
//  Trivia
//
//  Created by Anton Nagornyi on 29.06.2022.
//

import Foundation

struct Category: Decodable, Identifiable, Hashable {
    var id: Int
    var name: String
}


