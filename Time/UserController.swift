//
//  UserController.swift
//  Time
//
//  Created by Soren Nelson on 5/17/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class UserController {
    
    static let sharedInstance = UserController()
    var currentUser: User?
    var userRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child((FIRAuth.auth()?.currentUser?.displayName)!)
    
    
    
    

}
