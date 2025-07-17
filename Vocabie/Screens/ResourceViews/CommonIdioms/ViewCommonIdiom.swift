//
//  ViewCommonIdiom.swift
//  Vocabie
//
//  Created by Selvarajan on 11/07/22.
//

import SwiftUI

struct ViewCommonIdiom: View {
    @State var commonPhrase: CommonPhrase
    @State var selection: Int? = nil
    
    func formatText(_ content: String) -> String {
        return content.replacingOccurrences(of: "\\n", with: "\n")
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(commonPhrase.phrase ?? "")")
                .font(.title)
            
            Divider()
            
            if commonPhrase.meaning != nil {
                Text("Meaning:")
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                    .foregroundColor(.blue)
                Text(formatText(commonPhrase.meaning ?? ""))
                    .padding(.bottom)
                
                Divider()
            }
            
            if (commonPhrase.example != nil && !commonPhrase.example!.isEmpty) {
                Text("Example:")
                    .font(.headline)
                    .padding(.bottom, 2)
                    .foregroundColor(.blue)
                Text(formatText(commonPhrase.example ?? ""))
                    .lineLimit(10)
                    .padding(.bottom)
                
                Divider()
            }
             
            Spacer()
        }
        .padding(20)
        .navigationTitle("Common Idiom")
    }
}

//struct ViewCommonIdiom_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewCommonIdiom()
//    }
//}
