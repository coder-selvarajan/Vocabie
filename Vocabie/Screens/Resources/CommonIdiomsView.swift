//
//  CommonIdiomsView.swift
//  Vocabie
//
//  Created by Selvarajan on 11/07/22.
//

import SwiftUI

struct CommonIdiomsView: View {
    @StateObject var commonIdiomsListVM = CommonPhraseViewModel()
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(searchResults, id:\.objectID) {commonIdiom in
                NavigationLink(
                    destination: ViewCommonIdiom(commonPhrase: commonIdiom),
                    label: {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(commonIdiom.phrase ?? "")")
                                .font(.headline)
                                .bold()
                        }
                    })
            }
        }
        .listStyle(.grouped)
        .navigationTitle(Text("Common Idioms"))
        .searchable(text: $searchText)
        .onAppear {
            commonIdiomsListVM.getAllCommonPhrases()
        }
    }
    
    var searchResults: [CommonPhrase] {
        if searchText.isEmpty {
            return commonIdiomsListVM.commonPhraseAll
        } else {
            return commonIdiomsListVM.commonPhraseAll.filter { $0.phrase!.lowercased().contains(searchText.lowercased()) }
        }
    }
}

//struct CommonIdiomsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommonIdiomsView()
//    }
//}
