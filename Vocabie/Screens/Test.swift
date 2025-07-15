//
//  Test.swift
//  Vocabie
//
//  Created by Selvarajan on 01/04/22.
//

import SwiftUI

//Navigation demo
//struct Test: View {
//    let names = ["Holly", "Josh", "Rhonda", "Ted"]
//    @State private var searchText = ""
//
//    var body: some View {
//        List {
//            ForEach(searchResults, id: \.self) { name in
//                NavigationLink(destination: Text(name)) {
//                    Text(name)
//                }
//            }
//        }
//        .searchable(text: $searchText)
//        .navigationTitle("Contacts")
//    }
//
//    var searchResults: [String] {
//        if searchText.isEmpty {
//            return names
//        } else {
//            return names.filter { $0.contains(searchText) }
//        }
//    }
//}


struct Test: View {
    // how far the circle has been dragged
    @State private var offset = CGSize.zero

    // whether it is currently being dragged or not
    @State private var isDragging = false

    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }

        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }

        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)

        // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
        Circle()
            .fill(.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
    }
}


struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
