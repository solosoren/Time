//
//  ProjectTimer.swift
//  Timer
//
//  Created by Soren Nelson on 5/13/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation

struct ProjectTimer {
    
    var sessions = [Session]()
    var totalLength: TimeInterval
    var deadline: Date?
    var weight: Double
    var isActive:Bool
    
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
    
}














