//
//  AddUserWordView.swift
//  Vocabie
//
//  Created by Selvarajan on 14/03/22.
//

import SwiftUI



struct AddUserWordView: View {
    @StateObject var userWordListVM = UserWordListViewModel()
    
    @State var word: String = ""
    @State private var type: WORD_TYPE = WORD_TYPE.noun
    @State private var tag: String = ""
    @State private var sampleSentence: String = ""
    @State private var definition: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?

    init(newWord: String) {
        word = newWord
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Your Word Here", text: $word)
                        .font(.title2)
                        .focused($focusedField, equals: .field)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    
                    VStack(alignment: .leading) {
                        Text("Definition: ")
                            .foregroundColor(.blue)
                        TextEditor(text: $definition)
                            .frame(height: 140)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.5))
                        
                    }.padding(.vertical, 5)
                    
                    VStack(alignment: .leading) {
                        Text("Example Usage: ")
                            .foregroundColor(.blue)
                        TextEditor(text: $sampleSentence)
                            .frame(height: 120)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.5))
                        
                    }.padding(.vertical, 5)
                    
                    VStack(alignment: .leading) {
                        Text("Tags: ")
                            .foregroundColor(.blue)
                        TextEditor(text: $tag)
                            .frame(height: 100)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.5))
                        
                    }.padding(.vertical, 5)
                    
                    Button(action: {
                        userWordListVM.saveWord(word: word,
                                                tag: tag,
                                                meaning: definition,
                                                sampleSentence: sampleSentence)
                        
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save Word")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame (height: 55)
                            .frame (maxWidth: .infinity)
                            .background (Color.indigo)
                            .cornerRadius(20)
                    })
                    
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    /// Anything over 0.5 seems to work
                    self.focusedField = .field
                }
            }
        }
        
    }
}

//struct AddWord_Previews: PreviewProvider {
//    static var previews: some View {
//        AddUserWordView()
//    }
//}
