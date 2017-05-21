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
    var isActive:Bool
    var firebaseRef: FIRDatabaseReference?
    
    init(deadline: Date?, weight: Double?) {
        
        if let weight = weight {
            self.weight = weight
        } else {
            self.weight = 0.5
        }
        
        self.isActive = true
        
        // optionals with guard let
        if let deadline = deadline {
            self.deadline = deadline
        }
        
        self.totalLength = 0
        sessions.append(Session.init(startTime: Date.init()))
    }
    
    func toAnyObject() -> Any {
        
        var activeString: NSString
        if isActive {
            activeString = "true"
        } else {
            activeString = "false"
        }
        
        let weight = self.weight as NSNumber
        let totalLength = self.totalLength as NSNumber
        
        var anySessions = [Any]()
        for session in self.sessions {
            anySessions.append(session.toAnyObject())
        }
        
        if let deadline = deadline {
            let stringDeadline: NSString = String(describing: deadline) as NSString
            
            return ["Weight": weight,
                    "Is Active": activeString,
                    "Deadline": stringDeadline,
                    "Project Length": totalLength,
                    "Sessions": anySessions]
        }
        let string: NSString = ""
        return ["Weight": weight,
                "Is Active": activeString,
                "Deadline": string,
                "Project Length": totalLength,
                "Sessions": anySessions]
        
    }
    
    
}














