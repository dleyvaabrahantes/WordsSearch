//
//  DetailPlanViewyearly.swift
//  WordsSearch
//
//  Created by David on 7/13/24.
//

import SwiftUI
import StoreKit

struct DetailPlanViewyearly: View {
    @EnvironmentObject var iapMOdel: StoreVM
    @Binding var selectedPlan: PremiumPlan
    let plan: PremiumPlan = .yearly
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(iapMOdel.subscriptions[0].displayName)
                 Spacer()
                if selectedPlan == plan {
                    Image.checkmarkCircleIcon
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.indigo)
                } else {
                    Image.circleIcon
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.indigo)
                }
            }
            
            Text(iapMOdel.subscriptions[0].displayPrice)
            
            Divider()
                Text(iapMOdel.subscriptions[0].description)
        }
       .padding()
        .background(.thinMaterial)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedPlan == plan ? .indigo : Color.clear, lineWidth: 4)
        )
        .padding(.horizontal)
        
        .onTapGesture { selectedPlan = plan }
    }
}

#Preview {
    DetailPlanViewyearly(selectedPlan: .constant(.yearly))
        .environmentObject(StoreVM())
}
