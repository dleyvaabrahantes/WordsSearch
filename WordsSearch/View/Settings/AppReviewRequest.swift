//
//  AppReviewRequest.swift
//  Appoint
//
//  Created by David on 2/12/23.
//

import SwiftUI
import UIKit
import StoreKit

enum AppReviewRequest {
    static var threehold = 3
    @AppStorage("runsSinceLastRequest") static var runsSinceLastRequest = 0
    @AppStorage("version") static var version = ""
    
    static func requestReviewIfNeeded(){
        runsSinceLastRequest += 1
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let thisVersion = "\(appVersion) build: \(appBuild)"
        
        print("Version: \(thisVersion)")
        print("Run count: \(runsSinceLastRequest)")
        
        if thisVersion != version {
            if runsSinceLastRequest >= threehold {
                if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                    version = thisVersion
                    runsSinceLastRequest = 0
                }
            }
        } else {
            runsSinceLastRequest = 0
        }
        
    }
}
