//
//  ViewUserWord.swift
//  Vocabie
//
//  Created by Selvarajan on 28/04/22.
//

import SwiftUI

struct ViewUserWord: View {
    @State var word: UserWord
    @State var selection: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(word.word ?? "")")
                .font(.title)
            
            Divider()
            Text("Definition:")
                .font(.headline)
                .padding(.top, 10)
                .padding(.bottom, 5)
                .foregroundColor(.blue)
            Text("\(word.meaning ?? "")")
                .padding(.bottom)
            
            if (word.sampleSentence != nil && !word.sampleSentence!.isEmpty) {
                Text("Example usage:")
                    .font(.headline)
                    .padding(.bottom)
                    .foregroundColor(.blue)
                Text("\(word.sampleSentence ?? "")")
            }
            
            NavigationLink(destination: EditUserWordView(userWord: $word),
                           tag: 1,
                           selection: $selection) {
                EmptyView()
            }
            
            Divider()
            
            Button {
                selection = 1
            } label: {
                Text("Edit Word")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame (height: 55)
                    .frame (maxWidth: .infinity)
                    .background (Color.indigo)
                    .cornerRadius(10)
            }.padding(.top, 25)
            Spacer()
        }
        .padding()
        .navigationTitle("View Word Info")
    }
}

//struct ViewUserWord_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewUserWord()
//    }
//}
