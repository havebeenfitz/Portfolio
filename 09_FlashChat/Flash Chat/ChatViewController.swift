//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    //MARK:- Variables
    
    var messageArray = [Message]()
    
    //MARK:- VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Delegates
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        messageTextfield.delegate = self
        
        //MARK:- Gesture Recognizer
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
     
        //MARK:- Misc
    
        configureTableView()
        recieveDataFromFirebase()
        
        messageTableView.separatorStyle = .none
        
        //let indexPath = IndexPath(row: messageArray.count - 1, section: 0)
        //messageTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    //MARK:- Table View setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return messageArray.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if messageArray[indexPath.row].sender != Auth.auth().currentUser?.email {
            cell.messageBackground.backgroundColor = UIColor.flatRedColorDark()
            cell.avatarImageView.backgroundColor = UIColor.flatCoffee()
        } else {
            cell.messageBackground.backgroundColor = UIColor.flatGreen()
            cell.avatarImageView.backgroundColor = UIColor.flatNavyBlueColorDark()
        }
        
        //tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        
        return cell
    }
    
    
    
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }

    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    //MARK:- TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {

        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
       
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
  
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        if messageTextfield.text != "" {
            
            messageTextfield.endEditing(true)
            messageTextfield.isEnabled = false
            sendButton.isEnabled = false
            
            let messagesDB = Database.database().reference().child("Messages")
            
            let messageDictionary = ["sender" : Auth.auth().currentUser?.email,
                                     "messageBody" : messageTextfield.text!]
            
            messagesDB.childByAutoId().setValue(messageDictionary) { (error, reference) in
               
                if error != nil {
                    print(error!)
                } else {
                    print("message saved")
                    self.messageTextfield.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.messageTextfield.text = ""
                }
            }
        } else {
            let ac = UIAlertController(title: "Enter the message", message: "No message", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ac.addAction(okAction)
            self.present(ac, animated: true)
        }
    }
    
    //MARK:- Recieveing messages from Firebase
    
    func recieveDataFromFirebase() {
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (dataSnapshot) in
            
            let snapshotValue = dataSnapshot.value as! Dictionary<String,String>
            
            let text = snapshotValue["messageBody"]!
            let sender = snapshotValue["sender"]!
            
            let newMessage = Message()
            newMessage.messageBody = text
            newMessage.sender = sender
            
            self.messageArray.append(newMessage)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
        }
        
    }

    
    ////////////////////////////////////////////////
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Problem Signing out")
            let ac = UIAlertController(title: "Error", message: "There was an error signing out", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ac.addAction(okAction)
            self.present(ac, animated: true)
        }
        
        
    }
    


}
