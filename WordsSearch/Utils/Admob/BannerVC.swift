//
//  BannerVC.swift
//  CubaMoneyExchange
//
//  Created by David on 11/17/23.
//

import Foundation
import GoogleMobileAds
import SwiftUI

class BannerAdVC: UIViewController {
    let adUnitId: String
    
    //Initialize variable
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bannerView: GADBannerView = GADBannerView() //Creates your BannerView
    override func viewDidLoad() {
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
      
        //Add our BannerView to the VC
        view.addSubview(bannerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadBannerAd()
    }

    //Allows the banner to resize when transition from portrait to landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.bannerView.isHidden = true //So banner doesn't disappear in middle of animation
        } completion: { _ in
            self.bannerView.isHidden = false
            self.loadBannerAd()
        }
    }

    func loadBannerAd() {
        let frame = view.frame.inset(by: view.safeAreaInsets)
        let viewWidth = frame.size.width

        //Updates the BannerView size relative to the current safe area of device (This creates the adaptive banner)
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        bannerView.load(GADRequest())
    }
}

struct BannerAd: UIViewControllerRepresentable {
    let adUnitId: AdUnitBanner
    
    init(adUnitId: AdUnitBanner) {
        self.adUnitId = adUnitId
    }
    
    
    func makeUIViewController(context: Context) -> BannerAdVC {
        return BannerAdVC(adUnitId: adUnitId.unitID)
    }

    func updateUIViewController(_ uiViewController: BannerAdVC, context: Context) {
        
    }
}


enum AdUnitBanner {
    case banner
    case bannerTest
    
    var unitID: String {
        switch self {
        case .banner:
            return "\"
        case .bannerTest:
            return "ca-app-pub-3940256099942544/6300978111"
        }
    }
}

enum AdPosition {
    case top
    case bottom
}
