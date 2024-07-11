//
//  InterstitialAdView.swift
//  FoodRecipesHealthy
//
//  Created by David on 6/28/23.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import UIKit

final class InterstitialAdLoader: NSObject, GADFullScreenContentDelegate {
    
    // MARK: - InterstitialAdLoaderError
    enum InterstitialAdLoaderError: Error {
        case notReady
        case failedToPresent
    }
    
    // MARK: - Vars
    private let adUnit: AdUnit
    private var interstitial: GADInterstitialAd?
    private var completion: ((Result<Bool, InterstitialAdLoaderError>) -> Void)?
    
    // MARK: - Lifecycle
    init(adUnit: AdUnit) {
        self.adUnit = adUnit
        super.init()
        loadInterstitial()
    }
    
    deinit {
        interstitial = nil
    }
    
    
    // MARK: - Helper
    func loadInterstitial(){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:adUnit.unitID,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        loadInterstitial()
    }
    
    func showAd(){
        let root = UIApplication.shared.windows.first?.rootViewController
        interstitial?.present(fromRootViewController: root!)
    }
}


enum AdUnit {
    case Interstitial
    case InterstitialTest
    
    var unitID: String {
        switch self {
        case .Interstitial:
            return "ca-app-pub-2893640319240546/2769528050"
        case .InterstitialTest:
            return "ca-app-pub-3940256099942544/4411468910"
        }
    }
}
