//
//  AboutVocabie.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import SwiftUI

struct AboutVocabieView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("About Vocabie")
                    .font(.largeTitle.bold())
                    .padding(.top)

                Text("""
Vocabie is your intelligent learning companion, crafted to help you master English as your second language—anytime, anywhere.

Whether you're discovering new words, practicing phrases, or diving into everyday idioms, Vocabie creates a personalized experience powered entirely by on-device AI.
""")
                .font(.body)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("🌟 Key Features:")
                        .font(.headline)
                    
                    FeatureRow(icon: "sparkles", text: "Smart word suggestions with real-world usage")
                    FeatureRow(icon: "brain.head.profile", text: "Flashcard-style learning to improve memorization")
                    FeatureRow(icon: "quote.bubble", text: "Explore idioms, expressions, and useful phrases")
                    FeatureRow(icon: "pin", text: "Save favorites and track your learning journey")
                    FeatureRow(icon: "lock.shield", text: "All on-device — fast, private, and offline-ready")
                }

                Text("With Vocabie, you'll build vocabulary, fluency, and confidence — one word at a time.")
                    .font(.body)
                    .padding(.top)

                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("About the App")
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(text)
                .font(.body)
        }
    }
}
