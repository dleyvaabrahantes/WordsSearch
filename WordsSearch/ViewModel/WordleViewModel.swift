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
    @Published var idioms: String = ""

    init()  {
       newGame()
        getIdioms()
    }
    
    func newGame() {
        getIdioms()
        loadWords()
        selectRandomWord()
        initializeGame()
    }

    func loadWords() {
        let fileNames = ["animals", "colors", "fruits", "countries", "capitals","sports","medicine"]  // Lista de nombres de archivos JSON
        for fileName in fileNames {
            if let url = Bundle.main.url(forResource: fileName + idioms, withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let wordList = try? JSONDecoder().decode(WordCategory.self, from: data) {
                wordLists.append(wordList)
            }
        }
    }

    func selectRandomWord() {
        guard !wordLists.isEmpty else { return }
        
        // Función para comprobar si una palabra contiene tildes o diéresis
        func containsDiacritics(word: String) -> Bool {
            let diacriticCharacterSet = CharacterSet(charactersIn: "áéíóúÁÉÍÓÚüÜ")
            return word.rangeOfCharacter(from: diacriticCharacterSet) != nil
        }
        
        // Filtra palabras que no contienen tildes o diéresis
        let allWords = wordLists.flatMap { $0.words }
            .filter { $0.count == 5 && !containsDiacritics(word: $0) }
        
        if let selectedWord = allWords.randomElement() {
            targetWord = selectedWord.uppercased()
            if let selectedCategory = wordLists.first(where: { $0.words.contains(selectedWord) }) {
                categoryTips = selectedCategory.category
            }
            print("\(targetWord) -> \(categoryTips)")
        }
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
    
    func getIdioms(){
        // Obtiene el idioma preferido del dispositivo
        if let language = Locale.preferredLanguages.first {
            let languageCode = Locale(identifier: language).languageCode
            if languageCode == "es" {
                idioms = "_es"
            }else{
                idioms = ""
            }
            print("El código del idioma preferido del dispositivo es: \(languageCode ?? "Desconocido")")
        }
    }
}
