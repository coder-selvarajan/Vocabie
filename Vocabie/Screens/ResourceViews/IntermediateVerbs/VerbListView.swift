//
//  VerbListView.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import SwiftUI

struct VerbListView: View {
    @StateObject private var viewModel = VerbListViewModel()

    @State private var searchText = ""

    var filteredVerbs: [Verb] {
        if searchText.isEmpty {
            return viewModel.verbs
        } else {
            return viewModel.verbs.filter {
                $0.verb.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        List(filteredVerbs) { verb in
            NavigationLink(destination: VerbDetailView(verb: verb)) {
                Text(verb.verb.capitalized)
                    .font(.headline)
            }
        }
        .navigationTitle("Intermediate Verbs")
        .searchable(text: $searchText, prompt: "Search intermediate verbs...")
    }

}
