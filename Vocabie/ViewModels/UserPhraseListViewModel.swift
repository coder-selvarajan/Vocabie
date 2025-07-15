//
//  UserPhraseListViewModel.swift
//  Vocabie
//
//  Created by Selvarajan on 13/03/22.
//

import Foundation
import CoreData

class UserPhraseListViewModel: ObservableObject {
    @Published var userPhraseAllEntries = [UserPhrase]()
    @Published var userPhraseRecentEntries = [UserPhrase]()
    
    func getAllUserPhraseEntries() {
        let userPhraseEntries : [UserPhrase] = UserPhrase.all()

        DispatchQueue.main.async {
            self.userPhraseAllEntries = userPhraseEntries //.map(UserPhraseViewModel.init)
        }
    }
    
    func pickRandomPhrase() -> UserPhrase {
        if (userPhraseAllEntries.count == 0){
            getAllUserPhraseEntries()
        }
        let randomNumber: Int = Int.random(in: 0..<userPhraseAllEntries.count)
        let phrase = userPhraseAllEntries[randomNumber]
        return phrase
    }
    
    func getRecentPhraseEntries() {
        let PhraseEntries : [UserPhrase] = UserPhrase.getRecentRecords(limit: 3)

        DispatchQueue.main.async {
            self.userPhraseRecentEntries = PhraseEntries //.map(UserPhraseViewModel.init)
        }
    }
    
    func savePhrase(phrase: String, tag: String, meaning: String, example: String){
        let userPhrase = UserPhrase(context: UserPhrase.viewContext)
        userPhrase.creationDate = Date()
        userPhrase.phrase = phrase
        userPhrase.tag = tag
        userPhrase.example = example
        userPhrase.meaning = meaning
        
        userPhrase.save()
    }
    
    func deletePhrase(phrase: UserPhrase) {
        let userPhrase: UserPhrase? = UserPhrase.byId(id: phrase.objectID)
        
        if let userPhrase = userPhrase {
            userPhrase.delete()
            getAllUserPhraseEntries()
            getRecentPhraseEntries()
        }
    }
}

