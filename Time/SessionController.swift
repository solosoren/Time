//
//  SessionController.swift
//  Time
//
//  Created by Soren Nelson on 5/15/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class SessionController {
    
    static let sharedInstance = SessionController()
    
    /// Ends the current session. Saves the session length and the totalLength.
    ///
    /// - Parameter projectIsDone: Whether the project is finished or not
    func endSession(projectIsDone: Bool) {
        var project = ProjectController.sharedInstance.currentProject
        var session = project?.activeTimer?.sessions.last
        session?.totalLength = abs((session?.startTime.timeIntervalSinceNow)!)
        project?.activeTimer?.sessions[(project?.activeTimer?.sessions.count)! - 1].totalLength = session?.totalLength
        
        project?.activeTimer?.totalLength = (project?.activeTimer?.totalLength)! + (session?.totalLength)!
        
        if !projectIsDone {
            ProjectController.sharedInstance.activeProjects.append(project!)
            ProjectController.sharedInstance.activeProjectsRefs.append((project?.firebaseRef?.key)!)
        } else {
            project?.timers.append((project?.activeTimer)!)
            project?.activeTimer = nil
            
            var total = 0.0
            for timer in (project?.timers)! {
                total += timer.totalLength
            }
            
            project?.estimatedLength = total / Double((project?.timers.count)!)
            
        }
        
        ProjectController.sharedInstance.currentProject = nil
        
        let updateKeys = ["/projects/\(project!.firebaseRef!.key)": project!.toAnyObject(),
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/active projects": ProjectController.sharedInstance.activeProjectsRefs,
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/current project": ""] as [String: Any]
        FIRDatabase.database().reference().updateChildValues(updateKeys) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
    }
    
    /// Starts a new session on an active timer.
    ///
    /// - Parameter project: The project to be resumed
    func startSession(p: Project) {
        
        var project = p
        
        let session = Session.init(startTime: Date.init())
        project.activeTimer?.sessions.append(session)
        
        var index = 0
        for p in ProjectController.sharedInstance.activeProjects {
            if p.isEqual(rhs: project) {
                break
            }
            index += 1
        }
        ProjectController.sharedInstance.activeProjects.remove(at: index)
        ProjectController.sharedInstance.activeProjectsRefs.remove(at: index)
        if ProjectController.sharedInstance.currentProject != nil {
            self.endSession(projectIsDone: false)
        }
        ProjectController.sharedInstance.currentProject = project
        
        let updateKeys = ["/projects/\(project.firebaseRef?.key ?? "REF")": project.toAnyObject(),
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/current project": project.firebaseRef?.key ?? "REF",
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/active projects": ProjectController.sharedInstance.activeProjectsRefs] as [String: Any]
        
        FIRDatabase.database().reference().onDisconnectUpdateChildValues(updateKeys) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
        
    }
    
    
}










