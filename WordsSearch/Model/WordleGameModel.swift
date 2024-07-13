//
//  WordleGameModel.swift
//  WordsSearch
//
//  Created by David on 7/12/24.
//

import Foundation
import SwiftUI

enum LetterState {
    case correct, misplaced, incorrect, unknown
}

struct Letter {
    var character: Character
    var state: LetterState
}

struct WordleGame {
    var targetWord: String
    var guesses: [[Letter]]
    var currentGuess: [Letter]
    var maxAttempts: Int
    
    init(targetWord: String, maxAttempts: Int = 6) {
        self.targetWord = targetWord
        self.guesses = []
        self.currentGuess = []
        self.maxAttempts = maxAttempts
    }
    
    mutating func addLetter(_ letter: Character) {
        if currentGuess.count < targetWord.count {
            currentGuess.append(Letter(character: letter, state: .unknown))
        }
    }
    
    mutating func removeLetter() {
        if !currentGuess.isEmpty {
            currentGuess.removeLast()
        }
    }
    
    mutating func makeGuess() {
        guard currentGuess.count == targetWord.count else { return }
        
        let result = checkGuess(currentGuess)
        guesses.append(result)
        currentGuess = []
    }
    
    func checkGuess(_ guess: [Letter]) -> [Letter] {
        var result = guess
        
        for i in 0..<targetWord.count {
            let index = targetWord.index(targetWord.startIndex, offsetBy: i)
            let char = targetWord[index]
            
            if guess[i].character == char {
                result[i].state = .correct
            } else if targetWord.contains(guess[i].character) {
                result[i].state = .misplaced
            } else {
                result[i].state = .incorrect
            }
        }
        
        return result
    }
}
