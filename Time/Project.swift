//
//  Project.swift
//  Timer
//
//  Created by Soren Nelson on 5/13/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Project {
    
    var name: String
    var categoryRef: String
    var weight: Double
    var numberOfTimers: Double?
    var estimatedLength: TimeInterval?
    var activeTimer: ProjectTimer?
    var firebaseRef: FIRDatabaseReference?
    
    init(name: String, category: String, weight: Double, numberOfTimers: Double?) {
        self.name = name
        self.categoryRef = category
        self.estimatedLength = 0
        self.weight = weight
        if let numberOfTimers = numberOfTimers {
            self.numberOfTimers = numberOfTimers
        } else {
            self.numberOfTimers = 1
        }
    }
    
    func isEqual(rhs: Project) -> Bool {
        if self.name == rhs.name && self.categoryRef == rhs.categoryRef {
            return true
        }
        return false
    }
    
    func toAnyObject() -> Any {
        
        // TODO: Add estimated length
        if let activeTimer = activeTimer {
            return ["Project Name": name as NSString,
                    "Category Name": categoryRef as NSString,
                    "Weight": weight as NSNumber,
                    "Number Of Timers": numberOfTimers!,
                    "Active Timer": activeTimer.toAnyObject()]
        }
        
        return ["Project Name": name as NSString,
                "Category Name": categoryRef as NSString,
                "Weight": weight as NSNumber,
                
// Don't like this ""
                "Active Timer": "",
                "Number Of Timers": numberOfTimers!]
    }
    
}













