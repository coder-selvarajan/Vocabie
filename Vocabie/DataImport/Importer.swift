//
//  Importer.swift
//  Vocabie
//
//  Created by Selvarajan on 11/07/22.
//

import Foundation
import SwiftCSV
import CoreData
import SwiftUI
/*
 SwiftCSV package
 ----------------
 
 CSV object format:
    csv.header   //=> ["id", "name", "age"]
    csv.rows     //=> [["id": "1", "name": "Alice", "age": "18"]]
    csv.columns  //=> ["id": ["1", "2"], "name": ["Alice", "Bob"], "age": ["18", "19"]]
*/

struct CommonIdiom: Identifiable, Codable {
    var idiom: String = ""
    var meaning: String = ""
    var example: String = ""
    var id = UUID()
    
    init(raw: [String]) {
        idiom = raw[0]
        meaning = raw[1]
        example = raw[2]
    }
    
    init(idiom: String, meaning: String, example: String) {
        self.idiom = idiom
        self.meaning = meaning
        self.example = example
    }
}

func saveIdioms(idioms: [CommonIdiom]) -> Bool {
    // core data operations here
    
    if deleteAllIdioms() == false {
        return false
    }
    
    for idiom in idioms {
        let commonPhrase = CommonPhrase(context: CommonPhrase.viewContext)
        commonPhrase.creationDate = Date()
        commonPhrase.phrase = idiom.idiom
        commonPhrase.meaning = idiom.meaning
        commonPhrase.example = idiom.example
        commonPhrase.type = "Idiom"

        commonPhrase.save()
    }
    
    return true
}

func deleteAllIdioms() -> Bool {
    // Create fetch-request & Batch-delete-request and execute
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CommonPhrase")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
        try CommonPhrase.viewContext.execute(batchDeleteRequest)

    } catch {
        // Error Handling
        return false
    }
    
    return true
}

func importIdiomCSV(name csvName: String) -> Bool {
    var idiomArray = [CommonIdiom]()
    
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return false
    }
    
    //conversion
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    }
    catch {
        print(error)
        return false
    }
    
    do {
        let csv = try CSV<Named>(string: data)
        for row in csv.rows {
            print(row["idiom"] ?? "")
            let commonIdiom = CommonIdiom.init(idiom: row["idiom"] ?? "",
                                               meaning: row["meaning"] ?? "",
                                               example: row["example"] ?? "")
            idiomArray.append(commonIdiom)
        }
        
        //call to import the object into coredata
        let saveStatus = saveIdioms(idioms: idiomArray)
        return saveStatus
    }
    catch {
        print(error.localizedDescription)
        return false
    }
    
}
