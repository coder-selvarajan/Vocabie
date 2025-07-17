//
//  Adjective.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import Foundation

struct Adjective: Identifiable, Codable {
    let id: Int
    let adjective: String
    let meaning: String
    let examples: [String]
}
