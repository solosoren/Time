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
    var inactiveProjects = [Project]()
    var currentProject: Project?
    var activeProjects = [Project]()
    
    
    // Creates a brand new project
    // Check to see if their is a category prior to calling
    func newProject(name: String, categoryName: String, deadline: Date?, weight: Double) -> Project {
        
        var project = Project.init(name: name, category: categoryName, weight: weight, numberOfTimers: nil)

        let timer = newTimer(project: project, weight: weight, deadline: deadline, new: true)
        project.activeTimer = timer
        
        let projectRef = FIRDatabase.database().reference().child("projects")
        
        let autoID = projectRef.childByAutoId()
        project.firebaseRef = autoID
        
        let updateKeys = ["/projects/\(autoID.key)": project.toAnyObject() as! [String: Any]]
        FIRDatabase.database().reference().updateChildValues(updateKeys)
        
        return project
        //TODO: If already a project, notify user. Ask if they want to end current timer.
    }
    
    // Creates a new timer to an existing project
    func newTimer(project: Project, weight: Double, deadline: Date?, new: Bool) -> ProjectTimer {
        var proj = project
        let timer = ProjectTimer.init(deadline: deadline, weight: weight)
        
//        let childUpdates = ["/posts/\(key)": post,
//                            "/user-posts/\(userID)/\(key)/": post]
        
        if currentProject != nil {
           SessionController.sharedInstance.endSession()
            // TODO: need to save project after ending session
        }
        currentProject = project
        currentProject?.activeTimer = timer
        if project.numberOfTimers != nil {
            proj.numberOfTimers! += 1.0
        } else {
            proj.numberOfTimers = 1
        }
        
        if !new {
            var index = -1
            for p in inactiveProjects {
                index += 1
                if p.isEqual(rhs: proj) {
                    break
                }
            }
            inactiveProjects.remove(at: index)
        }
        activeProjects.append(proj)
        return timer
    }
    
    func getRunningTimerTotalLength() -> TimeInterval {
        let length = currentProject?.activeTimer?.totalLength
        let sessionLength = currentProject?.activeTimer?.sessions.last?.startTime.timeIntervalSinceReferenceDate
        return length! + sessionLength!
    }
    
    
    func endTimer(category: Category, project: Project) {
        
        var index = -1
        for p in activeProjects {
            index += 1
            if p.isEqual(rhs: project) {
                break
            }
        }
        activeProjects.remove(at: index)
        inactiveProjects.append(project)
        
        if let currentProject = currentProject {
            if project.isEqual(rhs: currentProject) {
                SessionController.sharedInstance.endSession()
            }
        }
        let categoryRef = category.firebaseRef!.key
        
        let updateKeys = ["/projects/\(project.firebaseRef!.key)": project.toAnyObject() as! [String: Any],
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/categories/\(categoryRef)": category.toAnyObject()] as [String : Any]
        
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
