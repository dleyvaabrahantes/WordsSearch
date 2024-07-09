//
//  ListCategoryView.swift
//  WordsSearch
//
//  Created by David on 7/5/24.
//

import SwiftUI

struct ListCategoryView: View {
    @EnvironmentObject var viewModel: WordSearchViewModel
    
                                                         var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack{
                    ForEach(viewModel.listCategories.indices, id: \.self) { index in
                        let item = viewModel.listCategories[index]
                        NavigationLink {
                            ContentView(categoryModel: item)
                                .environmentObject(viewModel)
                                .navigationTitle("Word Search")
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            CategoryRow(category: item, isPremium: true)
                        }
                        
                    }
                }
            }
        }
    }
                                                         }
                                                         
                                                         #Preview {
        ListCategoryView()
            .environmentObject(WordSearchViewModel())
    }
