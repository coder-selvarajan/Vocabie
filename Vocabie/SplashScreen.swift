//
//  SplashScreen.swift
//  Vocabie
//
//  Created by Selvarajan on 02/05/22.
//

import SwiftUI

struct SplashScreen: View {
    @State var isFinished: Bool = false
    
    var body: some View {
        if !isFinished {
            ZStack {
                Color(hex: "5e17eb").ignoresSafeArea()
//                Color.indigo.ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(
                            Rectangle().foregroundColor(.white)
                        )
                    
                    Text("Vocabie")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 5){
                        Text("Vocabulary Builder")
                        Text("Dictionary")
                        Text("Word Games")
                    }
                    .padding(10)
                    .font(.caption)
                }
            }
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9){
                    withAnimation(.linear(duration: 0.2)){
                        isFinished.toggle()
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
