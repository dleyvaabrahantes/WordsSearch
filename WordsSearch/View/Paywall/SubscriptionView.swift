//
//  SubscriptionView.swift
//  WordsSearch
//
//  Created by David on 7/13/24.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @EnvironmentObject var storeVM : StoreVM
    @State var isPurchased = false
    
    
    var body: some View {
        Group{
            Section("Upgrade to Premium") {
                ForEach(storeVM.subscriptions){ product in
                    Button {
                        Task{
                            await buy(product: product)
                        }
                    } label: {
                        VStack{
                            HStack{
                                Text(product.displayPrice)
                                Text(product.displayName)
                            }
                            Text(product.description)
                        }.padding()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)

                    
                }
            }
        }
    }
    
    func buy(product: Product) async {
        do {
            if try await storeVM.purchase(product) != nil {
                isPurchased = true
            }
        }catch {
            print("purchase failed")
        }
    }
}

#Preview {
    SubscriptionView()
        .environmentObject(StoreVM())
}
