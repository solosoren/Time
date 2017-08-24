//
//  ProjectTimer.swift
//  Timer
//
//  Created by Soren Nelson on 5/13/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ProjectTimer {
    
    var sessions = [Session]()
    var totalLength: TimeInterval
    var deadline: Date?
    var weight: Double
    var breaks = [TimeInterval]()
    var presetSessionLength: TimeInterval?
    
    init(deadline: Date?, weight: Double?, presetSessionLength: Double?) {
        
        if let weight = weight {
            self.weight = weight
        } else {
            self.weight = 0.5
        }
        
        // optionals with guard let
        if let deadline = deadline {
            self.deadline = deadline
        }
        
        if let presetSessionLength = presetSessionLength {
            self.presetSessionLength = presetSessionLength
        }
        
        self.totalLength = 0
        sessions.append(Session.init(startTime: Date.init()))
    }
    
    init(dict: NSDictionary) {
        
        let length = dict["Timer Length"] as? Double ?? 0
        self.totalLength = TimeInterval.init(length)
        
        let deadline = dict["Deadline"] as? String ?? nil
        if let deadline = deadline {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            self.deadline = formatter.date(from: deadline)
        }
        
        self.weight = dict["Weight"] as! Double
        
        let sessionArray = dict["Sessions"] as! [NSDictionary]
        for sesh in sessionArray {
            sessions.append(Session.init(dict: sesh))
        }
        
        if let presetSessionLength = dict["Preset Session Length"] as? Double {
            self.presetSessionLength = presetSessionLength
        }
    
    }
    
    func toAnyObject() -> Any {
        
        let weight = self.weight as NSNumber
        let totalLength = self.totalLength as NSNumber
        
        var anySessions = [Any]()
        for session in self.sessions {
            anySessions.append(session.toAnyObject())
        }
        
        if let deadline = deadline {
            let stringDeadline: NSString = String(describing: deadline) as NSString
            
            if let presetSessionLength = presetSessionLength {
                
                let sessionlength = presetSessionLength as NSNumber
                
                return ["Weight": weight,
                        "Deadline": stringDeadline,
                        "Timer Length": totalLength,
                        "Preset Session Length": sessionlength,
                        "Sessions": anySessions]
            } else {
                return ["Weight": weight,
                        "Deadline": stringDeadline,
                        "Timer Length": totalLength,
                        "Sessions": anySessions]
                
            }
        }
        
        let string: NSString = ""
        if let presetSessionLength = presetSessionLength {
            
            let sessionlength = presetSessionLength as NSNumber
            
            return ["Weight": weight,
                    "Deadline": string,
                    "Timer Length": totalLength,
                    "Preset Session Length": sessionlength,
                    "Sessions": anySessions]
        } else {
            return ["Weight": weight,
                    "Deadline": string,
                    "Timer Length": totalLength,
                    "Sessions": anySessions]
        }
        
    }
    
    
}














