//
//  SessionController.swift
//  Time
//
//  Created by Soren Nelson on 5/15/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SessionController {
    
    static let sharedInstance = SessionController()
    
    // Ends the current session. Saves the session length and the totalLength
    func endSession(projectIsDone: Bool) {
        var project = ProjectController.sharedInstance.currentProject
        var session = project?.activeTimer?.sessions.last
        session?.totalLength = session?.startTime.timeIntervalSinceReferenceDate
        
        project?.activeTimer?.totalLength = (project?.activeTimer?.totalLength)! + (session?.totalLength)!
        
        if !projectIsDone {
            ProjectController.sharedInstance.activeProjects.append(project!)
        }
        
        ProjectController.sharedInstance.currentProject = nil
        
        let updateKeys = ["/projects/\(project!.firebaseRef!.key)": project!.toAnyObject()] as [String: Any]
        FIRDatabase.database().reference().onDisconnectUpdateChildValues(updateKeys) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
    }
}
