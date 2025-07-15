//
//  Test2.swift
//  Vocabie
//
//  Created by Selvarajan on 27/04/22.
//

import SwiftUI

struct Parent: Identifiable {
    var id = UUID()
    var name = ""
    var meaning = ""
    var example = ""
    var type = "child"
    var children: [Parent]? // Had to make this optional
}

struct Test2: View {
    var parents = [Parent(name: "Mark", type: "parent",
                          children: [Parent(meaning: "It is a long **established** fact that a reader will be distracted by the readable content of a page when looking at its layout. \n\nThe point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.")]),
                   Parent(name: "Rodrigo", type: "parent",
                          children: [Parent(meaning: "Kai"),
                                     Parent(meaning: "Brennan"),
                                     Parent(meaning: "Easton")]),
                   Parent(name: "Marcella", type: "parent",
                          children: [Parent(meaning: "Sam"),
                                     Parent(meaning: "Melissa"),
                                     Parent(meaning: "Melanie")])]
    var body: some View {
        VStack(spacing: 20.0) {
            List(parents, children: \.children) { parent in
                if (parent.type == "parent")
                {
                    Text("\(parent.name)")
                        .font(.title)
                }
                else {
                    VStack(alignment: .leading) {
                    Text("Meaning:").bold()
                    Text("\(parent.meaning)")
                        .font(.body)
                    Text("\nExample:").bold()
                    Text("\(parent.meaning)")
                    }
                }
            }
        }
        .onAppear(){
            //
//            let data: Data // received from a network request, for example
//            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let path = Bundle.main.path(forResource: "websters_dictionary", ofType: "json") {
                do {
                      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    
                    if let jsonResult = jsonResult as? [String: Any], let item = jsonResult["act"] as? String {
                        print(item)
                    }
                      
//                    if let jsonResult = jsonResult as? Dictionary, let person = jsonResult["person"] as? [Any] {
//                                // do stuff
//                      }
                  } catch {
                       // handle error
                  }
            }
        }
    }
}

struct Test2_Previews: PreviewProvider {
    static var previews: some View {
        Test2()
    }
}
