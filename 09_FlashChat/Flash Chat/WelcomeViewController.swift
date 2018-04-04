//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import SVProgressHUD


class WelcomeViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var googleSingInButton: GIDSignInButton!
    
    var userMail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "1076501631903-81kvgbd820kabc176ukd0h62f2e2lh3m.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func googleSignInPressed(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        SVProgressHUD.show()
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            self.performSegue(withIdentifier: "goToChat", sender: self)
            SVProgressHUD.dismiss()
        }
    }
    
    
}
