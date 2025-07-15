//
//  AddUserWordView.swift
//  Vocabie
//
//  Created by Selvarajan on 14/03/22.
//

import SwiftUI

struct AddUserSentenceView: View {
    @StateObject var userSentenceListVM = UserSentenceListViewModel()
    @State private var sentence: String = ""
    @State private var tag: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Sentence: ")
                            .foregroundColor(.blue)
                        TextEditor(text: $sentence)
                            .frame(height: 100)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.5))
                            .focused($focusedField, equals: .field)
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
                        userSentenceListVM.saveSentence(sentence: sentence, tag: tag)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save Sentence")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame (height: 55)
                            .frame (maxWidth: .infinity)
                            .background (Color.blue)
                             .cornerRadius(10)
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

struct AddUserSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserSentenceView()
    }
}
