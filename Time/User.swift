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
    var activeProjects = [Project]()
    var currentProject: Project?
    
    init(firebaseUser: FIRUser) {
        self.uid = firebaseUser.uid
    }
    
}


/*

 {
    "Users": {
        "sorenUID": {
            "Active Projects": [ProjectRef],
            "Running Project": ProjectRef,
            "Categories": {
                "CategoryRef": {
                    "Name": "Name",
                    "Projects": [ProjectRef]
                }
            }
        }
    }
 
    "Projects": {
        "ProjectRef": {
                "Name": "Name",
                "Weight": "Weight", (Double)
                "ActiveTimer": {
                        "TimerRef": {
                            "TotalLength": "Length" (Double)
                            "Deadline": "deadline" String
                            "Sessions": [SessionRefs]
                },
                "NumberOfTimers": "NumberOfTimers", (Double)
                "Average Length": "AverageLength", (Double)
                "Longest Timer Length": "LongestLength", (Double)
        }
    }
 }
 
 */
