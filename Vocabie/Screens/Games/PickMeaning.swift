//
//  WordFinder.swift
//  Vocabie
//
//  Created by Selvarajan on 23/04/22.
//

import SwiftUI
//import ConfettiSwiftUI

struct PickMeaning: View {
    @StateObject var vmWordList = UserWordListViewModel()
    @State var randomWords = [UserWord]()
    @State private var answerSelection = 1
    @State private var correctAnswerIndex: Int = 0
    @State private var showResult = false
    @State private var userIsCorrect = false
    @State private var score = 0
    @State private var currentQuestionIndex = 1
    @State private var questionsCount = 5
    @State private var gameOver = false
    
    @State private var counter: Int = 0
    
    @State var choiceColors: [Color] = [Color(hex: "ececec"),
                                        Color(hex: "ececec"),
                                        Color(hex: "ececec"),
                                        Color(hex: "ececec")]
    
    @State var choiceIcons: [String] = ["circlebadge",
                                        "circlebadge",
                                        "circlebadge",
                                        "circlebadge"]
    
    var endWord : [String] = ["Start Practicing", "Practice More", "Practice Hard", "Great", "Excellent", "AWESOME"]
    var endConfetti : [Int] = [0,0,0,0,0,2]
    
    func get30Characters(_ str: String) -> String {
        return String(str.prefix(100))
    }
    
    var body: some View {
        if !gameOver {
            ScrollView {
                VStack {
                    HStack {
                        Text("Question: \(currentQuestionIndex)/\(questionsCount)")
                            .font(.headline)
                        Spacer()
                        Text("Score: \(score)")
                            .font(.headline)
                            .foregroundColor(.cyan)
                    }.padding(10)
                    
                    Divider()
                    
                    Spacer()
                    
                    if (randomWords.count > 0) {
                        Text("Word:")
                            .font(.caption)
                        Text(randomWords[correctAnswerIndex].word!)
                            .font(.largeTitle)
                            .foregroundColor(.indigo)
                            
                        Spacer()
                        // Choose the definition that best matches the word below:
                        Text("Choose the definition that best matches the word below: ")
                            .font(.headline)
                            .padding(.vertical, 15)
                        VStack {
                            ForEach(randomWords.indices, id:\.self) { index in
                                Button {
                                    showResult = true
                                    choiceIcons[correctAnswerIndex] = "checkmark.circle"
                                    if (index == correctAnswerIndex) {
                                        userIsCorrect = true
                                        score += 1
                                        choiceColors[correctAnswerIndex] = Color.green
                                    }
                                    else {
                                        userIsCorrect = false
                                        choiceColors[index] = Color.red
                                        choiceIcons[index] = "multiply.circle"
                                    }
                                } label: {
                                    HStack(alignment: .center) {
                                        Image(systemName: choiceIcons[index])
                                            .resizable()
                                            .aspectRatio(contentMode: ContentMode.fit)
                                            .foregroundColor(.black.opacity(0.5))
                                            .frame(width: 30)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 10)
                                        Text("\(randomWords[index].meaning ?? "")")
                                            .lineLimit(3)
                                            .font(.body)
                                            .padding(.vertical, 5)
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(TextAlignment.leading)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 0)
                                    .background(choiceColors[index])
                                }
                                .padding(0)
                                .disabled(showResult)
                                
                                Divider()
                            }
                        }
                        .background(Color(hex: "ececec"))
                        .cornerRadius(10)
                        .padding(.horizontal, 15)
                        
                        
                        if (showResult) {
                            if (userIsCorrect) {
                                Text("Correct answer")
                                    .font(.body)
                                    .foregroundColor(.green)
                            }
                            else {
                                Text("Wrong answer")
                                    .font(.body)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentQuestionIndex >= questionsCount {
                            gameOver = true
                            return
                        }
                        showResult = false
                        userIsCorrect = false
                        randomWords = vmWordList.pickRandomWords(4)
                        correctAnswerIndex = Int.random(in: 0...3)
                        currentQuestionIndex += 1
                        choiceColors = [Color(hex: "ececec"),
                                        Color(hex: "ececec"),
                                        Color(hex: "ececec"),
                                        Color(hex: "ececec")]
                        choiceIcons = ["circlebadge",
                                       "circlebadge",
                                       "circlebadge",
                                       "circlebadge"]
                        
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
                        .cornerRadius(10)
                    })
                    .padding()
                    .disabled(!showResult)
                    
                    Spacer()
                    
                }
                .navigationTitle("Choose the Definition")
                .onAppear(){
                    vmWordList.getAllUserWordEntries()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        randomWords = vmWordList.pickRandomWords(4)
                        correctAnswerIndex = Int.random(in: 0...3)
                    }
                }
            }
        }
        else
        {
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
//                        .confettiCannon(counter: $counter, repetitions: endConfetti[score], repetitionInterval: 0.3)
                    
                    Spacer()
                    Button {
                        showResult = false
                        userIsCorrect = false
                        randomWords = vmWordList.pickRandomWords(4)
                        correctAnswerIndex = Int.random(in: 0...3)
                        currentQuestionIndex = 1
                        score = 0
                        choiceColors = [Color(hex: "ececec"),
                                        Color(hex: "ececec"),
                                        Color(hex: "ececec"),
                                        Color(hex: "ececec")]
                        choiceIcons = ["circlebadge",
                                       "circlebadge",
                                       "circlebadge",
                                       "circlebadge"]
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
                        .cornerRadius(10)
                    }
                    Spacer()
                }
                .onAppear(){
                    if score > 3 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            counter += 1
                        }
                    }
                }
            }
        }
    }
}

//struct PickMeaning_Previews: PreviewProvider {
//    static var previews: some View {
//        PickMeaning()
//    }
//}
