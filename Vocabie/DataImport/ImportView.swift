//
//  ImportView.swift
//  Vocabie
//
//  Created by Selvarajan on 11/07/22.
//

import SwiftUI

struct ImportView: View {
    @State var showAlert = false
    @State var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack {
                GroupBox("Idioms: ") {
                    Text("common-idioms.csv")
                        .foregroundColor(.secondary)
                        .padding(.top)
                    
                    Button {
                        if importIdiomCSV(name: "common-idioms") {
                            alertMessage = "Idioms imported successfully"
                            showAlert = true
                        }
                        else {
                            alertMessage = "Error while importing Idioms"
                            showAlert = true
                        }
                    } label: {
                        Text("Import Common Idioms")
                            .foregroundColor(.white)
                            .frame (height: 50)
                            .frame (maxWidth: .infinity)
                            .background(.indigo)
                            .cornerRadius(10)
                    }.padding(.horizontal)
                    
                    Button {
                        if deleteAllIdioms() {
                            alertMessage = "Idioms cleared successfully"
                            showAlert = true
                        }
                        else {
                            alertMessage = "Error while clearing Idioms"
                            showAlert = true
                        }
                    } label: {
                        Text("Clear Common Idioms")
                            .foregroundColor(.white)
                            .frame (height: 50)
                            .frame (maxWidth: .infinity)
                            .background(.indigo)
                            .cornerRadius(10)
                    }.padding(.horizontal)
                }
                .padding()
                
                GroupBox("Adjectives: ") {
                    
                    Text("common-adjectives.csv")
                        .foregroundColor(.secondary)
                        .padding(.top)
                    
                    Button {
                        //
                    } label: {
                        Text("Import Common Adjectives")
                            .foregroundColor(.white)
                            .frame (height: 50)
                            .frame (maxWidth: .infinity)
                            .background(.blue)
                            .cornerRadius(10)
                    }.padding(.horizontal)
                    
                    Button {
                        //
                    } label: {
                        Text("Clear Common Adjectives")
                            .foregroundColor(.white)
                            .frame (height: 50)
                            .frame (maxWidth: .infinity)
                            .background(.blue)
                            .cornerRadius(10)
                    }.padding(.horizontal)
                    
                }
                .padding()
            }
            .alert(isPresented: $showAlert) { () -> Alert in            Alert(title: Text(alertMessage))
            }
        }
    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView()
    }
}
