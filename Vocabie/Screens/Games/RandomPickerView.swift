//
//  RandomPickerView.swift
//  Vocabie
//
//  Created by Selvarajan on 15/04/22.
//

import SwiftUI

struct RandomPickerView: View {
    @StateObject var userSentenceListVM = UserSentenceListViewModel()
    @StateObject var userWordListVM = UserWordListViewModel()
    @StateObject var userPhraseListVM = UserPhraseListViewModel()
    
    @State var sentence: String = ""
    @State private var type: Int = 1
    
    @State private var randomVocabulary: String = ""
    @State private var definition: String = ""
    
    
    func pickItem() {
        if type == 1 { // "word"
            let wordObject = userWordListVM.pickRandomWord()
            randomVocabulary = wordObject.word ?? ""
            definition = wordObject.meaning ?? ""
        }
        if type == 2 { // "sentence"
            let sentenceObject = userSentenceListVM.pickRandomSentence()
            randomVocabulary = sentenceObject.sentence ?? ""
        }
        if type == 3 { // "phrase"
            let phraseObject = userPhraseListVM.pickRandomPhrase()
            randomVocabulary = phraseObject.phrase ?? ""
            definition = phraseObject.meaning ?? ""
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Random words from your vocabulary is displayed here for you to guess the meaning. ")
                .padding()
            /*
            Picker("", selection: $type) {
                Text("Word")
                    .tag(1)
                Text("Phrase/Idiom").tag(3)
                Text("Sentence").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: type, perform: { value in
                randomVocabulary = ""
                definition = ""
                
                pickItem()
            })
            */
            
            FlipView {
                Text("\(randomVocabulary)")
                    .font(type == 1 ? .title : .title3)
            } back: {
                Text("\(definition)")
                    .cornerRadius(20)
            }
            if (randomVocabulary != "" && type != 2) {
                Text("Tap to flip the card")
                    .font(.subheadline)
                    .padding(.horizontal, 40)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                pickItem()
            }, label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                    Text(" Next")
                        .font(.title3)
                }
                .padding()
                .foregroundColor(.white)
                .frame (height: 55)
                .background (Color.indigo)
                .cornerRadius(20)
            })
            .padding()
            Spacer()
        }
        .navigationTitle("Random Picker")
        .onAppear(){
            userWordListVM.getAllUserWordEntries()
            userSentenceListVM.getAllUserSentenceEntries()
            userPhraseListVM.getAllUserPhraseEntries()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                pickItem()
            }
            
            
        }
    }
}

//struct RandomPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RandomPickerView()
//    }
//}
