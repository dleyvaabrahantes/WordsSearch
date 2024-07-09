//
//  CategoryRow.swift
//  WordsSearch
//
//  Created by David on 7/5/24.
//

import SwiftUI

struct CategoryRow: View {
    var category: CategoryModel
    var isPremium: Bool
    var body: some View {
        HStack{
            ZStack {
                            Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 60, height: 60)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                            
                            Text(String(category.name.prefix(1)))
                                .foregroundColor(.white)
                                .font(.title)
                                .bold()
                        }
            VStack(alignment: .leading){
                Text(category.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text(category.level.level)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                    
            }
            .padding(.leading)
            
            Spacer()
            
            if isPremium {
                Image(systemName: "chevron.right")
                    .font(.title)
                    .foregroundStyle(.gray)
            } else {
                Image(systemName: "lock")
                    .font(.title)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
    }
}

#Preview {
    ListCategoryView()
        .environmentObject(WordSearchViewModel())
}
