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
    var projects = [Project]()
    var currentProject: Project?
    var activeProjects = [Project]()
    
    
    
    // Creates a brand new project
    // Check to see if their is a category prior to calling
    func newProject(name: String, categoryName: String, deadline: Date?, weight: Double) -> Project {
        
        var project = Project.init(name: name, category: categoryName, weight: weight)

        _ = newTimer(project: project, weight: weight, deadline: deadline)
        
        let projectRef = FIRDatabase.database().reference().child("Projects")
        
        let autoID = projectRef.childByAutoId()
        project.firebaseRef = autoID
        autoID.setValuesForKeys(project.toAnyObject() as![String : Any])
        
        projects.append(project)
        
        return project
        //TODO: If already a project, notify user. Ask if they want to end current timer.
    }
    
    // Creates a new timer to an existing project
    func newTimer(project: Project, weight: Double, deadline: Date?) -> ProjectTimer {
        var timer = ProjectTimer.init(deadline: deadline, weight: weight)
        
        let timerRef = UserController.sharedInstance.userRef.child("Timers")
        
        
        let autoID = timerRef.childByAutoId()
        timer.firebaseRef = autoID
        
        autoID.setValuesForKeys(timer.toAnyObject() as! [String : Any])
        
        var anySessions = [Any]()
        for session in timer.sessions {
            anySessions.append(session.toAnyObject())
        }
        autoID.updateChildValues(["Sessions": anySessions])
        
        currentProject = project
        currentProject?.activeTimer = timer
        currentProject?.timers.append(timer)
        activeProjects.append(currentProject!)
        return timer
    }
    
    
    func endTimer(project: Project) {
        
        var index = -1
        for p in activeProjects {
            index += 1
            if p.isEqual(rhs: project) {
                break
            }
        }
        
        activeProjects.remove(at: index)
        
        if let currentProject = currentProject {
            if project.isEqual(rhs: currentProject) {
                SessionController.sharedInstance.endSession()
            }
        }

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
