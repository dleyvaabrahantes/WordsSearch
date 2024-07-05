//
//  HomeMenu.swift
//  WordsSearch
//
//  Created by David on 7/5/24.
//

import SwiftUI

struct HomeMenu: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    Text("Word Search Game")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top,100)
                                            Spacer()
                    NavigationLink {
                        ContentView()
                    } label: {
                        Text("Start Game")
                            .yellowTextStyle()
                    }

                    
                    Button {
                        
                    } label: {
                        Text("Daily Puzzle")
                    }
                    .buttonStyle(YellowButtonStyle())
                    
                    Button {
                        
                    } label: {
                        Text("Settings")
                    }
                    .buttonStyle(YellowButtonStyle())
                    .padding(.bottom,100)
                }
            }
        }
    }
}

#Preview {
    HomeMenu()
}
