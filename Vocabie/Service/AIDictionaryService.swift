//
//  AIDictionaryService.swift
//  Vocabie
//
//  Created by Selvarajan on 7/14/25.
//

import Foundation
import FoundationModels
import SwiftUI

@Generable
enum WordClass: String, Codable, CaseIterable, Identifiable {
    case noun
    case verb
    case adjective
    case adverb
    case pronoun
    case preposition
    case conjunction
    case interjection
    case determiner
    case article
    case numeral
    case auxiliaryVerb = "auxiliary verb"
    case modalVerb = "modal verb"
    case participle
    case infinitive
    case unknown

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .auxiliaryVerb: return "Auxiliary Verb"
        case .modalVerb: return "Modal Verb"
        default: return rawValue.capitalized
        }
    }
}

extension WordClass {
    init(from raw: String) {
        self = WordClass(rawValue: raw.lowercased()) ?? .unknown
    }
}

@Generable
struct WordDefinition: Codable, Equatable {
    
    /// The exact word the user asked about, preserving original casing.
    @Guide(description: "Target vocabulary word.")
    var word: String

    /// Up to three concise dictionary-style meanings.
    @Guide(description: "Meaning of the word in simple term.", .maximumCount(5))
    var meaning: [String]

    @Guide(description: "Synonyms of the provided word", .maximumCount(5))
    var synonyms: [String]?

//    @Guide(description: "Opposites in meaning", .maximumCount(5))
//    var antonyms: [String]?

    @Guide(description: "Same usage sentences that includes the word, illustrating correct usage", .maximumCount(5))
    var examples: [String]

//    @Guide(description: "HTTPS link to a pronunciation audio file (common-license) (optional).")
//    var audioUrl: URL?
//
//    @Guide(description: "HTTPS link to a royalty-free image representing the word (optional).")
//    var imageUrl: URL?
    
    @Guide(description: "Part of speech, e.g. noun, verb, adjective, adverb.")
    var wordClass: WordClass?

//    @Guide(description: "IPA pronunciation (optional).")
//    var pronunciation: String?

    @Guide(description: "Words that are having similar meaning or semantically related words", .maximumCount(5))
    var relatedWords: [String]?

//    @Guide(description: "Unique identifier (optional).")
//    var id: String
}

class AIDictionaryService {
    
    static func isAIModelavailabile() -> (Bool, String) {
        let model = SystemLanguageModel.default
        
        switch model.availability {
            case .available:
                // Show your intelligence UI.
                return (true, "")
            case .unavailable(.deviceNotEligible):
                // Show an alternative UI.
                return (false, "The device is not elegible")
            case .unavailable(.appleIntelligenceNotEnabled):
                // Ask the person to turn on Apple Intelligence.
                return (false, "Apple Intelligence is not enabled")
            case .unavailable(.modelNotReady):
                // The model isn't ready because it's downloading or because of other system reasons.
                return (false, "The model is not ready")
            case .unavailable(_):
                // The model is unavailable for an unknown reason.
                return (false, "Model unavailable for an unknown reason")
        }
    }
    
    static func fetchDefinition(for word: String) async -> WordDefinition {
        // Check the availability
        if isAIModelavailabile().0 == false {
            return WordDefinition(word: "Model unavailable", meaning: [], examples: [])
        }
        
        let prompt = "define '\(word)'."
        let instructions = """
            You are a helpful and accurate English dictionary. When a user provides a word, return its meaning, part of speech, example sentence usage, and related words. Keep the response concise, and easy to understand for intermediate English learners.
            """
        let assistant = SystemLanguageModel.default
        let session = LanguageModelSession(model: assistant, instructions: instructions)
        do {
            let result = try await session.respond(
                to: prompt,
                generating: WordDefinition.self,
//                options: options,
            )
            
            return result.content
            
        } catch {
            print("Error: \(error)")
        }

        return WordDefinition(word: "Error", meaning: [], examples: [])
    }
}
