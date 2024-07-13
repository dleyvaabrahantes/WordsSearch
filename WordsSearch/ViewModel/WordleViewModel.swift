//
//  WordleViewModel.swift
//  WordsSearch
//
//  Created by David on 7/12/24.
//

import Foundation
import SwiftUI

class WordleViewModel: ObservableObject {
    @Published var targetWord: String = ""
    private var wordLists: [WordCategory] = []
    @Published var categoryTips: String = ""
    @Published var game = WordleGame(targetWord: "SWIFT")
    @Published var showAlert: Bool = false
    @Published var showTips: Bool = false
    @Published var showGameOverAlert: Bool = false

    init()  {
       newGame()
    }
    
    func newGame() {
        loadWords()
        selectRandomWord()
        initializeGame()
    }

    func loadWords() {
        let fileNames = ["animals", "colors", "fruits", "countries", "capitals", "sports"]  // Lista de nombres de archivos JSON
        for fileName in fileNames {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let wordList = try? JSONDecoder().decode(WordCategory.self, from: data) {
                wordLists.append(wordList)
            }
        }
    }

    func selectRandomWord() {
            guard !wordLists.isEmpty else { return }
            let allWords = wordLists.flatMap { $0.words }.filter { $0.count == 5 }
            if let selectedWord = allWords.randomElement() {
               targetWord = selectedWord.uppercased()
                if let selectedCategory = wordLists.first(where: { $0.words.contains(selectedWord) }) {
                    categoryTips = selectedCategory.category
                }
            }
        print("\(targetWord) -> \(categoryTips)")
        }
    
    func initializeGame() {
        game = WordleGame(targetWord: targetWord.uppercased())
        print("Palabra: \(game.targetWord)")
        }
    
    func makeGuess() {
            game.makeGuess()
            if game.guesses.last?.allSatisfy({ $0.state == .correct }) == true {
                showAlert = true
            }else if game.guesses.count >= game.maxAttempts {
                showGameOverAlert = true
            }
        }
}
