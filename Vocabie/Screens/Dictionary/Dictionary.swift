//
//  Dictionary.swift
//  Vocabie
//
//  Created by Selvarajan on 21/04/22.
//

import Foundation
import SwiftUI

enum SearchState {
    case initial
    case typing
    //    case submitted
    case submitted
}

enum SearchSubmitSource {
    case history
    case wordlist
    case keyboard
}
enum PartOfSpeech: String, CaseIterable {
    case noun
    case verb
    case adjective
    case adverb
    case exclamation
    case conjunction
    case pronoun
    case number
    case unknown
}

struct ClearButton: ViewModifier
{
    @Binding var text: String
    @FocusState var searchIsFocused: Bool
    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content
            
            if !text.isEmpty
            {
                Button(action:
                        {
                    self.text = ""
                    self.searchIsFocused = true
                })
                {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                        .font(.headline)
                }
                .padding(.trailing, 3)
            }
        }
    }
}

struct Dictionary: View {
    @StateObject var userWordListVM = UserWordListViewModel()
    @StateObject var searchHistoryVM = SearchHistoryViewModel()
    @State var dictionaryJson: [String] = []
    @State var filteredItems: [String] = []
    @State private var searchText = ""
    @State var word: WordElement?
    @State private var descriptionField = ""
    @State private var partOfSpeech: PartOfSpeech = .unknown
    @State private var showingAlert = false
    
//    @StateObject var vmDict = vmDictionary()
    @ObservedObject var vmDict: vmDictionary
    @FocusState private var searchIsFocused: Bool
    @State private var dictType = 1
    
    @State var displayDifinition: String = ""
    @State private var showGoogleWebView = false
    @State private var showNewWordView = false
    @State private var showWikipediaWebView = false
    
    @State private var searchState: SearchState = .initial
    @State private var searchSubmitSource: SearchSubmitSource = .keyboard
    @State var SearchEditChanged: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    func searchSubmit2FreeApi() {
        vmDict.definitionFound = nil
        vmDict.isFetching = true
        vmDict.wordInfo = nil
        vmDict.fetchData(inputWord: searchText, searchHistoryVM: searchHistoryVM)
    }
    
    func searchSubmit2WordsApi() {
        vmDict.definitionFound = nil
        vmDict.isFetching = true
        vmDict.wordsApiResponse = nil
        vmDict.fetchFromWordsApi(inputWord: searchText)
    }
    
    func searchSubmit2LocalAI() {
        vmDict.definitionFound = nil
        vmDict.isFetching = true
        vmDict.wordsApiResponse = nil
        vmDict.fetchFromWordsApi(inputWord: searchText)
    }
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            ScrollView {
                
                // Search textbox
                HStack {
                    TextField("Search words in dictionary...",
                              text: $searchText,
                              onEditingChanged: { editingChanged in
                        SearchEditChanged = editingChanged
                        print("editingChanged: \(editingChanged)")
                    })
                    .modifier(ClearButton(text: $searchText, searchIsFocused: _searchIsFocused))
                    .font(.headline)
                    .autocapitalization(UITextAutocapitalizationType.none)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                    .focused($searchIsFocused)
                    .submitLabel(SubmitLabel.search)
                    .disableAutocorrection(true)
                    .onChange(of: searchText) { searchTerm in
                        if SearchEditChanged  { // means the cursor is on the search field
                            searchState = searchText == "" ? .initial : .typing
                        }
                        vmDict.filterWordList(searchText: searchTerm)
                    }
                    .onSubmit {
                        dictType = 1
                        
                        vmDict.wordsApiResponse = nil
                        vmDict.googleDataDump = nil
                        vmDict.webstersResponse = nil
                        vmDict.tamilResponse = nil
                        vmDict.owlbotResponse = nil
                        
                        searchState = .submitted
                        
                        searchSubmit2FreeApi()
                    }
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .padding(.leading, 10)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // initial state - searchtext box and history display
                if (searchState == .initial) {
                    //Display previous search terms here
                    ForEach(searchHistoryVM.searchHistoryRecentEntries, id:\.objectID) { searchterm in
                        HStack {
                            HStack{
                                Text(searchterm.word ?? "")
                                    .font(.callout)
                                
                                Text(searchterm.definition ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }.onTapGesture {
                                searchText = searchterm.word ?? ""
                                searchIsFocused = false
                                searchState = .submitted
                                
                                dictType = 1
                                
                                vmDict.wordsApiResponse = nil
                                vmDict.googleDataDump = nil
                                vmDict.webstersResponse = nil
                                vmDict.tamilResponse = nil
                                vmDict.owlbotResponse = nil
                                searchSubmit2FreeApi()
                            }
                            
                            Spacer()
                            Image(systemName: "xmark")
                                .foregroundColor(Color(UIColor.opaqueSeparator))
                                .font(.footnote)
                                .onTapGesture {
                                    searchHistoryVM.deleteSearchEntry(searchEntry: searchterm)
                                }
                        }
                        .padding(.horizontal, 15)
                        .padding(.horizontal)
                        
                        Divider().padding(.horizontal)
                    }
                    if (searchHistoryVM.searchHistoryRecentEntries.count > 0) {
                        Button {
                            // clearing off the history
                            searchHistoryVM.deleteAll()
                        } label: {
                            Text("Clear History")
                                .foregroundColor(.red.opacity(0.8))
                                .font(.footnote)
                        }.padding()
                    }
                }
                
                if searchState == .typing { // search started
                    // Displaying autocompletion for search word
                    if vmDict.filteredWordList != nil {
                        ForEach(vmDict.filteredWordList!, id:\.self) { wordListItem in
                            HStack {
                                Text(wordListItem.word ?? "")
                                    .font(.callout)
                                
                                Spacer()
                            }
                            .onTapGesture {
                                searchText = wordListItem.word ?? ""
                                
                                searchIsFocused = false
                                searchState = .submitted
                                
                                dictType = 1
                                
                                vmDict.wordsApiResponse = nil
                                vmDict.googleDataDump = nil
                                vmDict.webstersResponse = nil
                                vmDict.tamilResponse = nil
                                vmDict.owlbotResponse = nil
                                
                                searchSubmit2FreeApi()
                            }
                            .padding(.horizontal, 15)
                            .padding(.horizontal)
                            
                            Divider().padding(.horizontal)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    if searchState == .submitted {
                        // Dictionary list
                        ScrollView(.horizontal , showsIndicators: false) {
                            HStack(alignment: .top) {
                                
                                //Free Dictionary Api
                                Button {
                                    dictType = 1
                                } label: {
                                    VStack{
                                        Text("Online Api")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 1 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 1 ? .indigo : .secondary)
                                
                                Button {
                                    if (vmDict.wordsApiResponse == nil) {
                                        // Do WordsApi fetch
                                        searchState = .submitted
                                        searchSubmit2WordsApi()
                                    }
                                    
                                    dictType = 9
                                } label: {
                                    VStack{
                                        Text("On-device AI")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 2 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 2 ? .indigo : .secondary)
                                
                                /*
                                // WordsApi
                                Button {
                                    if (vmDict.wordsApiResponse == nil) {
                                        // Do WordsApi fetch
                                        searchState = .submitted
                                        searchSubmit2WordsApi()
                                    }
                                    
                                    dictType = 2
                                } label: {
                                    VStack{
                                        Text("WordsApi")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 2 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 2 ? .indigo : .secondary)
                                
                                // Tamil
                                Button {
                                    if (vmDict.tamilResponse == nil) {
                                        DispatchQueue.main.async {
                                            // Do Websters Dictionary fetch
                                            searchState = .submitted
                                            vmDict.definitionFound = nil
                                            vmDict.isFetching = true
                                        }
                                        vmDict.fetchFromTamil(inputWord: searchText)
                                    }
                                    
                                    dictType = 5
                                    
                                } label: {
                                    VStack{
                                        Text("Tamil")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 5 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 5 ? .indigo : .secondary)
                                
                                // OwlBot
                                Button {
                                    if (vmDict.owlbotResponse == nil) {
                                        DispatchQueue.main.async {
                                            // Do Websters Dictionary fetch
                                            searchState = .submitted
                                            vmDict.definitionFound = nil
                                            vmDict.isFetching = true
                                        }
                                        vmDict.fetchFromOwlBot(inputWord: searchText)
                                    }
                                    
                                    dictType = 6
                                    
                                } label: {
                                    VStack{
                                        Text("OwlBot")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 6 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 6 ? .indigo : .secondary)
                                
                                // Websters Dictionary
                                Button {
                                    if (vmDict.webstersResponse == nil) {
                                        // Do Websters Dictionary fetch
                                        searchState = .submitted
                                        vmDict.definitionFound = nil
                                        vmDict.isFetching = true
                                        vmDict.fetchFromWebsters(inputWord: searchText)
                                    }
                                    
                                    dictType = 4
                                    
                                } label: {
                                    VStack{
                                        Text("Websters")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 4 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 4 ? .indigo : .secondary)
                                
    
                                
                                //Google
                                Button {
                                    showGoogleWebView.toggle()
                                    dictType = 3
                                    searchState = .submitted
                                } label: {
                                    VStack{
                                        Text("Google Search")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 3 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 3 ? .indigo : .secondary)
                                .sheet(isPresented: $showGoogleWebView) {
                                    UIWebView(url: URL(string: "https://www.google.co.in/search?q=define+\(searchText.lowercased().trim())")!)
                                }
                                
                                //https://en.wiktionary.org/wiki/astonishing
                                //Wikipedia
                                Button {
                                    showWikipediaWebView.toggle()
                                    dictType = 7
                                    searchState = .submitted
                                } label: {
                                    VStack{
                                        Text("Wikipedia")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 7 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 7 ? .indigo : .secondary)
                                .sheet(isPresented: $showWikipediaWebView) {
                                    UIWebView(url: URL(string: "https://en.wiktionary.org/wiki/\(searchText.lowercased().trim())")!)
                                }
                                */
                                
                            }
                            .foregroundColor(.primary)
                            .font(.subheadline)
                        }
                        
                        Divider()
                        
                        if (vmDict.isFetching) {
                            HStack {
                                Spacer()
                                Text("Loading definition...")
                                    .padding()
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                        
                        if !vmDict.isFetching {
                            
                            // Free Dictionary Api
                            if dictType == 1 {
                                
                                if vmDict.wordInfo != nil {
                                    Text(vmDict.wordInfo?.word ?? "")
                                        .font(.largeTitle)
                                    
                                    HStack(spacing: 15) {
                                        Text("Phonetics:").font(.headline).foregroundColor(.blue)
                                        Text("\(vmDict.wordInfo?.phonetic ?? "") ")
                                        Image(systemName: "play.circle")
                                    }.padding(.top, 0)
                                    
                                    Divider()
                                    Text("Definition:").font(.headline).foregroundColor(.blue)
                                    Text("\(extractMeaning(meanings: vmDict.wordInfo!.meanings))").padding(.top, 0)
                                    Divider()
                                    
                                    if (extractExmple(meanings: vmDict.wordInfo!.meanings) != "") {
                                        Text("Example Usage:").font(.headline).foregroundColor(.blue)
                                        Text("\(extractExmple(meanings: vmDict.wordInfo!.meanings))").padding(.top, 0)
                                    }
                                    
                                    Button(action: {
                                        userWordListVM.saveWord(word: vmDict.wordInfo?.word ?? "",
                                                                tag: "from Dictionary",
                                                                meaning: extractMeaning(meanings: vmDict.wordInfo!.meanings),
                                                                sampleSentence: extractExmple(meanings: vmDict.wordInfo!.meanings))
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("+ Add this word to my vocabulary")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame (height: 55)
                                            .frame (maxWidth: .infinity)
                                            .background (Color.indigo)
                                            .cornerRadius(10)
                                    })
                                }
                                else { //if no response found
                                    if searchText != "" {
                                        Text("No definition found in 'DictionaryApi' for  '**\(searchText)**'")
                                            .fontWeight(.thin)
                                            .multilineTextAlignment(.center)
                                            .padding()
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            
                            // WordsApi
                            if dictType == 2 {
                                if vmDict.wordsApiResponse != nil {
                                    Text(vmDict.wordsApiResponse?.word ?? "")
                                        .font(.largeTitle)

                                    HStack(spacing: 15) {
                                        Text("Phonetics:").font(.headline).foregroundColor(.blue)
                                        Text("\(vmDict.wordsApiResponse?.pronunciation.all ?? "") ")
                                    }.padding(.top, 0)

                                    Divider()
                                    Text("Definition:").font(.headline).foregroundColor(.blue)
                                    Text("\(extractDefinitionFrom(wordsApiResults: vmDict.wordsApiResponse!.results))").padding(.top, 0)
                                    Divider()

                                    if (extractExmple(meanings: vmDict.wordInfo!.meanings) != "") {
                                        Text("Example Usage:").font(.headline).foregroundColor(.blue)
                                        Text("\(extractExampleFrom(wordsApiResults: vmDict.wordsApiResponse!.results))").padding(.top, 0)
                                    }

                                    Button(action: {
                                        userWordListVM.saveWord(word: vmDict.wordsApiResponse!.word,
                                                                tag: "WordsApi",
                                                                meaning: extractDefinitionFrom(wordsApiResults: vmDict.wordsApiResponse!.results),
                                                                sampleSentence: extractExampleFrom(wordsApiResults: vmDict.wordsApiResponse!.results))
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("+ Add this word to my vocabulary")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame (height: 55)
                                            .frame (maxWidth: .infinity)
                                            .background (Color.indigo)
                                            .cornerRadius(10)
                                    })
                                }
                                else { //if no response found
                                    Text("No definition is found for '**\(searchText)**'")
                                        .fontWeight(.thin)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .foregroundColor(.red)
                                }
                            }
                            
                            // Tamil Dictionary - from local json file
                            if dictType == 5 {
                                if vmDict.tamilResponse != nil {
                                    
                                    Text(vmDict.searchWord)
                                        .font(.largeTitle)
                                    
                                    Divider()
                                    Text("Definition:").font(.headline).foregroundColor(.blue)
                                    Text("\(vmDict.tamilResponse ?? "")").padding(.top, 0)
                                    Divider()
                                    
                                    Button(action: {
                                        userWordListVM.saveWord(word: vmDict.searchWord,
                                                                tag: "Websters",
                                                                meaning: vmDict.tamilResponse!,
                                                                sampleSentence: "")
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("+ Add this word to my vocabulary")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame (height: 55)
                                            .frame (maxWidth: .infinity)
                                            .background (Color.indigo)
                                            .cornerRadius(10)
                                    })
                                }
                                else { //if no response found
                                    Text("No definition found in 'Tamil Dictionary' for '**\(searchText)**'")
                                        .fontWeight(.thin)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .foregroundColor(.red)
                                }
                            }
                            
                            // OwlBot
                            if dictType == 6 {
                                if vmDict.owlbotResponse != nil {
                                    Text(vmDict.owlbotResponse?.word ?? "")
                                        .font(.largeTitle)
                                    
                                    HStack(spacing: 15) {
                                        Text("Phonetics:").font(.headline).foregroundColor(.blue)
                                        Text("\(vmDict.owlbotResponse?.pronunciation ?? "") ")
                                    }.padding(.top, 0)
                                    
                                    Divider()
                                    Text("Definition:").font(.headline).foregroundColor(.blue)
                                    Text("\(extractDefinitionFromOwlBot(owlbotResponse: vmDict.owlbotResponse!))").padding(.top, 0)
                                    Divider()
                                    
                                    if (extractExampleFromOwlBot(owlbotResponse: vmDict.owlbotResponse!) != "") {
                                        Text("Example Usage:").font(.headline).foregroundColor(.blue)
                                        Text("\(extractExampleFromOwlBot(owlbotResponse: vmDict.owlbotResponse!))").padding(.top, 0)
                                    }
                                    
                                    Button(action: {
                                        userWordListVM.saveWord(word: vmDict.owlbotResponse!.word ?? "",
                                                                tag: "OwlBot",
                                                                meaning: extractDefinitionFromOwlBot(owlbotResponse: vmDict.owlbotResponse!),
                                                                sampleSentence: extractDefinitionFromOwlBot(owlbotResponse: vmDict.owlbotResponse!))
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("+ Add this word to my vocabulary")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame (height: 55)
                                            .frame (maxWidth: .infinity)
                                            .background (Color.indigo)
                                            .cornerRadius(10)
                                    })
                                }
                                else { //if no response found
                                    Text("No definition found in 'OwlBot Dictionary' for '**\(searchText)**'")
                                        .fontWeight(.thin)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .foregroundColor(.red)
                                }
                            }
                            
                            // Websters Dictionary - from local json file
                            if dictType == 4 {
                                if vmDict.webstersResponse != nil {
                                    
                                    Text(vmDict.searchWord)
                                        .font(.largeTitle)
                                    
                                    Divider()
                                    Text("Definition:").font(.headline).foregroundColor(.blue)
                                    Text("\(vmDict.webstersResponse ?? "")").padding(.top, 0)
                                    Divider()
                                    
                                    Button(action: {
                                        userWordListVM.saveWord(word: vmDict.searchWord,
                                                                tag: "Webster",
                                                                meaning: vmDict.webstersResponse!,
                                                                sampleSentence: "")
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Text("+ Add this word to my vocabulary")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame (height: 55)
                                            .frame (maxWidth: .infinity)
                                            .background (Color.indigo)
                                            .cornerRadius(10)
                                    })
                                }
                                else { //if no response found
                                    Text("No definition found in 'Webster Dictionary' for '**\(searchText)**'")
                                        .fontWeight(.thin)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .foregroundColor(.red)
                                }
                            }
                            
                            
                            
                            // Google
                            if dictType == 3 && searchText != "" {
                                VStack {
                                    Text("You may copy the content from the webpage and add that as a word below.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding()
                                    
                                    
                                    Button(action: {
                                        showNewWordView.toggle()
                                    }, label: {
                                        Text("Add Word Screen")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame (height: 55)
                                            .frame (maxWidth: .infinity)
                                            .background (Color.indigo)
                                            .cornerRadius(10)
                                    })
                                    .sheet(isPresented: $showNewWordView) {
                                        AddUserWordView(newWord: searchText)
                                    }
                                }
                            }
                            
                            // Wikipedia
                            if dictType == 7 && searchText != "" {
                                VStack {
                                    Text("You may copy the content from the webpage and add a word.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding()
                                    
                                    Button(action: {
                                        showNewWordView.toggle()
                                    }, label: {
                                        Text("+ Goto to Add Word Screen")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame (height: 55)
                                            .frame (maxWidth: .infinity)
                                            .background (Color.indigo)
                                            .cornerRadius(10)
                                    })
                                    .sheet(isPresented: $showNewWordView) {
                                        AddUserWordView(newWord: searchText)
                                    }
                                }
                            }
                        }
                    }
                }.padding()
                
            }
            .onAppear {
                searchHistoryVM.getRecentSearchEntries()
                
                //Get the list of words
//                vmDict.getWordList()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    /// Anything over 0.5 seems to work
                    self.searchIsFocused = true
                }
            }
        }
    }
}

//struct Dictionary_Previews: PreviewProvider {
//    static var previews: some View {
//        Dictionary()
//    }
//}
