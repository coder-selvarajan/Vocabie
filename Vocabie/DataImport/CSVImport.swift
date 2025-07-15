//
//  CSVImport.swift
//  Vocabie
//
//  Created by Selvarajan on 10/07/22.
//

import Foundation
import SwiftCSV

struct CommonIdiomOld: Identifiable {
    var idiom: String = ""
    var meaning: String = ""
    var example: String = ""
    var id = UUID()
    var objType: String = ""
    var children : [CommonIdiomOld]?
    
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

func loadCSV(from csvName: String) -> [CommonIdiomOld] {
    var csv2Array = [CommonIdiomOld]()
    
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return []
    }
    
    //conversion
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    }
    catch {
        print(error)
        return []
    }
    
    var rows = data.components(separatedBy: "\n")
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    for row in rows {
        let csvColumns = row.components(separatedBy: ",")
        if csvColumns.count == columnCount {
            let commonIdiomStruct = CommonIdiomOld.init(raw: csvColumns)
            csv2Array.append(commonIdiomStruct)
        }
    }
    
    return csv2Array
}

func loadCSVData(from data: String) -> [CommonIdiomOld] {
    var csv2Array = [CommonIdiomOld]()
    
    guard data != "" else {
        return []
    }
    
    var rows = data.components(separatedBy: "\n")
    let columnCount = rows.first?.components(separatedBy: ",").count
    rows.removeFirst()
    
    for row in rows {
        let csvColumns = row.split(separator: ",", omittingEmptySubsequences: true) //row.components(separatedBy: ",")
        if csvColumns.count == columnCount {
            //            let commonIdiomStruct = CommonIdiom.init(raw: csvColumns)
            let commonIdiomStruct = CommonIdiomOld.init(idiom: String(csvColumns[0]),
                                                     meaning: String(csvColumns[1]),
                                                     example: String(csvColumns[2]))
            csv2Array.append(commonIdiomStruct)
        }
    }
    
    return csv2Array
}

func readCSVData(from data: String) -> [CommonIdiomOld] {
    var idiomArray = [CommonIdiomOld]()
    guard data != "" else {
        return []
    }
    
    do {
        let csv = try CSV<Named>(string: data)
        //    csv.header   //=> ["id", "name", "age"]
        //    csv.rows     //=> [["id": "1", "name": "Alice", "age": "18"]]
        //    csv.columns  //=> ["id": ["1", "2"], "name": ["Alice", "Bob"], "age": ["18", "19"]]
        
        for row in csv.rows {
            var commonIdiom = CommonIdiomOld.init(idiom: row["idiom"] ?? "",
                                               meaning: row["meaning"] ?? "",
                                               example: row["example"] ?? "")
            let childIdiom = CommonIdiomOld.init(idiom: row["idiom"] ?? "",
                                              meaning: row["meaning"] ?? "",
                                              example: row["example"] ?? "")
            commonIdiom.objType = "parent"
            commonIdiom.children = [childIdiom]
            
            idiomArray.append(commonIdiom)
        }
    }
    catch {
        print(error.localizedDescription)
        return []
    }
    
    return idiomArray
}
