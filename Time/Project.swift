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
    
    var name: String?
    var categoryRef: String?
    var weight: Double
    var numberOfTimers: Double?
    var estimatedLength: TimeInterval
    var timers = [ProjectTimer]()
    var activeTimer: ProjectTimer?
    var firebaseRef: FIRDatabaseReference?
    
    //TODO: figure out how to do customized break length
    var customizedBreakLength: TimeInterval?
    
    init(name: String?, category: String?, weight: Double, numberOfTimers: Double?) {
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
        self.name = value?["Project Name"] as? String ?? ""
        self.weight = value?["Weight"] as! Double
        self.categoryRef = value?["Category Name"] as? String ?? ""
        self.numberOfTimers = value?["Number Of Timers"] as? Double
        
        let avg = value?["Estimated Length"] as? Double ?? 0
        self.estimatedLength = TimeInterval.init(avg)
        
        if let timers = value?["Timers"] as? [NSDictionary] {
            for timer in timers {
                self.timers.append(ProjectTimer.init(dict: timer))
            }
        }
        
        if let pt = value?["Active Timer"] as? NSDictionary {
            self.activeTimer = ProjectTimer.init(dict: pt)
        }
    }
    
    func isEqual(rhs: Project) -> Bool {
        if self.firebaseRef?.key == rhs.firebaseRef?.key {
            return true
        }
        return false
    }
    
    func toAnyObject() -> Any {
        
        let name = self.name as NSString? ?? ""
        let categoryRef = self.categoryRef as NSString? ?? ""
        let estimatedLength = self.estimatedLength as NSNumber
        
        var anyTimers = [NSDictionary]()
        if timers.count > 0 {
            for timer in timers {
                anyTimers.append(timer.toAnyObject() as! NSDictionary)
            }
        }
        
        if let activeTimer = activeTimer {
            return ["Project Name": name,
                    "Category Name": categoryRef,
                    "Weight": weight as NSNumber,
                    "Number Of Timers": numberOfTimers!,
                    "Timers": anyTimers,
                    "Estimated Length": estimatedLength,
                    "Active Timer": activeTimer.toAnyObject()]
        }
        
        return ["Project Name": name,
                "Category Name": categoryRef,
                "Weight": weight as NSNumber,
                "Number Of Timers": numberOfTimers!,
                "Timers": anyTimers,
                "Estimated Length": estimatedLength,
                "Active Timer": ""]
    }
    
}













