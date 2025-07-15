//
//  CoreDataProvider.swift
//  Vocabie
//
//  Created by Selvarajan on 13/03/22.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataProvider {
    
    let persistentContainer: NSPersistentCloudKitContainer
    
    static let shared = CoreDataProvider()
    
    private init() {
        
        persistentContainer = NSPersistentCloudKitContainer(name: "VocabieModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to initialize Core Data \(error)")
            }
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
//        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        print(directories[0])
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveWord(newword: String, tag: String, meaning: String, sampleSentences: String){
        let userWord = UserWord(context: viewContext)
        
        userWord.word = newword
        userWord.tag = tag
        userWord.meaning = meaning
        userWord.sampleSentence = sampleSentences
        userWord.creationDate = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save userWord entry")
        }
    }
    
    func deleteLoo(userWord: UserWord) {
        viewContext.delete(userWord)
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Failed to save context \(error)")
        }
    }
    
    func getAllUserWords() -> [UserWord] {
        let fetchRequest : NSFetchRequest<UserWord> = UserWord.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func updateUserWord(userWord: UserWord){
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
        }
    }
}
