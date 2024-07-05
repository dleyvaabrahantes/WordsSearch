//
//  WordSearchViewModel.swift
//  WordsSearch
//
//  Created by David on 7/4/24.
//

import Foundation
import AVFoundation

class WordSearchViewModel: ObservableObject {
    @Published var words = ["MARY", "UI", "APPLE", "CODE", "DOG", "FOOD", "CAT", "HOME", "SCHOOL", "BOOK", "CAR", "BIKE", "TREE", "HOUSE", "FISH"]
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
}
