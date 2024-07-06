//
//  WordSearchViewModel.swift
//  WordsSearch
//
//  Created by David on 7/4/24.
//

import Foundation
import AVFoundation

class WordSearchViewModel: ObservableObject {
    @Published var words:[String] = []
    @Published var grid: [[String]] = []
    @Published var selectedCells: [Cell] = []
    
    @Published var foundWords: Set<String> = []
    
    @Published var foundCells: Set<Cell> = []
    
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
    }
    
    func updateWords(for category: String) {
        if category == "all"{
            words = ["MARY", "UI", "APPLE", "CODE", "DOG", "FOOD", "CAT", "HOME", "SCHOOL", "BOOK", "CAR", "BIKE", "TREE", "HOUSE", "FISH"]
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
            
            // Seleccionar 10 palabras aleatorias del array de palabras
            let randomWords = wordCategory.words.shuffled().prefix(10)
            
            // Devolver las palabras seleccionadas como un array
            return Array(randomWords)
        } catch {
            print("Error loading or decoding file: \(error)")
            return nil
        }
    }


}
