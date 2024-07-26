//
//  PaywallView.swift
//  WordsSearch
//
//  Created by David on 7/13/24.
//

import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var storeVM : StoreVM
    
    var body: some View {
        VStack {
                    // what the fuck is this
                    if let subscriptionGroupStatus = storeVM.subscriptionsGroupStatus {
                        if subscriptionGroupStatus == .expired || subscriptionGroupStatus == .revoked {
                            Text("Welcome back, give the subscription another try.")
                            //display products
                        }
                    }
                    if storeVM.purchasedSubscriptions.isEmpty {
                        SubscriptionView()
                        
                    } else {
                        Text("Premium Content")
                    }
                }
                .environmentObject(storeVM)
            }
}

#Preview {
    PaywallView()
}


enum PremiumPlan: String, CaseIterable {
    case monthly = "Monthly"
    case yearly = "Yearly"
}
