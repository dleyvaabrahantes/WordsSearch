//
//  GameCenterAuthenticationView.swift
//  WordsSearch
//
//  Created by David on 7/26/24.
//

import Foundation
import GameKit
import SwiftUI

struct GameCenterAuthenticationView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            if let vc = vc {
                DispatchQueue.main.async {
                    viewController.present(vc, animated: true)
                }
            } else if let error = error {
                print("Error authenticating player: \(error.localizedDescription)")
            } else {
                print("Authenticated as \(GKLocalPlayer.local.displayName)")
            }
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
