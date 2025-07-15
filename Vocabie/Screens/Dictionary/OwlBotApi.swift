//
//  OwlBotApi.swift
//  Vocabie
//
//  Created by Selvarajan on 27/05/22.
//

import Foundation

struct OwlbotResponse: Codable {
    let definitions: [OwlbotDefinition]?
    let word: String?
    let pronunciation: String?
}

struct OwlbotDefinition: Codable, Hashable {
    let type: String?
    let definition: String
    let example: String?
}

func extractDefinitionFromOwlBot(owlbotResponse: OwlbotResponse) -> String {
    var type = ""
    var meaning = ""
    
    if let def = owlbotResponse.definitions {
        let sortedResults = def.sorted { $0.type?.compare($1.type!) == .orderedDescending }
            
        for result in sortedResults {
            if (result.type! == type) {
                meaning += result.definition + " "
            } else {
                type = result.type!
                if meaning != "" {
                    meaning += "\n\n"
                }
                meaning += "(" + result.type! + ") -  " + result.definition + " "
            }
        }
    }
    
    return meaning
}

func extractExampleFromOwlBot(owlbotResponse: OwlbotResponse) -> String {
    var type = ""
    var exampleSentences = ""
    
    if let def = owlbotResponse.definitions {
        let sortedResults = def.sorted { $0.type?.compare($1.type!) == .orderedDescending }
            
        for result in sortedResults {
            if (result.type! == type) {
                if result.example != nil {
                    exampleSentences += "  - " + result.example! + "\n"
                }
            } else {
                if result.example != nil {
                    type = result.type!
                    if exampleSentences != "" {
                        exampleSentences += "\n"
                    }
                    exampleSentences += "(as " + result.type! + "): \n"
                    exampleSentences += "  - " + result.example! + "\n"
                }
            }
        }
    }
    
    return exampleSentences
}


// JSON format
/*
 {
     "definitions": [
         {
             "type": "adjective",
             "definition": "having or showing a modest or low estimate of one's importance.",
             "example": "I felt very humble when meeting her",
             "image_url": null,
             "emoji": null
         },
         {
             "type": "adjective",
             "definition": "of low social, administrative, or political rank.",
             "example": "she came from a humble, unprivileged background",
             "image_url": null,
             "emoji": null
         },
         {
             "type": "adjective",
             "definition": "(of a thing) of modest pretensions or dimensions.",
             "example": "he built the business empire from humble beginnings",
             "image_url": null,
             "emoji": null
         },
         {
             "type": "verb",
             "definition": "cause (someone) to feel less important or proud.",
             "example": "he was humbled by his many ordeals",
             "image_url": null,
             "emoji": null
         }
     ],
     "word": "humble",
     "pronunciation": "ˈhəmbəl"
 }
 */
