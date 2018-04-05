//
//  ViewController.swift
//  Xylophone
//
//  Created by Max Kraev
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    
    var player = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func notePressed(_ sender: UIButton) {
        
        playXylophoneSound(forTag: sender.tag)
    
    }
    
    func playXylophoneSound(forTag noteTag: Int) {
        
        let url = Bundle.main.url(forResource: "note\(noteTag)", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }

}

