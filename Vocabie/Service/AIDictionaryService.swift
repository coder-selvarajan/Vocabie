//
//  AIDictionaryService.swift
//  Vocabie
//
//  Created by Selvarajan on 7/14/25.
//

import Foundation
import FoundationModels
import Observation

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

@MainActor
@Observable
class AIDictionaryService {
    
    let session: LanguageModelSession
    var wordDefinition: WordDefinition?
    var isAIResponding: Bool = false
    var responseText: String = ""
    
    init() {
        /*
        let instructions = """
            You are a helpful, friendly, and accurate English dictionary. You will help learning English in intuitive easy way. Keep your answers concise, and easy to understand for a beginner English learner.
            """
        */
        
        let instructions = """
        You are a helpful, friendly English learning assistant. You help users learn and understand English in an intuitive, easy way. Whether answering dictionary queries, explaining grammar, clarifying usage, or addressing any English-related questions, keep your responses concise and easy to understand for English learners of all levels. Provide clear explanations, examples when helpful, and encourage learning.
        """
        session = LanguageModelSession(instructions: instructions)
        
        /*
        let assistant = SystemLanguageModel.default
        let session = LanguageModelSession(model: assistant, instructions: instructions)
         */
    }
    
    func fetchDefinition(for word: String) async throws {
        
        print("Availability: \(isAIModelavailabile())")
        
        let prompt = "define '\(word)'."
    
        print("Fetching definition for \(word)...")
        let result = try await session.respond(
            to: prompt,
            generating: WordDefinition.self,
        )
        print(result.content)
        wordDefinition = result.content
    }
    
    func generateResponse(for text: String) async throws {
        responseText = ""
        
        let prompt = "As a English teacher answer this question: \n \(text)"
        let stream = session.streamResponse(to: prompt)
        
        print("AI answering begins!")
        isAIResponding = true
        
        for try await partial in stream {
            responseText = partial
        }
        
        print("AI answering completed!")
        isAIResponding = false
    }
    
    func isAIModelavailabile() -> (Bool, String) {
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
}





