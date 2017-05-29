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
    
    init(startTime: Date) {
        self.startTime = startTime
    }
    
    init(dict: NSDictionary) {
        let formatter = DateFormatter()
        let start = dict["Start Time"] as? String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        self.startTime = formatter.date(from: start!)!
        self.totalLength = dict["Session Length"] as? TimeInterval
    }
    
    func toAnyObject() -> Any {
        let start: NSString = String(describing: self.startTime) as NSString
        if let totalLength = totalLength {
            let length = totalLength as NSNumber
            
            return ["Start Time": start,
                    "Session Length": length]
        }
        return ["Start Time": start,
                "Session Length": 0 as NSNumber]
    }


}
