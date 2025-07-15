//
//  UserWordListViewModel.swift
//  Vocabie
//
//  Created by Selvarajan on 13/03/22.
//

import Foundation
import CoreData

class UserWordListViewModel: ObservableObject {
    @Published var userWordAllEntries = [UserWord]()
    @Published var userWordRecentEntries = [UserWord]()
    
    func getAllUserWordEntries() {
        let userWordEntries : [UserWord] = UserWord.all()

        DispatchQueue.main.async {
            self.userWordAllEntries = userWordEntries //.map(UserWordViewModel.init)
        }
    }
    
    func getRecentWordEntries() {
        let wordEntries : [UserWord] = UserWord.getRecentRecords(limit: 4)

        DispatchQueue.main.async {
            self.userWordRecentEntries = wordEntries //.map(UserWordViewModel.init)
        }
    }
    
    func pickRandomWord() -> UserWord {
        if (userWordAllEntries.count == 0){
            getAllUserWordEntries()
        }
        let randomNumber: Int = Int.random(in: 0..<userWordAllEntries.count)
        let word = userWordAllEntries[randomNumber]
        return word
    }
    
    func pickRandomWords(_ count: Int) -> [UserWord] {
        var randomNumber: Int = 0
        var indexes = [Int]()
        var userWords = [UserWord]()
        var i : Int = 0
        
//        for _ in 1...count {
        while (true) {
            if (indexes.count > 0)
            {
                randomNumber = (1..<userWordAllEntries.count).random(without: indexes)
            }
            else {
                randomNumber = Int.random(in: 1..<userWordAllEntries.count)
            }
            if (userWordAllEntries[randomNumber].meaning != "") {
                indexes.append(randomNumber)
                userWords.append(userWordAllEntries[randomNumber])
                i += 1
            }
            if (i >= count) {
                break
            }
        }
        return userWords
    }
    
    func updateWord(word: UserWord) {
        word.save()
    }
    
    func saveWord(word: String, tag: String, meaning: String, sampleSentence: String){
        let userWord = UserWord(context: UserWord.viewContext)
        userWord.creationDate = Date()
        userWord.word = word
        userWord.tag = tag
        userWord.sampleSentence = sampleSentence
        userWord.meaning = meaning
        
        userWord.save()
    }
    
    func deleteWord(word: UserWord) {
        let userWord: UserWord? = UserWord.byId(id: word.objectID)
        
        if let userWord = userWord {
            userWord.delete()
            getAllUserWordEntries()
            getRecentWordEntries()
        }
    }
}

//struct UserWordViewModel: Identifiable {
//    let userWord: UserWord
//
//    var id: NSManagedObjectID {
//        return userWord.objectID
//    }
//
//    var creationDate: Date {
//        return userWord.creationDate ?? Date()
//    }
//
//    var word: String {
//        return userWord.word ?? ""
//    }
//
//    var tag: String {
//        return userWord.tag ?? ""
//    }
//
//    var sampleSentence: String {
//        return userWord.sampleSentence ?? ""
//    }
//
//    var meaning: String {
//        return userWord.meaning ?? ""
//    }
//
//    var type: String {
//        return userWord.type ?? ""
//    }
//}
