//
//  ViewController.swift
//  AgriculturalApp
//
//  Created by carlos arellano on 10/29/18.
//  Copyright © 2018 nyu.edu. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ErrorLabel.isHidden = true
        Email.text = ""
        Password.text = ""
    }
    
    
    @IBAction func SignIn(_ sender: Any){
        if let email = Email.text, let password = Password.text {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user,error) in
           if error != nil {
                self.performSegue(withIdentifier: "toFeed", sender: nil)
                
                
            }
            else{
                self.ErrorLabel.isHidden = false
            }
        })
        }
        
    }
    
    
    


}

