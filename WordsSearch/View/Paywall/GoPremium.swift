//
//  GoPremium.swift
//  WordsSearch
//
//  Created by David on 7/13/24.
//

import SwiftUI
import StoreKit

struct GoPremium: View {
    @EnvironmentObject var iapMOdel: StoreVM
    @Environment(\.dismiss) var dismiss
    @AppStorage("premiumUser") var premiumUser: Bool = false
    @State private var selectedPlan: PremiumPlan = .yearly
    var body: some View {
        NavigationView {
            if !iapMOdel.subscriptions.isEmpty {
                VStack(alignment: .leading, spacing: 15){
                        HStack{
                            Spacer()
                            VStack {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.yellow)
                                    
                                    .scaledToFit()
                                    .font(Font.system(size: 50))
                                Text(LocalizedStringKey("unlimited"))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                              .padding(.vertical)
                            Spacer()
                        }
                        FeatureView(title: "no_more_ads_title", description: "no_more_ads_description")
                        //      FeatureView(title: "Recurring alarms", description: "Daily, weekly, monthly recurring alarms")
                        FeatureView(title: "no_limits_title", description: "no_limits_description")
                    FeatureView(title: "priority_support_title", description: "priority_support_description")
                        //    FeatureView(title: "Personalize sound", description: "Personalized sound in the alarms within the app")
                        if !premiumUser {
                            VStack{
                                Text(LocalizedStringKey("choise"))
                                    .foregroundColor(.primary)
                                    .font(.system(size: 20, weight: .medium))
                                
                                DetailPlanViewyearly(selectedPlan: $selectedPlan)
                                    .environmentObject(iapMOdel)
                                DetailPlanViewMontly(selectedPlan: $selectedPlan).padding(.bottom, 12)
                                    .environmentObject(iapMOdel)
                                
                                Button {
                                    Task{
                                        var monthly = selectedPlan == .monthly ? 1 : 0
                                        try await iapMOdel.purchase(iapMOdel.subscriptions[monthly])
                                    }
                                } label: {
                                    Text(LocalizedStringKey("suscribe"))
                                        .font(.system(size: 20, weight: .medium))
                                        .padding()
                                        .background(.indigo)
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.75)
                                
                                Button {
                                    Task{
                                        await iapMOdel.restorePurchases()
                                    }
                                } label: {
                                    Text(LocalizedStringKey("restore"))
                                        .font(.system(size: 14.0, weight: .regular, design: .rounded))
                                        .frame(height: 15, alignment: .center)
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.75)
                            }
                        } else {
                            HStack{
                                Spacer()
                                
                                Link(LocalizedStringKey("manage"), destination: URL(string: "https://apps.apple.com/account/subscriptions")!)
                                    .font(.system(size: 20, weight: .medium))
                                    .padding()
                                    .background(.indigo)
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                                
                                
                                    .frame(width: UIScreen.main.bounds.width * 0.75)
                                Spacer()
                            }
                            Spacer()
                        }
                        Link("Terms of Service", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                            .font(.caption)
                            .foregroundColor(.primary)
                        //  .padding(.top,10)
                            .frame(maxWidth: .infinity)
                    }
                    .opacity(iapMOdel.subscriptions.isEmpty ? 0 : 1)
                    .overlay(content: {
                        ProgressView()
                            .opacity(iapMOdel.subscriptions.isEmpty ? 1 : 0)
                    })
                    .toolbar {
                        Button {
                            
                            dismiss()
                        } label: {
                            
                            Image.xmarkCircleIcon
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.white.opacity(0.6),
                                                 Color.secondary.opacity(0.4))
                        }
                }
            } else {
              // ProgressView()
            }
        }
           // .padding(.top)
        }
    }


#Preview {
    GoPremium()
        .environmentObject(StoreVM())
}
