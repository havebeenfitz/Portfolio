//
//  ViewController.swift
//  Quizzler
//
//  Created by Max Kraev

import UIKit
import PKHUD

class ViewController: UIViewController {
    
    let allQuestions = QuestionBank()
    var pickedAnswer = false
    var questionNumber = 0
    var score = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = allQuestions.list[questionNumber].questionText
        updateUI()
    }

    @IBAction func answerPressed(_ sender: AnyObject) {
        
        if sender.tag == 1 {
            pickedAnswer = true
        } else if sender.tag == 2 {
            pickedAnswer = false
        }
        checkAnswer()
        nextQuestion()
        updateUI()
    }
    
    func updateUI() {
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(questionNumber + 1)/13"
        progressBar.frame.size.width = view.frame.size.width / 13 * CGFloat(questionNumber + 1)
    }
    
    func nextQuestion() {
        if questionNumber < allQuestions.list.count - 1 {
            questionNumber += 1
            questionLabel.text = allQuestions.list[questionNumber].questionText
        } else {
            let ac = UIAlertController(title: "The End", message: "You've made it to the end \n Your score is \(score)", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
                self.restart()
            }
            ac.addAction(restartAction)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
                self.present(ac, animated: true)
            }
            
        }

    }
    
    func checkAnswer() {
        if pickedAnswer == allQuestions.list[questionNumber].answer {
            score += 1
            HUD.flash(.success)
            updateUI()
        } else {
            HUD.flash(.error)
        }
    }
    
    func restart()   {
        score = 0
        questionNumber = 0
        updateUI()
        
        questionLabel.text = allQuestions.list[questionNumber].questionText
    }
    
}
