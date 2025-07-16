//
//  EditPhrase.swift
//  Vocabie
//
//  Created by Selvarajan on 12/05/22.
//

import SwiftUI

struct EditPhrase: View {
    @Binding var userPhrase: UserPhrase
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            Form {
                Section {
                    TextField("Your Phrase/Idiom Here", text: $userPhrase.phrase.toUnwrapped(defaultValue: ""))
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("Definition: ")
                            .foregroundColor(.blue)
                        TextEditor(text: $userPhrase.meaning.toUnwrapped(defaultValue: ""))
                            .frame(height: 140)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.5))
                        
                    }.padding(.vertical, 5)
                    
                    VStack(alignment: .leading) {
                        Text("Example: ")
                            .foregroundColor(.blue)
                        TextEditor(text: $userPhrase.example.toUnwrapped(defaultValue: ""))
                            .frame(height: 120)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.5))
                        
                    }.padding(.vertical, 5)
                    
                    VStack(alignment: .leading) {
                        Text("Tags: ")
                            .foregroundColor(.blue)
                        TextEditor(text: $userPhrase.tag.toUnwrapped(defaultValue: ""))
                            .frame(height: 100)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(.gray).opacity(0.5))
                        
                    }.padding(.vertical, 5)
                    
                    Button(action: {
                        userPhrase.save()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Update Phrase/Idiom")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame (height: 55)
                            .frame (maxWidth: .infinity)
                            .background (Color.indigo)
                            .cornerRadius(20)
                    }).padding(.vertical)
                }
            }
        } //VStack
    }
}













//struct EditPhrase_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPhrase()
//    }
//}
