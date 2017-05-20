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
