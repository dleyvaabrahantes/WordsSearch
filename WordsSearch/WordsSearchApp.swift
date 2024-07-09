//
//  WordsSearchApp.swift
//  WordsSearch
//
//  Created by David on 7/3/24.
//

import SwiftUI

@main
struct WordsSearchApp: App {
    @AppStorage("currentPage") var currentIndex = 0
    
    
    var body: some Scene {
        WindowGroup {
         //   ContentView()
            if currentIndex > 2 {
                HomeMenu()
            }else {
                OnBoardingScreen()
            }
        }
    }
}
