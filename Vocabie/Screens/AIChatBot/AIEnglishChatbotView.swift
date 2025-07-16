//
//  AIEnglishChatbotView.swift
//  Vocabie
//
//  Created by Selvarajan on 7/16/25.
//

import SwiftUI

struct AIEnglishChatbotView: View {
    @State private var messageText = ""
    @State private var responses: [String] = []
    @State private var aiService = AIDictionaryService()
    
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
                        
                        ForEach(Array(responses.enumerated()), id: \.offset) { index, response in
                            VStack(alignment: .leading, spacing: 0) {
                                if index > 0 {
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                        .padding(.vertical, 16)
                                }
                                
                                MarkdownText(response)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, index == responses.count - 1 ? 16 : 0)
                            }
                            .id(index)
                        }
                        
                        // Show streaming response
                        if aiService.isAIResponding {
                            VStack(alignment: .leading, spacing: 0) {
                                if !responses.isEmpty {
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
                    .onChange(of: responses.count) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo(responses.count - 1, anchor: .bottom)
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
                }.foregroundStyle(.indigo)
            }
        }
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty && !aiService.isAIResponding else { return }
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        messageText = ""
        
        // Reset response text before starting new response
        aiService.responseText = ""
        
        Task {
            do {
                try await aiService.generateResponse(for: trimmedMessage)
                
                // Add the completed response to the responses array
                await MainActor.run {
                    responses.append(aiService.responseText)
                }
            } catch {
                // Handle error
                await MainActor.run {
                    responses.append("Sorry, I encountered an error: \(error.localizedDescription)")
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
                    Text("1.")
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
