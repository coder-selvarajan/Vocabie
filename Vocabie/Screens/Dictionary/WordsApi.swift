//
//  WordsApi.swift
//  Vocabie
//
//  Created by Selvarajan on 24/05/22.
//

import Foundation

// MARK: - WordsApiResponse
struct WordsApiResponse: Codable {
    let word: String
    let results: [WordsApiResult]
    let pronunciation: Pronunciation
}

// MARK: - pronunciation
struct Pronunciation: Codable, Hashable {
    let all : String?
}

// MARK: - result
struct WordsApiResult: Codable, Hashable {
    let definition: String?
    let partOfSpeech: String?
    let synonyms: [String]?
    let examples: [String]?
}

func extractDefinitionFrom(wordsApiResults: [WordsApiResult]) -> String {
    var type = ""
    var meaning = ""
    
    let sortedResults = wordsApiResults.sorted { $0.partOfSpeech?.compare($1.partOfSpeech!) == .orderedDescending
    }
    
    for result in sortedResults {
        if (result.partOfSpeech! == type) {
            meaning += result.definition! + ". "
            
        } else {
            type = result.partOfSpeech!
            if meaning != "" {
                meaning += "\n\n"
            }
            meaning += "(" + result.partOfSpeech! + ") -  " + result.definition! + ". "
        }
    }
    
    return meaning
}

func extractExampleFrom(wordsApiResults: [WordsApiResult]) -> String {
    var type = ""
    var exampleSentences = ""
    
    let sortedResults = wordsApiResults.sorted { $0.partOfSpeech?.compare($1.partOfSpeech!) == .orderedDescending
    }
    
    for result in sortedResults {
        if (result.partOfSpeech! == type) {
            
            if result.examples != nil {
                for example in result.examples! {
                    exampleSentences += "  - " + example + " \n"
                }
            }
        } else {
            if result.examples != nil {
                type = result.partOfSpeech!
                if exampleSentences != "" {
                    exampleSentences += "\n"
                }
                
                exampleSentences += "(as " + result.partOfSpeech! + "): \n"
                for example in result.examples! {
                    exampleSentences += "  - " + example + " \n"
                }
            }
        }
    }
    return exampleSentences
}

