//
//  Session.swift
//  Timer
//
//  Created by Soren Nelson on 5/13/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct Session {

    var startTime: Date
    var totalLength: TimeInterval?
    var customizedSessionLength:TimeInterval?
    var scheduled: Bool
    
    init(startTime: Date, customizedSessionLength: TimeInterval?, scheduled: Bool) {
        self.startTime = startTime
        self.customizedSessionLength = customizedSessionLength
        self.scheduled = scheduled
    }
    
    init(dict: NSDictionary) {
        let formatter = DateFormatter()
        let start = dict["Start Time"] as? String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        self.startTime = formatter.date(from: start!)!
        self.totalLength = dict["Session Length"] as? TimeInterval
        self.customizedSessionLength = dict["Customized Session Length"] as? TimeInterval
        let scheduledInt = dict["Scheduled"] as? Int ?? 0
        if scheduledInt == 0 {
            scheduled = false
        } else {
            scheduled = true
        }
    }
    
    mutating func snooze() {
        self.customizedSessionLength = (customizedSessionLength ?? 0) + 180
    }
    
    func toAnyObject() -> Any {
        let start: NSString = String(describing: self.startTime) as NSString
        var scheduledDouble = 0.0 as NSNumber
        if scheduled == true {
            scheduledDouble = 1.0
        }
        
        if let totalLength = totalLength {
            let length = totalLength as NSNumber
            
            if let customizedSessionLength = customizedSessionLength {
                let presetSessionLength = customizedSessionLength
                return ["Start Time": start,
                        "Session Length": length,
                        "Customized Session Length": presetSessionLength,
                        "Scheduled": scheduledDouble]
            }
            return ["Start Time": start,
                    "Session Length": length,
                    "Scheduled": scheduledDouble]
        }
        if let customizedSessionLength = customizedSessionLength {
            let presetSessionLength = customizedSessionLength
            return ["Start Time": start,
                    "Session Length": 0 as NSNumber,
                    "Customized Session Length": presetSessionLength,
                    "Scheduled": scheduledDouble]
        }
        return ["Start Time": start,
                "Session Length": 0 as NSNumber,
                "Scheduled": scheduledDouble]
    }


}
