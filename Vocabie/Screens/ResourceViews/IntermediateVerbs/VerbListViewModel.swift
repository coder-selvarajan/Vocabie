//
//  VerbListViewModel.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import Foundation

class VerbListViewModel: ObservableObject {
    @Published var verbs: [Verb] = []

    init() {
        loadVerbs()
    }

    private func loadVerbs() {
        guard let url = Bundle.main.url(forResource: "intermediate_verbs", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Verb].self, from: data) else {
            print("Failed to load verbs")
            return
        }

        verbs = decoded
    }
}
