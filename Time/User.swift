//
//  User.swift
//  Time
//
//  Created by Soren Nelson on 5/17/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import GoogleSignIn
import Firebase

struct User {
    
    var uid: String
    var projects = [Project]()
    
    init(firebaseUser: FIRUser) {
        self.uid = firebaseUser.uid
    }
    
}


/*

 {
    "Users": {
        "sorenUID": {
            "Categories": {
                "CategoryRef": True
            }
        }
    }
 }
 
 {  
    "Categories": {
        "CategoryREF": {
                "Projects": {
                    "ProjectRef": {
                        "Name": CS,
                        "OtherData": ...
                    }
                }
        }
    }
 }
 
 */
