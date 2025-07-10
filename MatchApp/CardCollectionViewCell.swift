//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Auto on 7/7/25.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    
    func configureCell(card: Card) {
        // keep track of the card this cell represents
        self.card = card
        
        // set the front image view to the image that represents the cards
        frontImageView.image = UIImage(named: card.imageName)
        
        // reset the state of the cell by checking the flip status of the card and then showing the front or the back image view accordingly
        if card.isFlipped {
            // show the front image view
            flipUP(speed: 0)
        } else {
            // show the back image view
            flipDown(speed: 0)
        }
    }
    
    func flipUP(speed: TimeInterval = 0.3) {
        // flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        // set the status of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3) {
        // flip down animation
        UIView.transition(from: frontImageView, to: backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        // set the status of the card
        card?.isFlipped = false
    }
}
