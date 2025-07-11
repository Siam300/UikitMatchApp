//
//  ViewController.swift
//  MatchApp
//
//  Created by Auto on 7/7/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer: Timer?
    var milliseconds: Int = 30 * 1000
    
    var soundPlayer = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    // MARK: - Timer methods
    @objc func timerFired() {
        // decrement the counter
        milliseconds -= 1
        
        // update the label
        let seconds: Double = Double(milliseconds) / 1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // stop the timer if it reaches zero
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // TODO: check if user has cleared all the pair of cards
            checkfForGameEnd()
        }
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
        // check if theres any time remaining. dont let the user interact if the time is 0
        if milliseconds <= 0 {
            return
        }
        
        // get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            // flip the card up
            cell?.flipUP()
            
            // play flip sound
            soundPlayer.playSound(effect: .flip)
            
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
            // its a match
            // play match sound
            soundPlayer.playSound(effect: .match)
            
            // set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // was that the last pair?
            checkfForGameEnd()
        } else {
            // its not a match
            
            // play nomatch sound
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        // reset tge firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkfForGameEnd() {
        // check if theres any card that is unmatched
        // assume the user has won, loop through all the cards to see if all of them are matched
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                // weve found a card that is unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            // user has won, show alert
            showAlert(title: "Congratulations!", message: "You've won the game!")
        } else {
            // user hasnt won yet, check is theres any time left
            if milliseconds <= 0 {
                showAlert(title: "Time's Up!", message: "Sorry, better luck next time!")
            }
        }
        
    }
    
    func showAlert(title: String, message: String) {
        // create an alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // add a button for the user to dissmiss it
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        // show the alert
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

