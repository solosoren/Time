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

class SignInViewController: UIViewController, SignInDelegate, PermissionDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    var homeVC: ProjectViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.colorScheme = .dark
        signInButton.style = .wide
        homeVC?.signInDelegate = self
        
    }
    
    @IBAction func googleSignInPressed(_ sender: Any) {
        
    }
    
    func finishedSigningIn() {
        NotificationController.sharedInstance.delegate = self
        NotificationController.sharedInstance.requestForPermission()
    }
    
    func requestGranted() {
        DispatchQueue.main.async { 
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
