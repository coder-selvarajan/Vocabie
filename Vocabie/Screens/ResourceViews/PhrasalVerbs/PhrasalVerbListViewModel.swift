//
//  VerbListViewModel.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import Foundation
import SwiftUI

// MARK: - Data Models
struct PhrasalVerbData: Codable {
    let phrasal_verbs: [PhrasalVerb]
}

struct PhrasalVerb: Codable, Identifiable {
    let id: String
    let phrasal_verb: String
    let meaning: String
    let usage_example: String
}

// MARK: - Data Manager
class PhrasalVerbManager: ObservableObject {
    @Published var phrasalVerbs: [PhrasalVerb] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadPhrasalVerbs() {
        isLoading = true
        errorMessage = nil
        
        // Load from bundle
        guard let url = Bundle.main.url(forResource: "phrasal_verbs", withExtension: "json") else {
            errorMessage = "Could not find phrasal_verbs copy.json file"
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let phrasalVerbData = try JSONDecoder().decode(PhrasalVerbData.self, from: data)
            DispatchQueue.main.async {
                self.phrasalVerbs = phrasalVerbData.phrasal_verbs
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error loading data: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
