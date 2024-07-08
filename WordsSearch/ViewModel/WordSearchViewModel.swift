//
//  WordSearchViewModel.swift
//  WordsSearch
//
//  Created by David on 7/4/24.
//

import Foundation
import AVFoundation

class WordSearchViewModel: ObservableObject {
    var listCategories: [CategoryModel] = [              CategoryModel(name: "Daily", level: .easy, nameJson: "all"),
                                                         CategoryModel(name: "Animals", level: .easy, nameJson: "animals"),
                                                         CategoryModel(name: "Sports", level: .medium, nameJson: "sports"),
                                                         CategoryModel(name: "Countries", level: .medium, nameJson: "countries"),
                                                         CategoryModel(name: "Capitals", level: .medium, nameJson: "capitals"),
                                                         CategoryModel(name: "Fruits", level: .medium, nameJson: "fruits"),CategoryModel(name: "Colors", level: .medium, nameJson: "colors") ]
    @Published var words:[String] = []
    @Published var grid: [[String]] = []
    @Published var selectedCells: [Cell] = []
    
    @Published var foundWords: Set<String> = []
    
    @Published var foundCells: Set<Cell> = []
    
    @Published var gameCompleted = false
    
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
            playSound()
        }
        
        if foundWords.count == words.count {
                gameCompleted = true
            }
    }
    
    func cleanSelected(){
        selectedCells = []
        foundWords = []
        foundCells = []
    }
    
    func updateWords(for category: String) {
        if category == "all"{
            loadDailyWords()
        }else{
            words = loadRandomWords(for: category) ?? []
        }
    }

    func loadRandomWords(for category: String) -> [String]? {
        // Determinar el nombre del archivo JSON según la categoría
        let filename = category.lowercased() + ".json"
        
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
                    guard category.name.lowercased() != "daily" else { continue }
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
                let filename = category.lowercased() + ".json"
                
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


}
