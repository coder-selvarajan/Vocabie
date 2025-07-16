//
//  PickMeaningHome.swift
//  Vocabie
//
//  Created by Selvarajan on 24/04/22.
//

import SwiftUI

struct PickDefinitionHome: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("You will be given four choices for a word. You need to tick the correct definition.").padding()
            
            Spacer()
            
            NavigationLink(
                destination: PickMeaning(),
                label: {
                    HStack {
                        Image(systemName: "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fit)
                            .frame(width: 25, height: 25)
                            .padding(10)
                        Text("Start with my words")
                            .font(.title2)
                        
                        Spacer()
                    }
                    .padding(10)
                    .foregroundColor(.white)
                    .background (Color.indigo)
                    .cornerRadius(20)
                    .padding(.horizontal)
                })
            
            NavigationLink(
                destination: PickMeaning(),
                label: {
                    HStack {
                        Image(systemName: "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fit)
                            .frame(width: 25, height: 25)
                            .padding(10)
                        Text("Start with common words")
                            .font(.title2)
                        
                        Spacer()
                    }
                    .padding(10)
                    .foregroundColor(.white)
                    .background (Color.blue)
                    .cornerRadius(20)
                    .padding(.horizontal)
                })

            Spacer()
        }
        .navigationTitle("Pick Definition Game")
    }
}

struct PickMeaningHome_Previews: PreviewProvider {
    static var previews: some View {
        PickDefinitionHome()
    }
}
