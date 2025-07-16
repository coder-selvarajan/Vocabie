//
//  FlipCardGame.swift
//  Vocabie
//
//  Created by Selvarajan on 06/04/22.
//

import SwiftUI

struct SpellWord: View {
    @StateObject var userWordListVM = UserWordListViewModel()
    @State var word: String = ""
    @State var definition: String = ""
    @State var userWord: String = ""
    @State var success: Bool = false
    @State var showResult: Bool = false
    @State private var score = 0
    @State private var currentQuestionIndex = 1
    @State private var questionsCount = 5
    @State private var gameOver = false
    @State private var confettiCounter: Int = 0
    @State var navigationSelection: Int? = nil
    
    var endWord : [String] = ["Start Practicing", "Practice More", "Practice Hard", "Great", "Excellent", "AWESOME"]
    var endConfetti : [Int] = [0,0,0,0,0,2]
    
    enum FocusField: Hashable {
        case answerField
    }
    @FocusState private var focusedField: FocusField?
    func textBackgroundColor() -> Color {
        if showResult {
            return success ? .green : .red
        }
        
        return .gray
    }
    var body: some View {
        if !gameOver {
            ScrollView {
                VStack {
                    
                    HStack {
                        Text("Question \(currentQuestionIndex)/\(questionsCount)")
                            .font(.headline)
                        Spacer()
                        Text("Score \(score)")
                            .font(.headline)
                            .foregroundColor(.cyan)
                    }.padding(15)
                    
                    Divider()
                    
                    VStack {
                        Text("\(definition)")
                            .font(.body)
                            .lineLimit(5)
                    }
                    .padding()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "f5f5f5"))
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .padding()
                    
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(textBackgroundColor())
                            .font(.title3)
                        TextField("Type your word here...", text: $userWord)
                            .font(.title3)
                            .focused($focusedField, equals: .answerField)
                            .submitLabel(SubmitLabel.go)
                            .onSubmit {
                                showResult = true
                                if (word.lowercased().trim() == userWord.lowercased().trim()) {
                                    success = true
                                    score += 1
                                }
                                else {
                                    success = false
                                }
                            }
                        
                    }
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(textBackgroundColor(), lineWidth: 1))
                    .padding(.horizontal, 20)

                    if (showResult) {
                        if (success) {
                            Text("Correct Answer!")
                                .font(.body)
                                .foregroundColor(.green)
                                .padding(15)
                        }
                        else {
                            VStack {
                                Text("Wrong Answer!")
                                    .font(.body)
                                    .foregroundColor(.red)
                                Text("The correct one is '\(word.trim())'")
                                    .font(.body)
                            }.padding(15)
                        }
                    }
                    else {
                        Text("   ")
                            .font(.body)
                            .foregroundColor(.green)
                            .padding(15)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        userWord = ""
                        self.focusedField = .answerField
                        
                        if currentQuestionIndex >= questionsCount {
                            gameOver = true
                            return
                        }
                        
                        showResult = false
                        success = false
                        let wordObject = userWordListVM.pickRandomWord()
                        word = wordObject.word ?? ""
                        definition = wordObject.meaning ?? ""
                        currentQuestionIndex += 1
                    }, label: {
                        HStack {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .aspectRatio(contentMode: ContentMode.fit)
                            Text("NEXT")
                                .font(.title3)
                        }
                        .padding()
                        .foregroundColor( showResult ? .white : .gray)
                        .frame (height: 55)
                        .background (Color.indigo)
                        .cornerRadius(20)
                    })
                    .padding()
                    Spacer()
                    
                }
                .navigationTitle("Word Finder Game")
                .onAppear(){
                    userWordListVM.getAllUserWordEntries()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let wordObject = userWordListVM.pickRandomWord()
                        word = wordObject.word ?? ""
                        definition = wordObject.meaning ?? ""
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        /// Anything over 0.5 seems to work
                        self.focusedField = .answerField
                    }
                }
            }
        }
        else {
            
            ZStack {
                VStack {
                    Text("Game Over")
                        .font(.title2)
                        .padding(20)
                    Text("Your score is \(score) out of \(questionsCount)")
                        .font(.headline)
                    Spacer()
                    
                    Text("\(endWord[score])!")
                        .font(.largeTitle)
                        .foregroundColor(.indigo)
//                        .confettiCannon(counter: $confettiCounter, repetitions: endConfetti[score], repetitionInterval: 0.3)
                    
                    Spacer()
                    HStack {
                        Button {
                            userWord = ""
                            showResult = false
                            success = false
                            let wordObject = userWordListVM.pickRandomWord()
                            word = wordObject.word ?? ""
                            definition = wordObject.meaning ?? ""
                            currentQuestionIndex = 1
                            score = 0
                            gameOver = false
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .aspectRatio(contentMode: ContentMode.fit)
                                Text("Restart")
                                    .font(.title3)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .frame (height: 55)
                            .background (Color.indigo)
                            .cornerRadius(20)
                        }
                        
//                        NavigationLink(destination: HomeView(), tag: 1, selection: $navigationSelection) {
//                            Button {
//                                navigationSelection = 1
//                            } label: {
//                                HStack {
//                                    Image(systemName: "arrow.backward.square")
//                                        .resizable()
//                                        .aspectRatio(contentMode: ContentMode.fit)
//                                    Text("Exit")
//                                        .font(.title3)
//                                }
//                                .padding()
//                                .foregroundColor(.white)
//                                .frame (height: 55)
//                                .background (Color.indigo)
//                                .cornerRadius(20)
//                            }
//                        }
                    }
                    
                    Spacer()
                }
                .onAppear(){
                    if score > 3 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            confettiCounter += 1
                        }
                    }
                }
            }
            
        }
        //        .background(Color.pink.opacity(0.2)).ignoresSafeArea()
    }
}

//struct WordFinder_Previews: PreviewProvider {
//    static var previews: some View {
//        WordFinder()
//    }
//}
