//
//  ViewController.swift
//  Dicee
//
//  Created by Max Kraev on 01/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    var randomDiceIndex1 = 0
    var randomDiceIndex2 = 0
    
    let images = [#imageLiteral(resourceName: "dice1"), #imageLiteral(resourceName: "dice2"), #imageLiteral(resourceName: "dice3"), #imageLiteral(resourceName: "dice4"), #imageLiteral(resourceName: "dice5"), #imageLiteral(resourceName: "dice6")]

    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDices()
        
    }
    
    @IBAction func rollButtonPressed(_ sender: Any) {
        
        updateDices()
        
    }
    func updateDices() {
        
        randomDiceIndex1 = GKRandomSource.sharedRandom().nextInt(upperBound: 6)
        randomDiceIndex2 = GKRandomSource.sharedRandom().nextInt(upperBound: 6)
        
        diceImageView1.image = images[randomDiceIndex1]
        diceImageView2.image = images[randomDiceIndex2]
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        updateDices()
    }
}

