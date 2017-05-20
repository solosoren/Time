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
    
    init(firebaseUser: FIRUser) {
        self.uid = firebaseUser.uid
    }
    
}


/*

 {
    "Users": {
        "sorenUID": {
            "Categories": {
                "CategoryRef": {
                    "Name"
                    "Projects": [
                        "ProjectRef": True
                        ]
 
                }
            }
        }
    }
 
    "Projects": {
        "ProjectRef": {
                "Name": "Name",
                "Weight": "Weight", (Double)
                "ActiveTimer": "TimerRef",
                "Timers": [TimerRefs]
        }
    }
 
    "Timers": {
        "TimerRef": {
                "TotalLength": "Length" (Double)
                "Deadline": "deadline" String
                "Sessions": [SessionRefs]
 }
 
 */
