//
//  SearchHistoryViewModel.swift
//  Vocabie
//
//  Created by Selvarajan on 10/05/22.
//

import Foundation
import CoreData

class SearchHistoryViewModel: ObservableObject {
    @Published var searchHistoryAllEntries = [SearchHistory]()
    @Published var searchHistoryRecentEntries = [SearchHistory]()
    
    func getAllSearchEntries() {
        let searchEntries : [SearchHistory] = SearchHistory.all()

        DispatchQueue.main.async {
            self.searchHistoryAllEntries = searchEntries
        }
    }
    
    func getRecentSearchEntries() {
        let searchEntries : [SearchHistory] = SearchHistory.getRecentRecords(limit: 15)

        DispatchQueue.main.async {
            self.searchHistoryRecentEntries = searchEntries
        }
    }
    
    func saveSearchEntry(word: String, definition: String) {
        //check whether the search-word already exist, if so delete it
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "word ==[c] %@", word)

        do {
            let items = try SearchHistory.viewContext.fetch(fetchRequest) as! [SearchHistory]
            
            for item in items {
                SearchHistory.viewContext.delete(item)
            }
            
            // Save Changes
            try SearchHistory.viewContext.save()
            
        } catch {
            // error handling
        }
        
        // Save the current search-word now
        let searchEntry = SearchHistory(context: SearchHistory.viewContext)
        searchEntry.creationDate = Date()
        searchEntry.word = word
        searchEntry.definition = definition
        searchEntry.save()
    }
    
    func deleteAll(){
        // Create fetch-request & Batch-delete-request and execute
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try SearchHistory.viewContext.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
        
        getRecentSearchEntries()
    }
    
    func deleteSearchEntry(searchEntry: SearchHistory) {
        let searchHistoryItem: SearchHistory? = SearchHistory.byId(id: searchEntry.objectID)
        
        if let searchHistoryItem = searchHistoryItem {
            searchHistoryItem.delete()
            getAllSearchEntries()
            getRecentSearchEntries()
        }
    }
}
