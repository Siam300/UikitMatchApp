//
//  ViewController.swift
//  MatchApp
//
//  Created by Auto on 7/7/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Collection View delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
                
        // return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // configure the state of the cell based on the properties of the card that if represnts
        let cardCell = cell as? CardCollectionViewCell
        
        // get the card from the card array
        let card = cardsArray[indexPath.row]
        
        // FInish configuring cell
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            // flip the card up
            cell?.flipUP()
            
            // check if this the first card that was flipped or the second card
            if firstFlippedCardIndex == nil {
                // this is the first card flipped over
                firstFlippedCardIndex = indexPath
            } else {
                // second card that is flipped
                
                
                // run the comparison logic
                checkForMatch(indexPath)
            }
        }
    }
    
    // MARK: - Game logic methods
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        // get the two card objects for the two indices and see if that matches
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // get the two collection view cells that represnt card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            // its amatch
            
            // set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
        } else {
            // its not a match
            
            // flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        // reset tge firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
}

