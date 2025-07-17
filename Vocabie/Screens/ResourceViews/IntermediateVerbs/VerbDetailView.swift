//
//  VerbDetailView.swift
//  Vocabie
//
//  Created by Selvarajan on 7/17/25.
//

import SwiftUI

struct VerbDetailView: View {
    let verb: Verb

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verb.verb.capitalized)
                .font(.largeTitle.bold())
                .padding(.bottom, 10)

            Divider()
            
            Text("Meaning")
                .font(.title2.bold())
            Text(verb.meaning)
                .font(.body)
                .padding(.bottom, 10)

            Divider()
            
            Text("Example")
                .font(.title2.bold())
            Text("“\(verb.example)”")
                .italic()
                .padding(.bottom, 10)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .navigationTitle("Intermediate Verb")
    }
}
