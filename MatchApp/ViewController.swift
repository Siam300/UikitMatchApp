//
//  ViewController.swift
//  MatchApp
//
//  Created by Auto on 7/7/25.
//

import UIKit

class ViewController: UIViewController {
    
    let model = CardModel()
    var cardsArray = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
    }


}

