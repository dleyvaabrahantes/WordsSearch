//
//  FeatureView.swift
//  TimeAlarmReminder
//
//  Created by David on 5/12/23.
//

import SwiftUI

struct FeatureView: View {
    @State var title: String
    @State var description: String
    var body: some View {
        HStack(alignment: .top){
            Circle()
                .foregroundColor(.green)
                .frame(width: 12, height: 12)
                .padding(8)
                .padding(.horizontal)
            VStack(alignment: .leading){
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            
        }
    }
}

struct FeatureView_Previews: PreviewProvider {
    static var previews: some View {
        FeatureView(title: "No More Ads", description: "No more ads will be shown in the app")
    }
}
