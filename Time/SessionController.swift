//
//  SessionController.swift
//  Time
//
//  Created by Soren Nelson on 5/15/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation

class SessionController {
    
    static let sharedInstance = SessionController()
    
    // Ends the current session. Saves the session length and the totalLength
    func endSession() {
        var project = ProjectController.sharedInstance.currentProject
        var session = project?.activeTimer?.sessions.last
        session?.totalLength = session?.startTime.timeIntervalSinceReferenceDate
        
        project?.activeTimer?.totalLength = (project?.activeTimer?.totalLength)! + (session?.totalLength)!
        
        project?.activeTimer?.isActive = false
        
        ProjectController.sharedInstance.currentProject = nil
    }
}
