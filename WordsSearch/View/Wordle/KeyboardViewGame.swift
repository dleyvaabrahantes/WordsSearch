//
//  KeyboardViewGame.swift
//  WordsSearch
//
//  Created by David on 7/12/24.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
    @Binding var game: WordleGame
    var makeGuessAction: () -> Void
        
        let keys = [
            ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
            ["Z", "X", "C", "V", "B", "N", "M"]
        ]
        
        var body: some View {
            VStack(spacing: 10) {
                ForEach(keys, id: \.self) { row in
                    HStack(spacing: 5) {
                        ForEach(row, id: \.self) { key in
                            Button(action: {
                                game.addLetter(Character(key))
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred() 
                            }) {
                                Text(key)
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                    .frame(width: 30, height: 50)
                                    .background(Color.blue.opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                HStack(spacing: 10) {
                    Button(action: {
                        game.removeLetter()
                    }) {
                        Text("⌫")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                     //   game.makeGuess()
                        makeGuessAction()
                    }) {
                        Text("Enter")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .frame(width: 100, height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
}


struct TipView: View {
    var category: String
    
    var body: some View {
        VStack {
            Text("Tip for Category: \(category)")
                .font(.title)
                .padding()
            Text("Here is a helpful tip for the category \(category).")
                .padding()
            Spacer()
        }
        .transition(.opacity)
    }
}
