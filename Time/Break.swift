//
//  Break.swift
//  Time
//
//  Created by Soren Nelson on 7/19/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Break {
    
    var timeStarted: Date
    var totalBreakLength: TimeInterval
    var lengthLeft: TimeInterval
    var previousProjectRef: String?
    
    init(_totalBreakLength: TimeInterval?, _previousProjectRef: String?) {
        
        timeStarted = Date.init()
        if let _totalBreakLength = _totalBreakLength {
            totalBreakLength = _totalBreakLength
        } else {
            totalBreakLength = 5 * 60
        }
        
        lengthLeft = totalBreakLength
        previousProjectRef = _previousProjectRef
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? NSDictionary
        
        let length = value?["Break Length"] as? Double ?? 0
        totalBreakLength = TimeInterval.init(length)
        
        let started = value?["Time Started"] as? String ?? ""
        if started != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            self.timeStarted = formatter.date(from: started)!
            
            let timePassed = abs(timeStarted.timeIntervalSinceNow)
            lengthLeft = totalBreakLength - timePassed
        } else {
            lengthLeft = 0
            timeStarted = Date.init()
        }
        
        previousProjectRef = value?["Previous Project"] as? String ?? ""
        
    }
    
    func toAnyObject() -> Any {
        
        let length = totalBreakLength as NSNumber
        let start: NSString = String(describing: self.timeStarted) as NSString
        
        if let previousProjectRef = previousProjectRef {
            return ["Time Started": start,
                    "Break Length": length,
                    "Previous Project": previousProjectRef] as [String: Any]
        } else {
            return ["Time Started": start,
                    "Break Length": length] as [String: Any]
        }
        
        
    
    }
    
    
    
    
    
    
}
