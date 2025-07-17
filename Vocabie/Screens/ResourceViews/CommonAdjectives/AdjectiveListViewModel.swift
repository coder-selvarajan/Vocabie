//
//  VerbListViewModel.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import Foundation

class AdjectiveListViewModel: ObservableObject {
    @Published var adjectives: [Adjective] = []

    init() {
        loadAdjectives()
    }

    private func loadAdjectives() {
        guard let url = Bundle.main.url(forResource: "intermediate_adjectives", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Adjective].self, from: data) else {
            print("Failed to load adjectives")
            return
        }

        adjectives = decoded
    }
}
