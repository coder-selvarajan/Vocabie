//
//  WordList.swift
//  Vocabie
//
//  Created by Selvarajan on 28/03/22.
//

import SwiftUI

struct UserWordList: View {
    @StateObject var userWordListVM = UserWordListViewModel()
    @State private var searchText = ""
    
    func delete(at indexes: IndexSet) {
        indexes.forEach { index in
            let userWord = userWordListVM.userWordAllEntries[index]
            userWordListVM.deleteWord(word: userWord)
        }
    }
    
    var body: some View {
        List {
            ForEach(searchResults, id:\.objectID) {userword in
                NavigationLink(
                    destination: ViewUserWord(word: userword),
                    label: {
                        HStack {
                            Text("\(userword.word ?? "")")
                                .font(.headline)
                                .bold()
                            Text(" \(userword.meaning ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }.padding(.vertical, 10)
                    })
            }
            .onDelete(perform: delete)
        }
        .listStyle(.grouped)
        .navigationTitle(Text("Word List"))
        .searchable(text: $searchText)
        .onAppear {
            userWordListVM.getAllUserWordEntries()
        }
    }
    
    var searchResults: [UserWord] {
        if searchText.isEmpty {
            return userWordListVM.userWordAllEntries
        } else {
            return userWordListVM.userWordAllEntries.filter { $0.word!.contains(searchText) }
        }
    }
}

struct UserWordList_Previews: PreviewProvider {
    static var previews: some View {
        UserWordList()
    }
}
