//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        //copied from firebase password authentication
        //optional chaining
        if let email = emailTextfield.text,let password = passwordTextfield.text{
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          // print error
            if let e = error{
                //print error description of error that is localized to the language that user has on their phone
                print(e.localizedDescription)
            }
            //registered user data without error, then navigate to chat View Controller
            else{
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
                //email has some numbers and characters
                //password is 6 character
                
            }
        }
    }
}
    
}
