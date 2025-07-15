//
//  Words.swift
//  Vocabie
//
//  Created by Selvarajan on 21/04/22.
//

import Foundation

// MARK: - WordElement
struct WordElement: Codable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]
    let origin: String?
    let meanings: [Meaning]
}

// MARK: - Meaning
struct Meaning: Codable, Hashable {
    let partOfSpeech: String
    let definitions: [Definition]
}

// MARK: - Definition
struct Definition: Codable, Hashable {
    let definition: String
    let example: String?
    let synonyms, antonyms: [String]
}

// MARK: - Phonetic
struct Phonetic: Codable {
    let text, audio: String?
}

typealias Words = [WordElement]

func extractMeaning(meanings: [Meaning]) -> String {
    var result: String = ""
    
    for meaning in meanings {
        if (result != "") { //just adding line break for next partOfSpeech meaning
            result += "\n\n"
        }
        result += meaning.partOfSpeech + " -  "
        for definition in meaning.definitions {
            result += definition.definition + " "
        }
    }
    return result
}

func extractExmple(meanings: [Meaning]) -> String {
    var result: String = ""
    var sentences: String = ""
    
    for meaning in meanings {
        for definition in meaning.definitions {
            if let example = definition.example {
                sentences += "  - " + example + " \n"
            }
        }
        if (sentences != "") {
            result += "(as " + meaning.partOfSpeech + "): \n" + sentences + "\n"
            sentences = ""
        }
    }
    return result
}
