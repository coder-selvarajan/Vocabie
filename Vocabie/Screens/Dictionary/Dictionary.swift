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
    @State private var aiDictionaryService = AIDictionaryService()
    
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
                    .cornerRadius(20)
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
                                        Text("Online Dictionary")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 1 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 1 ? .indigo : .secondary)
                                
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
                                        Text("Tamil Dictionary")
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 5 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 5 ? .indigo : .secondary)
                                
                                
                                Button {
                                    searchState = .submitted
                                    if aiDictionaryService.wordDefinition == nil
                                        && aiDictionaryService.wordDefinition?.word != searchText {
                                        Task {
                                            try await aiDictionaryService.fetchDefinition(for: searchText)
                                        }
                                    }
                                    
                                    vmDict.isFetching = false
                                    vmDict.definitionFound = true
                                    dictType = 9
                                } label: {
                                    VStack{
                                        HStack {
                                            Text("Ask AI")
                                            Image(systemName: "sparkles")
                                                            .font(.caption)
                                        }
                                        Rectangle().frame(height: 1)
                                            .foregroundColor(dictType == 9 ? .indigo : .clear)
                                    }
                                }
                                .padding(.trailing)
                                .foregroundColor(dictType == 9 ? .indigo : .secondary)
                                
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
                                            .cornerRadius(20)
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
                                            .cornerRadius(20)
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
                            
                            
                            // AI Dictionary
                            if dictType == 9 {
                                WordLookupView(dictionaryService: aiDictionaryService)
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
