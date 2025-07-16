//
//  ViewPhrase.swift
//  Vocabie
//
//  Created by Selvarajan on 12/05/22.
//

import SwiftUI

struct ViewPhrase: View {
    @State var userPhrase: UserPhrase
    @State var selection: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(userPhrase.phrase ?? "")")
                .font(.title)
            
            Divider()
            
            Text("Definition:")
                .font(.headline)
                .padding(.top, 10)
                .padding(.bottom, 2)
                .foregroundColor(.blue)
            Text("\(userPhrase.meaning ?? "")")
                .padding(.bottom)
            
            if (userPhrase.example != nil && !userPhrase.example!.isEmpty) {
                Text("Example:")
                    .font(.headline)
                    .padding(.bottom, 2)
                    .foregroundColor(.blue)
                Text("\(userPhrase.example ?? "")")
                    .padding(.bottom)
            }
            
            if (userPhrase.tag != nil && !userPhrase.tag!.isEmpty) {
                Text("Tags:")
                    .font(.headline)
                    .padding(.bottom, 2)
                    .foregroundColor(.blue)
                Text("\(userPhrase.tag ?? "")")
                    .padding(.bottom)
            }
            
            NavigationLink(destination: EditPhrase(userPhrase: $userPhrase),
                           tag: 1,
                           selection: $selection) {
                EmptyView()
            }
            
            Divider()
            
            Button {
                selection = 1
            } label: {
                Text("Edit Phrase/Idiom")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame (height: 55)
                    .frame (maxWidth: .infinity)
                    .background (Color.indigo)
                    .cornerRadius(20)
            }.padding(.top, 25)
            Spacer()
        }
        .padding()
        .navigationTitle("View Phrase/Idiom Info")
    }
}












//struct ViewPhrase_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewPhrase()
//    }
//}
