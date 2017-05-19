//
//  SignInViewController.swift
//  Time
//
//  Created by Soren Nelson on 5/17/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //		signInButton.colorScheme = .dark
        //		signInButton.style = .wide
        
    }
    
    @IBAction func googleSignInPressed(_ sender: Any) {
//        self.dismiss(animated: true) { 
        
//        }
        
    }
    
    
}
