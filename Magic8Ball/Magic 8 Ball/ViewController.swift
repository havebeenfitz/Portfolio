//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Max Kraev on 01/04/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var ballImage: UIImageView!
    @IBOutlet weak var labelDown: UILabel!
    
    var images = [#imageLiteral(resourceName: "ball1"), #imageLiteral(resourceName: "ball2"), #imageLiteral(resourceName: "ball3"), #imageLiteral(resourceName: "ball4"), #imageLiteral(resourceName: "ball5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ballImage.image = nil
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        updateBallImage()
    }
    
    func updateBallImage() {
        let imageNumber = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        ballImage.image = images[imageNumber]
    }
    func someFuncDoNoting() {
        
    }
}

