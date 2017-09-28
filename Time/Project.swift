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
    var categoryName: String?
    var weight: Double
    var numberOfTimers: Double?
    var average: TimeInterval
    var presetSessionLength: TimeInterval?
    var timers = [ProjectTimer]()
    var activeTimer: ProjectTimer?
    var firebaseRef: FIRDatabaseReference?
    
    //TODO: figure out how to do customized break length
    var customizedBreakLength: TimeInterval?
    
    init(name: String?, category: String?, weight: Double, numberOfTimers: Double?, presetSessionLength: Double?) {
        self.name = name
        self.categoryName = category
        self.average = 0
        self.weight = weight
        if let numberOfTimers = numberOfTimers {
            self.numberOfTimers = numberOfTimers
        } else {
            self.numberOfTimers = 1
        }
        
        if let presetSessionLength = presetSessionLength {
            self.presetSessionLength = presetSessionLength
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? NSDictionary
        self.name = value?["Project Name"] as? String ?? ""
        self.weight = value?["Weight"] as? Double ?? 0
        self.categoryName = value?["Category Name"] as? String ?? ""
        self.numberOfTimers = value?["Number Of Timers"] as? Double
        self.presetSessionLength = value?["Preset Session Length"] as? Double
        
        let avg = value?["Estimated Length"] as? Double ?? 0
        self.average = TimeInterval.init(avg)
        
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
        let categoryRef = self.categoryName as NSString? ?? ""
        let estimatedLength = self.average as NSNumber
        
        var anyTimers = [NSDictionary]()
        if timers.count > 0 {
            for timer in timers {
                anyTimers.append(timer.toAnyObject() as! NSDictionary)
            }
        }
        
        if let activeTimer = activeTimer {
            if let presetSessionLength = presetSessionLength {
                let sessionLength = presetSessionLength as NSNumber
                
                return ["Project Name": name,
                        "Category Name": categoryRef,
                        "Weight": weight as NSNumber,
                        "Number Of Timers": numberOfTimers!,
                        "Timers": anyTimers,
                        "Estimated Length": estimatedLength,
                        "Preset Session Length": sessionLength,
                        "Active Timer": activeTimer.toAnyObject()]
            }
            return ["Project Name": name,
                    "Category Name": categoryRef,
                    "Weight": weight as NSNumber,
                    "Number Of Timers": numberOfTimers!,
                    "Timers": anyTimers,
                    "Estimated Length": estimatedLength,
                    "Active Timer": activeTimer.toAnyObject()]
        }
        
        if let presetSessionLength = presetSessionLength {
            let sessionLength = presetSessionLength as NSNumber
        
            return ["Project Name": name,
                    "Category Name": categoryRef,
                    "Weight": weight as NSNumber,
                    "Number Of Timers": numberOfTimers!,
                    "Timers": anyTimers,
                    "Estimated Length": estimatedLength,
                    "Preset Session Length": sessionLength,
                    "Active Timer": ""]
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













