//
//  CardModel.swift
//  MatchApp
//
//  Created by Auto on 7/7/25.
//

import Foundation

class CardModel {
    func getCards() -> [Card] {
        // declare an empty array to store numbers that weve generated
        var generatedNumbers = [Int]()
        
        // declare empty array
        var generateCards = [Card]()
        
        // randomly generate 8 pair of cards
        while generatedNumbers.count < 8 {
            // generate random number
            let randomNumber: Int = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                // create two new card objects
                let cardOne = Card()
                let cardTwo = Card()
                
                // set their image names
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                // add them to array
                generateCards += [cardOne, cardTwo]
                
                // add this number to the list of generated numbers
                generatedNumbers.append(randomNumber)
                
                print(randomNumber)
            }
        }
        
        // randomize the cards within the array
        generateCards.shuffle()
        
        // return the array
        return generateCards
    }
}
