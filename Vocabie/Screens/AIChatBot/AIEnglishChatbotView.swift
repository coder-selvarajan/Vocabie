//
//  AIEnglishChatbotView.swift
//  Vocabie
//
//  Created by Selvarajan on 7/16/25.
//

import SwiftUI

struct ChatMessage {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct AIEnglishChatbotView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    @State private var aiService = AIDictionaryService()
    @State private var showingPromptsModal = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let usefulPrompts = [
        "Give me 10 popular words with meaning and example usage for an intermediate learner.",
        "What are 5 advanced English words I can use in a business email, with examples?",
        "Give me 10 commonly confused word pairs and explain the difference.",
        "List 5 adjectives to describe people positively, with sentence examples.",
        "Suggest 10 verbs I can use instead of “get” in different situations.",

        "Explain when to use “much” vs “many” with examples.",
        "What are 5 common grammar mistakes learners make, and how to avoid them?",
        "Show me how to convert active voice to passive voice with 3 examples.",
        "How do I use modal verbs like “could,” “should,” and “would”?",
        "Give me 5 sentence examples using the present perfect tense.",

        "Teach me 5 polite ways to ask for help in English.",
        "Give me a short conversation between two people meeting for the first time.",
        "What are 10 useful phrases I can use while shopping in English?",
        "How do I respond to small talk like “How’s it going?”",
        "Create a dialogue between a customer and waiter at a restaurant.",

        "What are 5 commonly used English idioms and their meanings?",
        "Explain 5 useful phrasal verbs related to travel with examples.",
        "What’s the meaning of “break the ice” and how can I use it in a sentence?",

        "Test me with 5 fill-in-the-blank sentences using intermediate vocabulary.",
        "Give me a daily word with meaning, synonyms, antonyms, and example usage."
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Content Section
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(alignment: .leading, spacing: 0) {
                        Text("Note: This chatbot uses Apple's on-device AI, works without an internet connection, and runs only on devices with iOS 26.")
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        // Top 3 Quick Prompts Section (Always visible)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick prompts:")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 8) {
                                ForEach(Array(usefulPrompts.prefix(3)), id: \.self) { prompt in
                                    Button(action: {
                                        messageText = prompt
                                        isTextFieldFocused = true
                                    }) {
                                        HStack {
                                            Text(prompt)
                                                .font(.subheadline)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.gray.opacity(0.5))
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color.indigo.opacity(0.05))
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 16)
                            
                            // "More prompts..." button
                            Button(action: {
                                showingPromptsModal = true
                            }) {
                                HStack {
                                    Text("More prompts...")
                                        .font(.body)
                                        .foregroundColor(.indigo)
                                    Image(systemName: "chevron.right")
                                        .font(.caption2)
                                        .foregroundColor(.indigo)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 30)
                        }
                        
                        ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                            VStack(alignment: .leading, spacing: 0) {
                                if index > 0 {
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                        .padding(.vertical, 16)
                                }
                                
                                if message.isUser {
                                    // User message
                                    HStack {
                                        Spacer()
                                        Text(message.text)
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(Color.indigo)
                                            .cornerRadius(18)
                                            .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 8)
                                } else {
                                    // AI response
                                    MarkdownText(message.text)
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, index == messages.count - 1 ? 16 : 0)
                                }
                            }
                            .id(message.id)
                        }
                        
                        // Show streaming response
                        if aiService.isAIResponding {
                            VStack(alignment: .leading, spacing: 0) {
                                if !messages.isEmpty {
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                        .padding(.vertical, 16)
                                }
                                
                                if aiService.responseText.isEmpty {
                                    HStack {
                                        ProgressView()
                                            .scaleEffect(1)
                                        Text("AI is thinking...")
                                            .foregroundColor(.indigo)
                                            .font(.body)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                } else {
                                    MarkdownText(aiService.responseText)
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 16)
                                }
                            }
                            .id("streaming")
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if let lastMessage = messages.last {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: aiService.isAIResponding) { responding in
                        if responding {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo("streaming", anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: aiService.responseText) { _ in
                        if aiService.isAIResponding {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo("streaming", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
            .background(Color(.systemBackground))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Input Section
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                HStack(spacing: 12) {
                    TextField("Type your message...", text: $messageText, axis: .vertical)
                        .textFieldStyle(PlainTextFieldStyle())
                        .lineLimit(1...4)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            sendMessage()
                        }
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.indigo)
                            .clipShape(Circle())
                    }
                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || aiService.isAIResponding)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.principal) {
                HStack {
                    Text("Ask AI")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "ellipsis.message")
                        .font(.headline)
                    Spacer()
                }
            }
            // Add a toolbar button to open the prompts popup
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingPromptsModal = true
                }) {
                    Image(systemName: "list.bullet")
                        .font(.title2)
                        .foregroundColor(.indigo)
                        .accessibilityLabel("Show helpful prompts")
                }
            }
        }
        .sheet(isPresented: $showingPromptsModal) {
            PromptsModalView(
                prompts: usefulPrompts,
                onPromptSelected: { prompt in
                    messageText = prompt
                    showingPromptsModal = false
                    isTextFieldFocused = true
                }
            )
            .preferredColorScheme(.light)
        }
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty && !aiService.isAIResponding else { return }
        
        // Add user message to messages array
        let userMessage = ChatMessage(text: trimmedMessage, isUser: true)
        messages.append(userMessage)
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        messageText = ""
        
        // Reset response text before starting new response
        aiService.responseText = ""
        
        Task {
            do {
                try await aiService.generateResponse(for: trimmedMessage)
                
                // Add the completed response to the messages array
                await MainActor.run {
                    let aiMessage = ChatMessage(text: aiService.responseText, isUser: false)
                    messages.append(aiMessage)
                }
            } catch {
                // Handle error
                await MainActor.run {
                    /*
                    let errorMessage = ChatMessage(text: "Sorry, I encountered an error: \(error.localizedDescription)", isUser: false)
                    */
                    let errorMessage = ChatMessage(text: "Sorry, I encountered an error. Please try again later.", isUser: false)
                    messages.append(errorMessage)
                }
            }
        }
    }
}

// MARK: - Prompts Modal View
struct PromptsModalView: View {
    let prompts: [String]
    let onPromptSelected: (String) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(prompts, id: \.self) { prompt in
                    Button(action: {
                        onPromptSelected(prompt)
                    }) {
                        HStack {
                            Text(prompt)
                                .font(.body)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Select a Prompt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct MarkdownText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(parseMarkdown(text), id: \.id) { element in
                element.view
            }
        }
    }
    
    private func parseMarkdown(_ text: String) -> [MarkdownElement] {
        var elements: [MarkdownElement] = []
        let lines = text.components(separatedBy: .newlines)
        var currentParagraph: [String] = []
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            if trimmedLine.isEmpty {
                if !currentParagraph.isEmpty {
                    elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
                    currentParagraph = []
                }
            } else if trimmedLine.hasPrefix("# ") {
                if !currentParagraph.isEmpty {
                    elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
                    currentParagraph = []
                }
                elements.append(MarkdownElement(type: .h1, content: String(trimmedLine.dropFirst(2))))
            } else if trimmedLine.hasPrefix("## ") {
                if !currentParagraph.isEmpty {
                    elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
                    currentParagraph = []
                }
                elements.append(MarkdownElement(type: .h2, content: String(trimmedLine.dropFirst(3))))
            } else if trimmedLine.hasPrefix("### ") {
                if !currentParagraph.isEmpty {
                    elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
                    currentParagraph = []
                }
                elements.append(MarkdownElement(type: .h3, content: String(trimmedLine.dropFirst(4))))
            } else if trimmedLine.hasPrefix("- ") || trimmedLine.hasPrefix("* ") {
                if !currentParagraph.isEmpty {
                    elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
                    currentParagraph = []
                }
                elements.append(MarkdownElement(type: .bulletPoint, content: String(trimmedLine.dropFirst(2))))
            } else if trimmedLine.hasPrefix("> ") {
                if !currentParagraph.isEmpty {
                    elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
                    currentParagraph = []
                }
                elements.append(MarkdownElement(type: .quote, content: String(trimmedLine.dropFirst(2))))
            } else if trimmedLine.hasPrefix("```") {
                if !currentParagraph.isEmpty {
                    elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
                    currentParagraph = []
                }
                elements.append(MarkdownElement(type: .codeBlock, content: String(trimmedLine.dropFirst(3))))
            } else if let match = trimmedLine.range(of: #"^\d+\. "#, options: .regularExpression) {
                if !currentParagraph.isEmpty {
                    elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
                    currentParagraph = []
                }
                elements.append(MarkdownElement(type: .numberedPoint, content: String(trimmedLine[match.upperBound...])))
            } else {
                currentParagraph.append(line)
            }
        }
        
        if !currentParagraph.isEmpty {
            elements.append(MarkdownElement(type: .paragraph, content: currentParagraph.joined(separator: " ")))
        }
        
        return elements
    }
}

struct MarkdownElement {
    let id = UUID()
    let type: MarkdownType
    let content: String
    
    var view: some View {
        switch type {
        case .h1:
            return AnyView(
                Text(parseInlineMarkdown(content))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
        case .h2:
            return AnyView(
                Text(parseInlineMarkdown(content))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
        case .h3:
            return AnyView(
                Text(parseInlineMarkdown(content))
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.vertical, 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
        case .paragraph:
            return AnyView(
                Text(parseInlineMarkdown(content))
                    .font(.body)
                    .padding(.vertical, 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
        case .bulletPoint:
            return AnyView(
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(parseInlineMarkdown(content))
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 1)
            )
        case .numberedPoint:
            return AnyView(
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(parseInlineMarkdown(content))
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 1)
            )
        case .quote:
            return AnyView(
                HStack(alignment: .top, spacing: 12) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 4)
                    Text(parseInlineMarkdown(content))
                        .font(.body)
                        .italic()
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 4)
            )
        case .codeBlock:
            return AnyView(
                Text(content)
                    .font(.system(.body, design: .monospaced))
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
        }
    }
    
    private func parseInlineMarkdown(_ text: String) -> AttributedString {
        var result = text
        
        // Replace bold text **text** with placeholder
        result = result.replacingOccurrences(of: #"\*\*(.*?)\*\*"#, with: "BOLD_START$1BOLD_END", options: .regularExpression)
        
        // Replace italic text *text* with placeholder
        result = result.replacingOccurrences(of: #"(?<!\*)\*(?!\*)([^*]+)\*(?!\*)"#, with: "ITALIC_START$1ITALIC_END", options: .regularExpression)
        
        var attributedString = AttributedString(result)
        
        // Process bold text
        while let boldStart = attributedString.range(of: "BOLD_START") {
            if let boldEnd = attributedString.range(of: "BOLD_END") {
                let boldRange = boldStart.lowerBound..<boldEnd.upperBound
                let boldContent = String(attributedString[boldStart.upperBound..<boldEnd.lowerBound].characters)
                
                var boldAttributedString = AttributedString(boldContent)
                boldAttributedString.font = .body.bold()
                
                attributedString.replaceSubrange(boldRange, with: boldAttributedString)
            } else {
                break
            }
        }
        
        // Process italic text
        while let italicStart = attributedString.range(of: "ITALIC_START") {
            if let italicEnd = attributedString.range(of: "ITALIC_END") {
                let italicRange = italicStart.lowerBound..<italicEnd.upperBound
                let italicContent = String(attributedString[italicStart.upperBound..<italicEnd.lowerBound].characters)
                
                var italicAttributedString = AttributedString(italicContent)
                italicAttributedString.font = .body.italic()
                
                attributedString.replaceSubrange(italicRange, with: italicAttributedString)
            } else {
                break
            }
        }
        
        return attributedString
    }
}

enum MarkdownType {
    case h1, h2, h3, paragraph, bulletPoint, numberedPoint, quote, codeBlock
}
