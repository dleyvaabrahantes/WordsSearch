//
//  HomeMenu.swift
//  WordsSearch
//
//  Created by David on 7/5/24.
//

import SwiftUI
import UIKit
import StoreKit
import GoogleMobileAds
import GameKit

struct HomeMenu: View {
    @State private var pulsate = false
    @StateObject var viewModel: WordSearchViewModel = .init()
    @AppStorage("premiumUser") var premiumUser: Bool = false
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
    let adUnitId: AdUnitBanner = .banner
    @State var height: CGFloat = 50 //Height of ad
    @State var width: CGFloat = 320 //Width of ad
    @State var adPosition: AdPosition = .bottom
    
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
                            Text(LocalizedStringKey("daily"))
                                .yellowTextStyle()
                            
                        }
                        
                        NavigationLink {
                            ListCategoryView()
                                .environmentObject(viewModel)
                                .navigationTitle(LocalizedStringKey("category"))
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            Text("Puzzle")
                                .yellowTextStyle()
                        }
                        
                        NavigationLink {
                            WordleView()
                            //    .environmentObject(viewModel)
                                .navigationTitle("Wordle Game")
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            Text("Wordle Game")
                                .yellowTextStyle()
                        }
                    }
                    
                    if !premiumUser {
                        BannerAd(adUnitId: adUnitId)
                            .frame(width: width, height: height, alignment: .center)
                            .padding(.top)
                        //.offset(y: 50)
                            .onAppear {
                                //Call this in .onAppear() b/c need to load the initial frame size
                                //.onReceive() will not be called on initial load
                                setFrame()
                            }
                        if adPosition == .top {
                            Spacer() //Pushes ad to top
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
                authenticatePlayer()
                viewModel.getIdioms()
                AppReviewRequest.requestReviewIfNeeded()
            }
            .preferredColorScheme(selectedScheme)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        HeaderBoard()
                            .navigationBarHidden(true)
                    } label: {
                        Image("trophy")
                            .foregroundColor(.white)
                    }
                }
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
    
    func setFrame() {
        
        //Get the frame of the safe area
        let safeAreaInsets = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)
        
        //Use the frame to determine the size of the ad
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        
        //Set the ads frame
        self.width = 320
        self.height = 50
    }
    
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // Show the login view controller
                // self.present(viewController, animated: true)
            } else if error != nil {
                // Handle the error
                print(error?.localizedDescription ?? "")
            } else {
                // Player is already authenticated
                print("Authenticated as \(GKLocalPlayer.local.displayName)")
            }
        }
    }
    
    
}

#Preview {
    HomeMenu()
}
