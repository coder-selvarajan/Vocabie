//
//  WordLookupView.swift
//  Vocabie
//
//  Created by Selvarajan on 7/15/25.
//

import SwiftUI

/// Root view that lets the user enter a word and shows the AI‑powered definition result.
struct WordLookupView: View {
    @Bindable var dictionaryService: AIDictionaryService
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                if let result = dictionaryService.wordDefinition {
                    DefinitionDetailView(definition: result)
                        .padding()
                } else {
                    placeholder
                }
            }
            .frame(maxWidth: .infinity)
            .animation(.easeInOut, value: dictionaryService.wordDefinition)
        }
    }
}

// MARK: - Helpers
extension WordLookupView {
    var placeholder: some View {
        VStack(spacing: 12) {
            Text("Loading definition from AI...")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Definition Detail
struct DefinitionDetailView: View {
    let definition: WordDefinition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            definitionsSection
            examplesSection
            synonymsSection
        }
    }
    
    @ViewBuilder private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(definition.word)
                .font(.largeTitle.bold())
            if let pos = definition.wordClass {
                Text(pos.displayName.lowercased())
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
    
    private var definitionsSection: some View {
        SectionHeader(title: "Definitions", systemImage: "book.fill") {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(definition.meaning.indices, id: \.self) { idx in
                    HStack(alignment: .top) {
                        Text("\(idx + 1).")
                            .bold()
                        Text(definition.meaning[idx])
                    }
                    .padding(.leading, 25)
                }
            }
        }
    }
    
    private var synonymsSection: some View {
        if let synonyms = definition.synonyms, !synonyms.isEmpty {
            return AnyView(SectionHeader(title: "Synonyms", systemImage: "arrow.triangle.swap") {
                FlowLayout(items: synonyms)
            })
        }
        return AnyView(EmptyView())
    }

    private var examplesSection: some View {
        SectionHeader(title: "Examples", systemImage: "text.quote") {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(definition.examples, id: \.self) { sentence in
                    Text("\"\(sentence)\"")
                        .italic()
                        .padding(.leading, 25)
                }
            }
        }
    }
}

// MARK: - Reusable Section Header Wrapper
struct SectionHeader<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .padding(.top, 10)
            content
        }
    }
}

// MARK: - FlowLayout (simple tag cloud)
struct FlowLayout: View {
    var items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundColor(.accentColor)
                    Text(item)
                }
                .padding(.vertical, 4)
                .padding(.leading, 25)
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
