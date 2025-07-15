//
//  CommonIdioms.swift
//  Vocabie
//
//  Created by Selvarajan on 10/07/22.
//

import SwiftUI

struct CommonIdioms: View {
    @State var commonIdioms: [CommonIdiomOld] = []
    @State var fileName = "No File Selected"
    @State var openFile = false
    
    var body: some View {
        
        HStack {
            Text(fileName)
                .fontWeight(.bold)
                
            Spacer()
            Button {
                openFile.toggle()
            } label: {
                Text("Import").bold()
            }
        }
        .padding()
        .background(.black)
        .padding(.horizontal)
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.commaSeparatedText]) { (res) in
            var csvData = ""
            do {
                let fileUrl = try res.get()

                if fileUrl.startAccessingSecurityScopedResource() {
                    csvData = try String(contentsOfFile: fileUrl.path)
                }
                fileUrl.stopAccessingSecurityScopedResource()
                
                self.fileName = fileUrl.lastPathComponent
                commonIdioms = readCSVData(from: csvData)
//                commonIdioms = loadCSVData(from: csvData)
            }
            catch {
                print("Error reading csv")
                print(error.localizedDescription)
            }
        }
        .navigationTitle(Text("Common Idioms"))
        
        List(commonIdioms, children: \.children) { commonIdiom in
            
            if (commonIdiom.objType == "parent")
            {
                Text(commonIdiom.idiom)
                    .font(.title3)
            }
            else {
                VStack(alignment: .leading) {
                    Text("Meaning:")
                        .foregroundColor(.blue)
                    Text("\(commonIdiom.meaning)")
                        .font(.body)
                    Text("\nExample:")
                        .foregroundColor(.blue)
                    Text("\(commonIdiom.example)")
                }
            }
        }
    }
}

//struct CommonIdioms_Previews: PreviewProvider {
//    static var previews: some View {
//        CommonIdioms()
//    }
//}
