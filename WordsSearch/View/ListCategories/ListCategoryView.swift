//
//  ListCategoryView.swift
//  WordsSearch
//
//  Created by David on 7/5/24.
//

import SwiftUI

struct ListCategoryView: View {
    @EnvironmentObject var viewModel: WordSearchViewModel
    var listCategories: [CategoryModel] = [CategoryModel(name: "Daily", level: .easy, nameJson: "all"),
                                                         CategoryModel(name: "Animals", level: .easy, nameJson: "animals"),
                                                         CategoryModel(name: "Sports", level: .medium, nameJson: "sports"),
                                                         CategoryModel(name: "Countries", level: .medium, nameJson: "countries")]
                                                         var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack{
                    ForEach(listCategories.indices, id: \.self) { index in
                        let item = listCategories[index]
                        NavigationLink {
                            ContentView(categoryModel: item)
                                .environmentObject(viewModel)
                        } label: {
                            CategoryRow(category: item, isPremium: index == 0)
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
