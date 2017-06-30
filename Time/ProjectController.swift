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
    
    /// Creates a brand new project.
    /// - Check to see if their is a category prior to calling
    ///
    /// - Parameters:
    ///   - name: The name of the new Project
    ///   - categoryName: the category name of the new Project
    ///   - deadline: the deadline date for the new Project
    ///   - weight: the weight of the new Project, as a double
    /// - Returns: a new Project
    func newProject(name: String?, categoryName: String?, deadline: Date?, weight: Double) -> Project {
        
        var project = Project.init(name: name, category: categoryName, weight: weight, numberOfTimers: nil)
        
        let projectRef = FIRDatabase.database().reference().child("projects")
        
        let autoID = projectRef.childByAutoId()
        project.firebaseRef = autoID
        
        let timer = newTimer(project: project, weight: weight, deadline: deadline, newProject: true)
        project.activeTimer = timer
        
        let updateKeys = ["/projects/\(autoID.key)": project.toAnyObject() as! [String: Any]]
        FIRDatabase.database().reference().updateChildValues(updateKeys)
        
        return project
        //TODO: If already a project, notify user. Ask if they want to end current timer.
    }
    
    
    /// Update the category name or project name for a project
    ///
    /// - Parameters:
    ///   - project: the project to be updated
    ///   - name: a new name
    ///   - categoryName: a new category name.
    func updateProject(project: Project, name: String?, categoryName: String?) -> Project? {
        var p = project
        
        let oldCategory = p.categoryRef
        p.name = name

        guard let ref = p.firebaseRef else { return nil }
        
        var updateKeys = [String: Any]()
        
        if let categoryName = categoryName {
            
            p.categoryRef = categoryName
            
            if let oldCategory = oldCategory {
                CategoryContoller.sharedInstance.removeProjectFromCategory(categoryName: oldCategory, project: p)
            }
            
            if let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: categoryName) {
                CategoryContoller.sharedInstance.newProjectInExistingCategory(category: category, project: p)
            } else {
                
                var category = Category.init(name: categoryName)
                
                category.projects.append(p)
                category.projectRefs.append(ref.key)
                
                category.firebaseRef = UserController.sharedInstance.userRef.child("categories").childByAutoId()
                CategoryContoller.sharedInstance.categories.append(category)
                
                let uid = FIRAuth.auth()?.currentUser?.uid
                updateKeys["/users/\(uid ?? "UID")/categories/\(category.firebaseRef!.key)"] = category.toAnyObject()
            }
        }
        
        if let _ = name {
            updateKeys["/projects/\(ref.key)"] = p.toAnyObject()
        }
        
        if updateKeys.count > 0 {
            FIRDatabase.database().reference().updateChildValues(updateKeys)
        }
        return p
    }
    
    /// Creates a new timer. If their is a running project, it stops it and sets new timer to current project.
    ///
    /// - Parameters:
    ///   - project: The timer's project
    ///   - weight: The weight of the new timer, as a double
    ///   - deadline: The deadline date for the timer
    ///   - newProject: Whether it is a new project or not
    /// - Returns: A new Project Timer
    func newTimer(project: Project, weight: Double, deadline: Date?, newProject: Bool) -> ProjectTimer {
        var proj = project
        let timer = ProjectTimer.init(deadline: deadline, weight: weight)
        
        if currentProject != nil {
           SessionController.sharedInstance.endSession(projectIsDone: false)
        }
        
        if project.numberOfTimers != nil {
            proj.numberOfTimers! += 1.0
        } else {
            proj.numberOfTimers = 1
        }
        
        currentProject = proj
        currentProject?.activeTimer = timer
        
        var updateKeys: [String : Any]
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        // if the project is not new
            if !newProject {
            updateKeys = ["/users/\(uid ?? "UID")/current project": proj.firebaseRef!.key,
                          "/projects/\(proj.firebaseRef!.key)/Active Timer": timer.toAnyObject()]
            
        // if the project is new then save the current project and active projects. The active timer will be saved when you create the new project.
        } else {
            updateKeys = ["/users/\(uid ?? "UID")/current project": proj.firebaseRef!.key,
                          "/users/\(uid ?? "UID")/active projects": self.activeProjectsRefs]
        }
        FIRDatabase.database().reference().updateChildValues(updateKeys) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
        return timer
    }
    
    
    /// Get the current Project timers Total Length. Not to be confused with the timer's current session total length.
    ///
    /// - Returns: the timers total Length
    func getRunningTimerTotalLength() -> TimeInterval {
        var length = 0 as TimeInterval
        if let _length = currentProject?.activeTimer?.totalLength {
            length = _length
        }
        var seshLength = 0 as TimeInterval
        if let _seshLength = currentProject?.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow {
            seshLength = _seshLength
        }
        return length + seshLength
    }
    
    
    func getAverageTimerLength() {
        
    }
    
    
    /// Ends the Timer of the given project.
    ///
    /// - Parameters:
    ///   - project: the project of the Timer
    func endTimer(project: Project) {
        
        var updateKeys: [String: Any]
        var proj = project
        
        if currentProject != nil && project.isEqual(rhs: currentProject!) {
            
            SessionController.sharedInstance.endSession(projectIsDone: true)
            
        } else {
            proj.timers.append(project.activeTimer!)
            proj.activeTimer = nil
            
            if proj.timers.count > 0 {
                var total = 0.0
                for timer in proj.timers {
                    total += timer.totalLength
                }
                
                proj.estimatedLength = total / Double(proj.timers.count)
                
            }
            
            var index = -1
            for p in activeProjects {
                index += 1
                if p.isEqual(rhs: project) {
                    break
                }
            }
            activeProjects.remove(at: index)
            activeProjectsRefs.remove(at: index)
            
            updateKeys = ["/projects/\(project.firebaseRef!.key)": proj.toAnyObject() as! [String: Any],
                          "/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/active projects": activeProjectsRefs]
            
            FIRDatabase.database().reference().updateChildValues(updateKeys)
        }
        
    }
    
    
// MARK: Strings
    
    
    /// Get right weight string from the given weight double.
    ///
    /// - Parameter weight: the weight in double form
    /// - Returns: the weight in string form
    func weightString(weight: Double) -> String {
        
        if weight == 0.4 {
            return "Major"
        } else if weight == 0.5 {
            return "Average"
        }
        return "Minor"
        
    }
    
    /// Gives you a string of the hours and minutes from the given timeInterval.
    ///
    /// - Parameters:
    ///   - interval: the interval to change to a string
    ///   - bigVersion: If big it returns 'Hours' and 'Mins'. If not big it returns 'H' and 'M'.
    ///
    /// - Returns: a String of the hours and minutes
    func hourMinuteStringFromTimeInterval(interval: TimeInterval, bigVersion: Bool, deadline: Bool) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
// TODO: Days
        //        let days = (interval / 86400)
        
        var hourText = "H"
        var minText = "M"
        
        if bigVersion {
            hourText = " Hours"
            minText =  " Mins"
        }
        
        if hours == 0 {
            return "\(abs(minutes))" + minText
        }
        
        if minutes == 0 {
            return "\(abs(hours))" + hourText
        }
        
        if deadline {
            return "\(hours)" + hourText +  " \(minutes)" + minText
        } else {
            return "\(abs(hours))" + hourText +  " \(abs(minutes))" + minText
        }

        
    }
    
}
