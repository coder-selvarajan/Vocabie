//
//  AdjectiveListView.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import SwiftUI

struct AdjectiveListView: View {
//    let adjectives: [Adjective] = Bundle.main.decode([Adjective].self, from: "intermediate_adjectives_filled.json")
    @StateObject private var viewModel = AdjectiveListViewModel()
    
    @State private var searchText = ""

    var filteredAdjectives: [Adjective] {
        if searchText.isEmpty {
            return viewModel.adjectives
        } else {
            return viewModel.adjectives.filter {
                $0.adjective.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List(filteredAdjectives) { adjective in
            NavigationLink(destination: AdjectiveDetailView(adjective: adjective)) {
                Text(adjective.adjective.capitalized)
                    .font(.headline)
            }
        }
        .navigationTitle("Common Adjectives")
        .searchable(text: $searchText, prompt: "Search adjectives...")
    }
}

struct AdjectiveDetailView: View {
    let adjective: Adjective
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(adjective.adjective.capitalized)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)
                
                Divider()
                
                Text("Meaning")
                    .font(.title2)
                Text(adjective.meaning)
                    .padding(.bottom, 10)
                
                Divider()
                
                Text("Examples")
                    .font(.title2)
                ForEach(adjective.examples, id: \.self) { example in
                    Text("• \(example)")
                        .padding(.bottom, 10)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .navigationTitle("Common Adjective")
        .navigationBarTitleDisplayMode(.inline)
    }
}
