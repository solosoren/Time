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

protocol BreakUpdater {
    func breakUpdate(length: String)
    func timerCompleted(_ timer: Bool)
}

class SessionController {
    
    static let sharedInstance = SessionController()
    var delegate: BreakUpdater?
    var breakTimer: Timer!
    var onBreak = false
    var currentBreak: Break?
    var currentSession: Session?
    
    /// Starts a new session on an active timer.
    ///
    /// - Parameter project: The project to be resumed
    func startSession(p: Project, customizedSessionLength: TimeInterval?) {
        
        var project = p
        
        let session = Session.init(startTime: Date.init(), customizedSessionLength: customizedSessionLength)
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
        
        self.currentSession = session
        
        let updateKeys = ["/projects/\(project.firebaseRef?.key ?? "REF")": project.toAnyObject(),
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/current project": project.firebaseRef?.key ?? "REF",
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/active projects": ProjectController.sharedInstance.activeProjectsRefs] as [String: Any]
        
        FIRDatabase.database().reference().updateChildValues(updateKeys) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
        
    }
    
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
            var total = 0.0
            project?.timers.append((project?.activeTimer)!)
            for timer in (project?.timers)! {
                total += timer.totalLength
            }
            
            project?.estimatedLength = total / Double((project?.timers.count)!)
            
            
            project?.activeTimer = nil
        }
        
        ProjectController.sharedInstance.currentProject = nil
        currentSession = nil
        
        if let key = project?.firebaseRef?.key {
            NotificationController.sharedInstance.scrubNotificationWith(identifier: key)
        }
        
        let updateKeys = ["/projects/\(project!.firebaseRef!.key)": project!.toAnyObject(),
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/active projects": ProjectController.sharedInstance.activeProjectsRefs,
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/current project": ""] as [String: Any]
        FIRDatabase.database().reference().updateChildValues(updateKeys) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
    }
    

    func startBreak(previousProjectRef: String?) {
        
        self.onBreak = true
        let project = ProjectController.sharedInstance.currentProject
        currentBreak = Break.init(_totalBreakLength: project?.customizedBreakLength, _previousProjectRef: previousProjectRef)
        
        self.breakTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateBreak), userInfo: nil, repeats: true)
        
        ProjectController.sharedInstance.projectTimer.invalidate()
        
        SessionController.sharedInstance.endSession(projectIsDone: false)
        
        NotificationController.sharedInstance.breakNotification(ends: (5*60), projectID: project?.firebaseRef?.key)
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let updateKeys = ["/users/\(uid ?? "UID")/break": currentBreak?.toAnyObject() as! [String: Any]]
        
        FIRDatabase.database().reference().updateChildValues(updateKeys)
    }
    
    func continueBreak() {
    
        UserController.sharedInstance.userRef?.child("break").observeSingleEvent(of: .value, with: { (snapshot) in
            self.currentBreak = Break.init(snapshot: snapshot)
            self.onBreak = true
            self.breakTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateBreak), userInfo: nil, repeats: true)
        })
    }
    
    @objc func updateBreak() {
        
        if currentBreak!.lengthLeft > 0.0 {
            delegate?.breakUpdate(length: ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: currentBreak!.lengthLeft, bigVersion: true, deadline: false, seconds: true))
            currentBreak!.lengthLeft -= 1.0
        } else {
            endBreak()
        }
    }
    
    func snooze() {
        currentBreak?.lengthLeft += (5 * 60)
        let uid = FIRAuth.auth()?.currentUser?.uid
        let updateKeys = ["/users/\(uid ?? "UID")/break": currentBreak?.toAnyObject() as! [String: Any]]
        
        FIRDatabase.database().reference().updateChildValues(updateKeys)
    }
    
    func endBreak() {
        
        breakTimer.invalidate()
        
        NotificationController.sharedInstance.scrubNotificationWith(identifier: "BREAK FOR \(UserController.sharedInstance.userRef?.key ?? currentBreak?.previousProjectRef ?? "")")
        
        currentBreak = nil
        onBreak = false
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid ?? "UID").child("break").removeValue()
        delegate?.timerCompleted(false)
        
        // notify user
    }
    
    
}










