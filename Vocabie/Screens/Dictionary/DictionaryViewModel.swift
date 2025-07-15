//
//  DictionaryViewModel.swift
//  Vocabie
//
//  Created by Selvarajan on 27/05/22.
//

import Foundation

class vmDictionary : ObservableObject {
    @Published var wordInfo: WordElement?
    @Published var isFetching: Bool = false
    @Published var definitionFound: Bool?
    @Published var searchWord: String = ""
    @Published var wordsApiResponse: WordsApiResponse?
    @Published var webstersResponse: String?
    @Published var tamilResponse: String?
    @Published var owlbotResponse: OwlbotResponse?
    @Published var googleDataDump: String?
    @Published var wordList: [WordListItem]?
    @Published var filteredWordList: [WordListItem]?
    
    func getWordListTamil() {
        if let path = Bundle.main.path(forResource: "TA_Wordlist", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let listOfWords = try JSONDecoder().decode([WordListItem].self, from: data)
                if listOfWords.count > 0 {
                    wordList = listOfWords
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getWordList() {
        if let path = Bundle.main.path(forResource: "word-list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let listOfWords = try JSONDecoder().decode([WordListItem].self, from: data)
                if listOfWords.count > 0 {
                    wordList = listOfWords
                }
            } catch {
                print(error)
            }
        }
    }
    
    //Search auto-completion
    func filterWordList(searchText: String) {
        // Running the search in background thread
        DispatchQueue.global().async {
            if self.wordList == nil {
                self.getWordList()
            }
            if self.wordList != nil {
                let filteredWords = Array(self.wordList!.filter {
                    $0.word!.starts(with: searchText)
                }.prefix(15))
                
                DispatchQueue.main.async {
                    self.filteredWordList = filteredWords
                }
            }
        }
    }
    
    //Free DictionaryApi
    func fetchData(inputWord: String, searchHistoryVM: SearchHistoryViewModel) {
        if inputWord != "" {
            let stringURL = "https://api.dictionaryapi.dev/api/v2/entries/en/\(inputWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))"
            guard let url = URL(string: stringURL) else {
                print("Invalid URL")
                self.isFetching = false
                return
            }
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(Words.self, from: data)
                    DispatchQueue.main.async {
                        self?.wordInfo = decodedData.first!
                        self?.isFetching = false
                        self?.definitionFound = true
                        
                        //saving the search entry in core data
                        searchHistoryVM.saveSearchEntry(word: inputWord, definition: extractMeaning(meanings: decodedData.first!.meanings))
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.isFetching = false
                        self?.definitionFound = false
                    }
                    print(error)
                }
            }.resume()
            
        }
    }
    
    //WordsApi
    func fetchFromWordsApi(inputWord: String) {
        let headers = [
            "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com",
            "X-RapidAPI-Key": "d2b600d481mshbdab0e8414fa85ep1847a5jsn554b275028b4"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(inputWord.lowercased().trim())")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request as URLRequest) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let _ = response as? HTTPURLResponse {
                do {
                    let decodedData = try JSONDecoder().decode(WordsApiResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.wordsApiResponse = decodedData
                        self?.isFetching = false
                        self?.definitionFound = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.isFetching = false
                        self?.definitionFound = false
                    }
                    print(error)
                }
            }
        }.resume()
    }
    
    //Websters Dictionary
    func fetchFromWebsters(inputWord: String) {
        searchWord = inputWord
        
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "websters_dictionary", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    
                    if let jsonResult = jsonResult as? [String: Any], let def = jsonResult[inputWord.trim().lowercased()] as? String {
                        
                        var transformedDef = def
                        transformedDef = transformedDef.replacingOccurrences(of: " 2.", with: " \n\n2.")
                        transformedDef = transformedDef.replacingOccurrences(of: " 3.", with: " \n\n3.")
                        transformedDef = transformedDef.replacingOccurrences(of: " 4.", with: " \n\n4.")
                        transformedDef = transformedDef.replacingOccurrences(of: " 5.", with: " \n\n5.")
                        transformedDef = transformedDef.replacingOccurrences(of: " 6.", with: " \n\n6.")
                        transformedDef = transformedDef.replacingOccurrences(of: " 7.", with: " \n\n7.")
                        transformedDef = transformedDef.replacingOccurrences(of: " 8.", with: " \n\n8.")
                        transformedDef = transformedDef.replacingOccurrences(of: " 9.", with: " \n\n9.")
                        transformedDef = transformedDef.replacingOccurrences(of: " 10.", with: " \n\n10.")
                        
                        transformedDef = transformedDef.replacingOccurrences(of: " -- ", with: " \n - ")
                        
                        print(transformedDef)
                        DispatchQueue.main.async {
                            self.webstersResponse = transformedDef
                            self.isFetching = false
                            self.definitionFound = true
                        }
                        return
                    }
                  } catch {
                       // handle error
                      DispatchQueue.main.async {
                          self.isFetching = false
                          self.definitionFound = false
                      }
                      print(error)
                      return
                  }
            }
            
            DispatchQueue.main.async {
                self.isFetching = false
                self.definitionFound = false
            }
        }
    }
    
    //Fetching Tamil Dictionary
    func fetchFromTamil(inputWord: String) {
        searchWord = inputWord
        
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "TA_dictionary", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    
                    let tamilDict = try JSONDecoder().decode([TamilMeaning].self, from: data)
                    let item = tamilDict.filter {  $0.eng == inputWord }
                    if item.count > 0 {
                        print(item.first!.tamil)
                        DispatchQueue.main.async {
                            self.tamilResponse = item.first!.tamil
                            self.isFetching = false
                            self.definitionFound = true
                        }
                        return
                    }
                    else {
                        // word not found.. handle it accordingly
                    }
                } catch {
                    // handle error
                    DispatchQueue.main.async {
                        self.isFetching = false
                        self.definitionFound = false
                    }
                    print(error)
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.isFetching = false
                self.definitionFound = false
            }
        }
    }
    
    //OwlBot Dictionary
    func fetchFromOwlBot(inputWord: String) {
        let stringURL = "https://owlbot.info/api/v4/dictionary/\(inputWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))"
        guard let url = URL(string: stringURL) else {
            print("Invalid URL")
            self.isFetching = false
            return
        }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("Token fb9e439649e48d68ceb626bf4bd7a535ca9ae347", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request as URLRequest) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let _ = response as? HTTPURLResponse {
                do {
                    let decodedData = try JSONDecoder().decode(OwlbotResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.owlbotResponse = decodedData
                        self?.isFetching = false
                        self?.definitionFound = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.isFetching = false
                        self?.definitionFound = false
                    }
                    print(error)
                }
            }
        }.resume()
    }
}
