//
//  AppDelegate.swift
//  WordsSearch
//
//  Created by David on 7/9/24.
//

import Foundation
import GoogleMobileAds
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "621d278a6a792d31926266bb41ec61e8" ]
        
        return true
    }
}
