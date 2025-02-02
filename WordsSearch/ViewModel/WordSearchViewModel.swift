//
//  WordSearchViewModel.swift
//  WordsSearch
//
//  Created by David on 7/4/24.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI
import GameKit

class WordSearchViewModel: ObservableObject {
    var listCategories: [CategoryModel] = [              CategoryModel(name: "Daily", level: .easy, nameJson: "daily"),
                                                         CategoryModel(name: "Animals", level: .easy, nameJson: "animals"),
                                                         CategoryModel(name: "Sports", level: .medium, nameJson: "sports"),
                                                         CategoryModel(name: "Countries", level: .medium, nameJson: "countries"),
                                                         CategoryModel(name: "Capitals", level: .medium, nameJson: "capitals"),
                                                         CategoryModel(name: "Fruits", level: .medium, nameJson: "fruits"),
                                                         CategoryModel(name: "Colors", level: .medium, nameJson: "colors"),
                                                         CategoryModel(name: "Medicine", level: .hard, nameJson: "medicine"),]
    @Published var words:[String] = []
    @Published var grid: [[String]] = []
    @Published var selectedCells: [Cell] = []
    
    @Published var foundWords: Set<String> = []
    
    @Published var foundCells: Set<Cell> = []
    
    @Published var gameCompleted = false
    
    @Published var dailyGameLimitReached = false
        
        private let dailyGameLimit = 3
    @Published var idioms: String = ""
    
    func playSound() {
            guard let url = Bundle.main.url(forResource: "success", withExtension: "mp3") else { return }
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    
    func checkSelection() {
        let selectedWord = selectedCells.map { grid[$0.row][$0.col] }.joined()
        if words.contains(selectedWord) {
            foundWords.insert(selectedWord)
            foundCells.formUnion(selectedCells)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            playSound()
        }
        
        if foundWords.count == words.count {
            Task {
                do {
                    gameCompleted = true
                    try await submitScore(words.count)
                    
                } catch {
                    print("Failed to submit score: \(error)")
                }
            }
        }
    }
    
    func cleanSelected(){
        selectedCells = []
        foundWords = []
        foundCells = []
    }
    
    //Add score
    func submitScore(_ score: Int) async throws {
        // Reemplaza con tu leaderboard ID
        let leaderboardID = "com.word.leaderboards"
        let player = GKLocalPlayer.local
        
        // Cargar la lista de leaderboards
        let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardID])
        guard let leaderboard = leaderboards.first else { return }
        
        // Cargar las entradas del jugador
        let (playerEntry, _, _) = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 1))
        
        // Calcular la nueva puntuación
        let currentScore = playerEntry?.score ?? 0
        let newScore = currentScore + score
        
        // Enviar la nueva puntuación al leaderboard
        try await GKLeaderboard.submitScore(newScore, context: 0, player: player, leaderboardIDs: [leaderboardID])
    }
    
    func updateWords(for category: String) {
        getIdioms()
            words = loadRandomWords(for: category) ?? []
        
    }

    func loadRandomWords(for category: String) -> [String]? {
        // Determinar el nombre del archivo JSON según la categoría
        let filename = category.lowercased() + idioms + ".json"
        
        // Obtener la URL del archivo en el bundle principal
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("File not found: \(filename)")
            return nil
        }
        
        do {
            // Cargar los datos del archivo
            let data = try Data(contentsOf: url)
            
            // Decodificar los datos en una estructura WordCategory
                    let wordCategory = try JSONDecoder().decode(WordCategory.self, from: data)
                    
                    // Filtrar palabras que contengan solo letras
                    let filteredWords = wordCategory.words.filter { $0.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil }
                    
                    // Seleccionar 10 palabras aleatorias del array de palabras filtradas
                    let randomWords = filteredWords.shuffled().prefix(10)
                    
                    // Devolver las palabras seleccionadas como un array
                    return Array(randomWords.map { $0.uppercased() })
        } catch {
            print("Error loading or decoding file: \(error)")
            return nil
        }
    }
    
    private func loadDailyWords() {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                var allWords: [String] = []
                let group = DispatchGroup()
                
                for category in self?.listCategories ?? [] {
                    guard category.nameJson.lowercased() != "all" else { continue }
                    group.enter()
                    self?.loadRandomWords(for: category.nameJson) { words in
                        if let words = words {
                            allWords.append(contentsOf: words)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self?.words = Array(allWords.shuffled().prefix(10))
                }
            }
        }
        
        private func loadRandomWords(for category: String, completion: @escaping ([String]?) -> Void) {
            DispatchQueue.global(qos: .userInitiated).async {
                let filename = category.lowercased() + self.idioms + ".json"
                
                guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
                    print("File not found: \(filename)")
                    completion(nil)
                    return
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    let wordCategory = try JSONDecoder().decode(WordCategory.self, from: data)
                    let filteredWords = wordCategory.words.filter { $0.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil }
                    let randomWords = filteredWords.shuffled().prefix(10)
                    completion(Array(randomWords.map { $0.uppercased() }))
                } catch {
                    print("Error loading or decoding file: \(error)")
                    completion(nil)
                }
            }
        }

        
        private func getCurrentDate() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: Date())
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
