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
            Circle()
                .foregroundStyle(Color(uiColor: .lightGray))
                .frame(width: 60, height: 60)
            VStack(alignment: .leading){
                Text(category.name)
                    .font(.title)
                    .foregroundStyle(.gray)
                Text(category.level.level)
                    .foregroundStyle(.gray)
                    
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
}
