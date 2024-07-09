//
//  HomeMenu.swift
//  WordsSearch
//
//  Created by David on 7/5/24.
//

import SwiftUI
import UIKit
import StoreKit

struct HomeMenu: View {
    @State private var pulsate = false
    @StateObject var viewModel: WordSearchViewModel = .init()
    
    @Environment(\.requestReview) var requestReview
    
    private var selectedScheme: ColorScheme? {
        guard let theme = AppareanceMode(rawValue: systemTheme) else {return nil}
        switch theme {
            
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            return nil
        }
    }
    
    @AppStorage("systemTheme") private var systemTheme: Int = AppareanceMode.allCases.first!.rawValue
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                                    .edgesIgnoringSafeArea(.all)
                VStack{
                   // Spacer()
                    VStack(alignment: .center) {
                     
                        Image("word")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                          // .padding(.top, 10)
                        
                        Image("letter")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .offset(y: -20)
                        
                }
                                           Spacer()
                    VStack(spacing: 20){
                        NavigationLink {
                            
                                ContentView(categoryModel: CategoryModel(name: "Daily", level: .easy, nameJson: "daily"))
                                .environmentObject(viewModel)
                                    .navigationTitle("Word Search")
                                    .navigationBarTitleDisplayMode(.inline)
                            
                        } label: {
                            Text("Daily Challenge")
                                .yellowTextStyle()
                                
                        }
                        
                        NavigationLink {
                           ListCategoryView()
                                .environmentObject(viewModel)
                                .navigationTitle("Select Category")
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            Text("Puzzle")
                                .yellowTextStyle()
                        }
                    }
                    
                    Spacer()
                    
//                    Button {
//                        
//                    } label: {
//                        Text("Daily Puzzle")
//                    }
//                    .buttonStyle(YellowButtonStyle())
//                    
//                    Button {
//                        
//                    } label: {
//                        Text("Settings")
//                    }
//                    .buttonStyle(YellowButtonStyle())
//                    .padding(.bottom,100)
                }
            }
            .onAppear{
                AppReviewRequest.requestReviewIfNeeded()
            }
            .preferredColorScheme(selectedScheme)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }


                }
            }
        }
    }
}

#Preview {
    HomeMenu()
}
