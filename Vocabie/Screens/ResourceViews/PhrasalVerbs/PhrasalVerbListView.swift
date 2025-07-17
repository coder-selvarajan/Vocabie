//
//  AdjectiveListView.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import SwiftUI

// MARK: - Main List View
struct PhrasalVerbListView: View {
    @StateObject private var manager = PhrasalVerbManager()
    @State private var searchText = ""
    
    var filteredPhrasalVerbs: [PhrasalVerb] {
        if searchText.isEmpty {
            return manager.phrasalVerbs
        } else {
            return manager.phrasalVerbs.filter { verb in
                verb.phrasal_verb.localizedCaseInsensitiveContains(searchText) ||
                verb.meaning.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            if manager.isLoading {
                ProgressView("Loading phrasal verbs...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = manager.errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Retry") {
                        manager.loadPhrasalVerbs()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredPhrasalVerbs) { verb in
                    NavigationLink(destination: PhrasalVerbDetailView(phrasalVerb: verb)) {
                        PhrasalVerbRowView(phrasalVerb: verb)
                    }
                }
                .searchable(text: $searchText, prompt: "Search phrasal verbs...")
            }
        }
        .navigationTitle("Phrasal Verbs")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if manager.phrasalVerbs.isEmpty {
                manager.loadPhrasalVerbs()
            }
        }
    }
}

// MARK: - Row View
struct PhrasalVerbRowView: View {
    let phrasalVerb: PhrasalVerb
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(phrasalVerb.phrasal_verb)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(phrasalVerb.meaning)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Detail View
struct PhrasalVerbDetailView: View {
    let phrasalVerb: PhrasalVerb
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Phrasal Verb Title
                VStack(alignment: .leading, spacing: 8) {
                    Text(phrasalVerb.phrasal_verb)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Divider()
                
                // Meaning Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Meaning")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(phrasalVerb.meaning)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                // Example Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Example")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(phrasalVerb.usage_example)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .italic()
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Phrasal Verb")
        .navigationBarTitleDisplayMode(.inline)
    }
}
