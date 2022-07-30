//  Game.swift
//  NHL Teams
//
//  Created by rezra on 26.07.2022.
//

import Foundation

struct Game {
    var word: String
    var incorrectMovesRemaining: Int
    fileprivate var guessedLetters = [Character]()
    
    init(word: String, incorrectMovesRemaining: Int) {
        self.word = word
        self.incorrectMovesRemaining = incorrectMovesRemaining
    }  
    
    var guessedWord: String {
        var wordToShow = ""
        for letter in word {
            if guessedLetters.contains(Character(letter.lowercased())) || letter == "-" || letter == " " {
                wordToShow += String(letter)
            } else {
                wordToShow += "_"
            }
        }
        return wordToShow
    }
    
    mutating func playerGuessed(letter: Character) {
        let lowercassedLetter = Character(letter.lowercased())
        guessedLetters.append(lowercassedLetter)
        if !word.lowercased().contains(lowercassedLetter){
            incorrectMovesRemaining -= 1
        }
    }
}
