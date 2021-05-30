//
//  LogInViewController.swift
//  Dock: Computer Science
//
//  Created by Leon Djusberg on 6/14/18.
//  Copyright © 2018 Leon Djusberg. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInBtn.layer.cornerRadius = logInBtn.frame.height / 5
        forgotPasswordBtn.layer.cornerRadius = forgotPasswordBtn.frame.height / 5
    }

    @IBAction func logInTapped(_ sender: Any) {
        
        guard let password = passwordTF.text,
        password != "",
        let email = emailTF.text,
        email != "" else {
            AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                return
            }
            guard user?.user.uid != nil else {
                AlertController.showAlert(self, title: "Error", message: "User does not exist")
                return
            }
            self.performSegue(withIdentifier: "toHomeAfterLogIn", sender: nil)
        }
    }
}
