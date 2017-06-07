//
//  ProjectController.swift
//  Timer
//
//  Created by Soren Nelson on 5/13/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ProjectController {
    
    static let sharedInstance = ProjectController()
    var currentProject: Project?
    var activeProjectsRefs = [String]()
    var activeProjects = [Project]()
    
    // Creates a brand new project
    // Check to see if their is a category prior to calling
    func newProject(name: String, categoryName: String, deadline: Date?, weight: Double) -> Project {
        
        var project = Project.init(name: name, category: categoryName, weight: weight, numberOfTimers: nil)
        
        let projectRef = FIRDatabase.database().reference().child("projects")
        
        let autoID = projectRef.childByAutoId()
        project.firebaseRef = autoID
        
        let timer = newTimer(project: project, weight: weight, deadline: deadline, newProject: true, isActive: false)
        project.activeTimer = timer
        
        let updateKeys = ["/projects/\(autoID.key)": project.toAnyObject() as! [String: Any]]
        FIRDatabase.database().reference().updateChildValues(updateKeys)
        
        return project
        //TODO: If already a project, notify user. Ask if they want to end current timer.
    }
    
    // Creates a new timer
    func newTimer(project: Project, weight: Double, deadline: Date?, newProject: Bool, isActive: Bool) -> ProjectTimer {
        var proj = project
        let timer = ProjectTimer.init(deadline: deadline, weight: weight)
        
//        let childUpdates = ["/posts/\(key)": post,
//                            "/user-posts/\(userID)/\(key)/": post]
        
        if currentProject != nil {
           SessionController.sharedInstance.endSession(projectIsDone: false)
            // TODO: need to save project after ending session. Save in endSession
        }
        
        
        currentProject = project
        currentProject?.activeTimer = timer
        if project.numberOfTimers != nil {
            proj.numberOfTimers! += 1.0
        } else {
            proj.numberOfTimers = 1
        }
        
        // if the project is active. Remove the project from active projects because its running
        if isActive {
            var index = -1
            for p in activeProjectsRefs {
                index += 1
                if p == currentProject?.firebaseRef?.key {
                    break
                }
            }
            
            print(activeProjects[index].firebaseRef?.key ?? "")
            print(activeProjectsRefs[index])
            
            activeProjectsRefs.remove(at: index)
            activeProjects.remove(at: index)
        }
        
                
        var updateKeys: [String : Any]
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        // if the project is active then save the current project, active projects, and the projects activeTimer
        if !newProject && isActive {
            updateKeys = ["/users/\(uid ?? "UID")/current project": proj.firebaseRef!,
                          "/users/\(uid ?? "UID")/active projects": self.activeProjectsRefs,
                          "/projects/\(proj.firebaseRef!.key)/Active Timer": timer.toAnyObject()]
        
        // if the project is not new and not active then save the current project and the projects active timer
        } else if !newProject && !isActive {
            updateKeys = ["/users/\(uid ?? "UID")/current project": proj.firebaseRef!,
                          "/projects/\(proj.firebaseRef!.key)/Active Timer": timer.toAnyObject()]
            
        // if the project is new then save the current project and active projects. The active timer will be saved when you create the new project.
        } else {
            updateKeys = ["/users/\(uid ?? "UID")/current project": proj.firebaseRef!.key,
                          "/users/\(uid ?? "UID")/active projects": self.activeProjectsRefs]
        }
        
        FIRDatabase.database().reference().onDisconnectUpdateChildValues(updateKeys) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
        
        return timer
    }
    
    func getRunningTimerTotalLength() -> TimeInterval {
        var length = 0 as TimeInterval
        if let _length = currentProject?.activeTimer?.totalLength {
            length = _length
        }
        var seshLength = 0 as TimeInterval
        if let _seshLength = currentProject?.activeTimer?.sessions.last?.startTime.timeIntervalSinceReferenceDate {
            seshLength = _seshLength
        }
        return length + seshLength
    }
        
    func getAverageTimerLength() {
        
    }
    
    func endTimer(category: Category, project: Project) {
        
        var updateKeys: [String: Any]
        
        if currentProject != nil && project.isEqual(rhs: currentProject!) {
            
            SessionController.sharedInstance.endSession(projectIsDone: true)
            
            updateKeys = ["/projects/\(project.firebaseRef!.key)": project.toAnyObject() as! [String: Any],
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/current project": ""]
            
        } else {
            var index = -1
            for p in activeProjects {
                index += 1
                if p.isEqual(rhs: project) {
                    break
                }
            }
            activeProjects.remove(at: index)
            activeProjectsRefs.remove(at: index)
            
            updateKeys = ["/projects/\(project.firebaseRef!.key)": project.toAnyObject() as! [String: Any],
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/active projects": activeProjectsRefs]
        }
        
        
        
        
        FIRDatabase.database().reference().updateChildValues(updateKeys)
    }
    
    
// Strings
    
    // get the right weight string from the given weight double
    func weightString(weight: Double) -> String {
        
        if weight == 0.4 {
            return "Major"
        } else if weight == 0.5 {
            return "Average"
        }
        return "Minor"
        
    }
    
    // returns a string of the hours and minutes from the timeinterval
    func hourMinuteStringFromTimeInterval(interval: TimeInterval, bigVersion: Bool) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)

        if bigVersion {
            if hours == 0 {
                return "\(abs(minutes)) Mins"
            }

            if minutes == 0 {
                return "\(abs(hours)) Hours"
            }

            return "\(hours) Hours \(minutes) Mins"
        }


        if hours == 0 {
            return "\(abs(minutes))M"
        }

        if minutes == 0 {
            return "\(abs(hours))H"
        }
        
        return "\(hours)H \(minutes)M"
    }
    
}
