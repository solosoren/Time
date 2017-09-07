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
    
    init(deadline: Date?, weight: Double?, customizedSessionLength: TimeInterval?, scheduledDate:Date?) {
        
        if let weight = weight {
            self.weight = weight
        } else {
            self.weight = 0.5
        }
        
        // optionals with guard let
        if let deadline = deadline {
            self.deadline = deadline
        }
        
        var scheduled: Date
        if let scheduledDate = scheduledDate {
            scheduled = scheduledDate
        } else {
            scheduled = Date.init()
        }
        

        self.totalLength = 0
        let session = Session.init(startTime: scheduled, customizedSessionLength: customizedSessionLength)
        sessions.append(session)
        SessionController.sharedInstance.currentSession = session
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
            
            return ["Weight": weight,
                    "Deadline": stringDeadline,
                    "Timer Length": totalLength,
                    "Sessions": anySessions]
        }
        
        let string: NSString = ""
        return ["Weight": weight,
                "Deadline": string,
                "Timer Length": totalLength,
                "Sessions": anySessions]
    }
    

}














