//
//  WordList.swift
//  WordsSearch
//
//  Created by David on 7/4/24.
//

import SwiftUI

struct WordsListView: View {
    let words: [String]
    let foundWords: Set<String>
    
    var body: some View {
        HStack {
            ForEach(0..<(words.count / 5 + (words.count % 5 == 0 ? 0 : 1)), id: \.self) { index in
                VStack(alignment: .leading) {
                    ForEach(words[index * 5..<min((index + 1) * 5, words.count)], id: \.self) { word in
                        Text(word)
                            .bold()
                            .foregroundColor(self.foundWords.contains(word) ? .green : .primary)
                            .underline(self.foundWords.contains(word))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 5)
                          //  .background(Color.white)
                         //   .cornerRadius(5)
                          //  .shadow(radius: 1)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeMenu()
}
