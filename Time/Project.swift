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
    var timers = [ProjectTimer]()
    var estimatedLength: TimeInterval?
    var activeTimer: ProjectTimer?
    var firebaseRef: FIRDatabaseReference?
    
    init(name: String, category: String, weight: Double) {
        self.name = name
        self.categoryRef = category
        self.estimatedLength = 0
        self.weight = weight
    }
    
    func isEqual(rhs: Project) -> Bool {
        if self.name == rhs.name && self.categoryRef == rhs.categoryRef {
            return true
        }
        return false
    }
    
    func toAnyObject() -> Any {
        var stringTimers = [FIRDatabaseReference]()
        for timer in timers {
            stringTimers.append(timer.firebaseRef!)
        }
        
        if let activeTimer = activeTimer {
            return ["Project Name": name as NSString,
                    "Category Name": categoryRef as NSString,
                    "Weight": weight as NSNumber,
                    "Timers": stringTimers,
                    "Active Timer": activeTimer.firebaseRef!]
        }
        
        return ["Project Name": name as NSString,
                "Category Name": categoryRef as NSString,
                "Weight": weight as NSNumber,
                "Timers": stringTimers]
    }
    
}
