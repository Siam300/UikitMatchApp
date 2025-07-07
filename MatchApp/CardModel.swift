//
//  CardModel.swift
//  MatchApp
//
//  Created by Auto on 7/7/25.
//

import Foundation

class CardModel {
    func getCards() -> [Card] {
        // declare empty array
        var generateCards = [Card]()
        
        // randomly generate 8 pair of cards
        for _ in 1...8 {
            // generate random number
            let randomNumber: Int = Int.random(in: 1...13)
            
            // create two new card objects
            let cardOne = Card()
            let cardTwo = Card()
            
            // set their image names
            cardOne.imageName = "card\(randomNumber)"
            cardTwo.imageName = "card\(randomNumber)"
            
            // add them to array
            generateCards += [cardOne, cardTwo]
            
            print(randomNumber)
        }
        
        // randomize the cards within the array
        generateCards.shuffle()
        
        // return the array
        return generateCards
    }
}
