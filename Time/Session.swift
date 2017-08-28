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
    
    init(startTime: Date, customizedSessionLength: TimeInterval?) {
        self.startTime = startTime
        self.customizedSessionLength = customizedSessionLength
    }
    
    init(dict: NSDictionary) {
        let formatter = DateFormatter()
        let start = dict["Start Time"] as? String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        self.startTime = formatter.date(from: start!)!
        self.totalLength = dict["Session Length"] as? TimeInterval
        self.customizedSessionLength = dict["Customized Session Length"] as? TimeInterval
    }
    
    mutating func snooze() {
        self.customizedSessionLength = (customizedSessionLength ?? 0) + 180
    }
    
    func toAnyObject() -> Any {
        let start: NSString = String(describing: self.startTime) as NSString
        if let totalLength = totalLength {
            let length = totalLength as NSNumber
            
            if let customizedSessionLength = customizedSessionLength {
                let presetSessionLength = customizedSessionLength
                return ["Start Time": start,
                        "Session Length": length,
                        "Customized Session Length": presetSessionLength]
            }
            return ["Start Time": start,
                    "Session Length": length]
        }
        if let customizedSessionLength = customizedSessionLength {
            let presetSessionLength = customizedSessionLength
            return ["Start Time": start,
                    "Session Length": 0 as NSNumber,
                    "Customized Session Length": presetSessionLength]
        }
        return ["Start Time": start,
                "Session Length": 0 as NSNumber]
    }


}
