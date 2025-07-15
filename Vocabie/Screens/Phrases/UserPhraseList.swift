//
//  PhraseList.swift
//  Vocabie
//
//  Created by Selvarajan on 28/03/22.
//

import SwiftUI

struct UserPhraseList: View {
    @StateObject var userPhraseListVM = UserPhraseListViewModel()
    @State private var searchText = ""
    
    func delete(at indexes: IndexSet) {
        indexes.forEach { index in
            let userPhrase = userPhraseListVM.userPhraseAllEntries[index]
            userPhraseListVM.deletePhrase(phrase: userPhrase)
        }
    }
    
    var body: some View {
        List {
            ForEach(searchResults, id:\.objectID) {userPhrase in
                NavigationLink(
                    destination: ViewPhrase(userPhrase: userPhrase),
                    label: {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(userPhrase.phrase ?? "")")
                                .font(.headline)
                                .bold()
                            Text("\(userPhrase.meaning ?? "")").font(.subheadline).foregroundColor(.secondary)
                        }
                    })
            }
            .onDelete(perform: delete)
        }
        .listStyle(.grouped)
        .navigationTitle(Text("Phrase / Idiom List"))
        .searchable(text: $searchText)
        .onAppear {
            userPhraseListVM.getAllUserPhraseEntries()
        }
    }
    
    var searchResults: [UserPhrase] {
        if searchText.isEmpty {
            return userPhraseListVM.userPhraseAllEntries
        } else {
            return userPhraseListVM.userPhraseAllEntries.filter { $0.phrase!.contains(searchText) }
        }
    }
}


struct UserPhraseList_Previews: PreviewProvider {
    static var previews: some View {
        UserPhraseList()
    }
}
