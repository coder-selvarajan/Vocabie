//
//  CommonPhraseViewModel.swift
//  Vocabie
//
//  Created by Selvarajan on 11/07/22.
//

import Foundation
import CoreData

class CommonPhraseViewModel: ObservableObject {
    @Published var commonPhraseAll = [CommonPhrase]()
    @Published var commonIdiomsAll = [CommonPhrase]()
    
    func getAllCommonPhrases() {
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(keyPath: \CommonPhrase.phrase, ascending: true)
        let commonPhraseEntries : [CommonPhrase] = CommonPhrase.all(sortBy: sortDescriptor)

        DispatchQueue.main.async {
            self.commonPhraseAll = commonPhraseEntries
        }
    }
    
    func getAllCommonIdioms() {
        //check whether the search-word already exist, if so delete it
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CommonPhrase")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "type ==[c] Idiom")

        do {
            let items = try CommonPhrase.viewContext.fetch(fetchRequest) as! [CommonPhrase]
            self.commonIdiomsAll = items
            
        } catch {
            // error handling
        }
    }
    
    func deleteAllCommonPhrases() {
        // Create fetch-request & Batch-delete-request and execute
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CommonPhrase")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try CommonPhrase.viewContext.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
        
        getAllCommonPhrases()
    }
}
