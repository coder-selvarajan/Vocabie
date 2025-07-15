//
//  ContentView.swift
//  Vocabie
//
//  Created by Selvarajan on 13/03/22.
//

import Foundation
import SwiftUI
import UIKit

struct HomeView: View {
    @StateObject var userWordListVM = UserWordListViewModel()
    @StateObject var userSentenceListVM = UserSentenceListViewModel()
    @StateObject var userPhraseListVM = UserPhraseListViewModel()
    @StateObject var vmDict = vmDictionary()
    
    @State var selection: Int? = nil
    @State var showList: Int? = nil
    @State private var searchText = ""
    @State var appTheme: String = "dark"
    
    var WordListFooter: some View {
        NavigationLink(destination: UserWordList(), tag: 1, selection: $showList) {
            if (userWordListVM.userWordRecentEntries.count > 0) {
                Button(action: {
                    // Show word list
                    self.showList = 1
                }, label: {
                    Text("View All ")
                        .foregroundColor(.blue)
                        .padding(.bottom, 7)
                })
            }
            else {
                EmptyView()
            }
        }
    }
    
    var SentenceListFooter: some View {
        NavigationLink(destination: UserSentenceList(), tag: 2, selection: $showList) {
            if (userSentenceListVM.userSentenceRecentEntries.count > 0) {
                Button(action: {
                    // Show sentence list
                    self.showList = 2
                }, label: {
                    Text("View All ")
                        .foregroundColor(.blue)
                        .padding(.bottom, 7)
                })
            }
            else {
                EmptyView()
            }
        }
    }
    
    var PhraseListFooter: some View {
        NavigationLink(destination: UserPhraseList(), tag: 3, selection: $showList) {
            if (userPhraseListVM.userPhraseRecentEntries.count > 0) {
                Button(action: {
                    // Show phrase list
                    self.showList = 3
                }, label: {
                    Text("View All ")
                        .foregroundColor(.blue)
                        .padding(.bottom, 7)
                })
            }
            else {
                EmptyView()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack {
                    List {
                        //Search bar
                        Section(footer: EmptyView().padding(0)) {
                            ZStack {
                                NavigationLink(destination:
                                                Dictionary(vmDict: vmDict)
                                ) {
                                    EmptyView()
                                }
                                .buttonStyle(PlainButtonStyle())
                                .opacity(0.0)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.gray.opacity(0.2))
                                
                                HStack {
                                    Text("Search words in dictionary...")
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Image(systemName: "magnifyingglass")
                                        .padding(.horizontal)
                                        .foregroundColor(.gray)
                                }
                                
                            }.padding(0)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        
                        //Resources
                        Section() { //header: Text("Resources").padding(.horizontal, 15)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 25) {
                                    Button {
                                        //
                                    } label: {
                                        VStack(alignment: .center, spacing: 15) {
                                            Text("Verb")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .shadow(color: Color.black.opacity(0.4),
                                                        radius: 2,
                                                        x: 3,
                                                        y: 3)
                                                .padding(23)
                                                .background(
                                                    LinearGradient(gradient: Gradient(colors: [.indigo, .indigo.opacity(0.8), .indigo.opacity(0.4)]), startPoint: .topLeading , endPoint: .bottomTrailing)
                                                )
                                                .clipShape(Circle())
                                            
                                            Text("Intermediate \nVerbs")
                                                .font(.subheadline)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    
                                    Button {
                                        //
                                    } label: {
                                        VStack(alignment: .center, spacing: 15) {
                                            Text("Adj")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .shadow(color: Color.black.opacity(0.4),
                                                        radius: 2,
                                                        x: 3,
                                                        y: 3)
                                                .padding(23)
                                                .background(
                                                    LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.8), .blue.opacity(0.4)]), startPoint: .topLeading , endPoint: .bottomTrailing)
                                                )
                                                .clipShape(Circle())
                                            
                                            Text("Common \nAdjectives")
                                                .font(.subheadline)
                                                .foregroundColor(.primary)
                                            
                                        }
                                    }
                                    
                                    Button {
                                        //
                                    } label: {
                                        VStack(alignment: .center, spacing: 15) {
                                            Text("Ph")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .shadow(color: Color.black.opacity(0.4),
                                                        radius: 2,
                                                        x: 3,
                                                        y: 3)
                                                .padding(23)
                                                .background(
                                                    LinearGradient(gradient: Gradient(colors: [.cyan, .cyan.opacity(0.8), .cyan.opacity(0.4)]), startPoint: .topLeading , endPoint: .bottomTrailing)
                                                )
                                                .clipShape(Circle())
                                            
                                            Text("Useful \nPhrases")
                                                .font(.subheadline)
                                                .foregroundColor(.primary)
                                            
                                        }
                                    }
                                    
                                    
                                    NavigationLink(destination: CommonIdiomsView(), tag: 101, selection: $selection) {
                                        Button(action: {
                                            self.selection = 101
                                        }) {
                                            VStack(alignment: .center, spacing: 15) {
                                                Text("Id")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                    .shadow(color: Color.black.opacity(0.4),
                                                            radius: 2,
                                                            x: 3,
                                                            y: 3)
                                                    .padding(23)
                                                    .background(
                                                        LinearGradient(gradient: Gradient(colors: [.indigo, .indigo.opacity(0.8), .indigo.opacity(0.4)]), startPoint: .topLeading , endPoint: .bottomTrailing)
                                                    )
                                                    .clipShape(Circle())
                                                
                                                Text("Common \nIdioms")
                                                    .font(.subheadline)
                                                    .foregroundColor(.primary)
                                                
                                            }
                                        }
                                    }
                                }.padding(.bottom, 10)
                            }
                        }
                        .padding(.top, 0)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        
                        // Game section
                        Section(header: Text("Gamify your learning").padding(.horizontal, 15)) {
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    NavigationLink(destination: RandomPickerView(), tag: 13, selection: $selection) {
                                        Button(action: {
                                            self.selection = 13
                                        }) {
                                            VStack(alignment: SwiftUI.HorizontalAlignment.leading){
                                                Text("Randomizer")
                                                    .font(.callout).bold()
                                                    .foregroundColor(.white)
                                                Text("words, phrases")
                                                    .font(.footnote).foregroundColor(.white.opacity(0.6))
                                            }.foregroundColor(.white)
                                        }
                                        .frame(width: 175, height: 75, alignment: .center)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [.indigo, .indigo.opacity(0.9), .indigo.opacity(0.55)]), startPoint: .top, endPoint: .bottom)
                                        ).cornerRadius(10)
                                    }
                                    
                                    NavigationLink(destination: PickDefinitionHome(), tag: 12, selection: $selection) {
                                        Button(action: {
                                            self.selection = 12
                                        }) {
                                            VStack(alignment: SwiftUI.HorizontalAlignment.leading){
                                                Text("Pick Definition")
                                                    .font(.callout).bold()
                                                    .foregroundColor(.white)
                                                Text("by word").font(.footnote).foregroundColor(.white.opacity(0.6))
                                            }
                                        }
                                        .frame(width: 175, height: 75, alignment: .center)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [.blue, .blue.opacity(0.9), .blue.opacity(0.55)]), startPoint: .top, endPoint: .bottom)
                                        ).cornerRadius(10)
                                    }
                                    Spacer()
                                }
//                                .padding(.leading, 10)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                        .listRowBackground(Color.clear)
                        
                        //Your Recent Words
                        Section(header: Text("Your Recent Words"), footer: WordListFooter) {
                            if (userWordListVM.userWordRecentEntries.count == 0) {
                                VStack(alignment: .leading){
                                    Button {
                                        self.selection = 1
                                    } label: {
                                        Text("No words yet. \nClick here to add your first word")
                                            .font(.footnote)
                                            .foregroundColor(.indigo)
                                            .padding(.bottom, 10)
                                    }
                                }
                            }
                            else {
                                ForEach(userWordListVM.userWordRecentEntries, id:\.objectID) {userword in
                                    HStack {
                                        Text("\(userword.word!)")
                                            .font(.headline)
                                            .bold()
                                        Text(" \(userword.meaning ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    .padding(.vertical, 10)
                                    .background(NavigationLink("", destination: ViewUserWord(word: userword)).opacity(0))
                                }
                            }
                        }
                        
                        //Recent Phrases / Idioms
                        Section(header: Text("Recent Phrases / Idioms"),  footer: PhraseListFooter) {
                            if (userPhraseListVM.userPhraseRecentEntries.count == 0) {
                                VStack(alignment: .leading){
                                    Button {
                                        self.selection = 3
                                    } label: {
                                        Text("No phrases/idioms yet. \nClick here to add your first phrase/idiom")
                                            .font(.footnote)
                                            .foregroundColor(.blue)
                                            .padding(.vertical, 10)
                                    }
                                }
                            }
                            else {
                                ForEach(userPhraseListVM.userPhraseRecentEntries, id:\.objectID) {phrase in
                                    HStack {
                                        Text("\(phrase.phrase ?? "")").font(.subheadline)
                                    }.background(NavigationLink("", destination: ViewPhrase(userPhrase: phrase))
                                        .opacity(0))
                                }
                            }
                        }
                        
                    }
                    .padding(0)
                    .padding(.top, -15)
                    .listStyle(.insetGrouped)
//                    .scrollContentBackground(.hidden) // Hide default background
//                    .background(Color.indigo.opacity(0.25))
                    .onAppear {
                        userWordListVM.getRecentWordEntries()
//                        userSentenceListVM.getRecentSentenceEntries()
                        userPhraseListVM.getRecentPhraseEntries()
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: AddUserWordView(newWord: ""), tag: 1, selection: $selection) { EmptyView() }
                            NavigationLink(destination: AddUserPhraseView(), tag: 3, selection: $selection) { EmptyView() }
                            
                            Menu {
                                Button(action: {
                                    self.selection = 1
                                }) {
                                    Text("Word")
                                }.padding()
                                
//                                Button(action: {
//                                    // Add new word
//                                    self.selection = 2
//                                }) {
//                                    Text("Sentence")
//                                }.padding()
                                
                                Button(action: {
                                    // Add new word
                                    self.selection = 3
                                }) {
                                    Button(action: {}) {
                                        Text("Phrase/Idiom")
                                    }
                                }.padding()
                            } label: {
                                ZStack {
                                    LinearGradient(gradient: Gradient(colors: [.indigo, .blue]), startPoint: .top, endPoint: .bottom)
                                        .frame(width: 65, height: 65)
                                        .cornerRadius(10)
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                                .padding(.trailing, 20)
                                .shadow(color: Color.black.opacity(0.4),
                                        radius: 3,
                                        x: 3,
                                        y: 3)
                            }
                        }
                    }
                }
                .padding(0)
            }
            .padding(0)
            .navigationTitle("Vocabie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    NavigationLink(destination: ImportView()) {
                        Image(systemName: "line.3.horizontal.circle")
                    }
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button(action: {
                        if appTheme == "dark" {
                            UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
                        }
                        else {
                            UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
                        }
                        appTheme = appTheme == "dark" ? "light" : "dark"
                    }, label: {
                        Image(systemName: "gearshape.fill")
                    })
                    
                }
            }
        }
        .accentColor(.indigo)
        .ignoresSafeArea()
        .onAppear(){
            //Get wordlist
            vmDict.getWordList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
