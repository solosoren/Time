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
    var timers = [ProjectTimer]()
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
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? NSDictionary
        self.name = value?["Project Name"] as! String
        self.weight = value?["Weight"] as! Double
        self.categoryRef = value?["Category Name"] as! String
        self.numberOfTimers = value?["Number Of Timers"] as? Double
        
        if let timers = value?["Timers"] as? [NSDictionary] {
            for timer in timers {
                self.timers.append(ProjectTimer.init(dict: timer))
            }
        }
        
        if let pt = value?["Active Timer"] as? NSDictionary {
            self.activeTimer = ProjectTimer.init(dict: pt)
        }
        
        // estimated length
    }
    
    func isEqual(rhs: Project) -> Bool {
        if self.name == rhs.name && self.categoryRef == rhs.categoryRef {
            return true
        }
        return false
    }
    
    func toAnyObject() -> Any {
        
        var anyTimers = [NSDictionary]()
        if timers.count > 0 {
            for timer in timers {
                anyTimers.append(timer.toAnyObject() as! NSDictionary)
            }
        }
        
        // TODO: Add estimated length
        if let activeTimer = activeTimer {
            return ["Project Name": name as NSString,
                    "Category Name": categoryRef as NSString,
                    "Weight": weight as NSNumber,
                    "Number Of Timers": numberOfTimers!,
                    "Timers": anyTimers,
                    "Active Timer": activeTimer.toAnyObject()]
        }
        
        return ["Project Name": name as NSString,
                "Category Name": categoryRef as NSString,
                "Weight": weight as NSNumber,
                "Number Of Timers": numberOfTimers!,
                "Timers": anyTimers,
                // Don't like this ""
                "Active Timer": ""]
    }
    
}













