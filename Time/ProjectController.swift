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
    var scheduledProjects = [Project]()
    var scheduledProjectRefs = [String]()
    var projectTimer: Timer!
    
    
    /// Creates a brand new project.
    /// - Check to see if their is a category prior to calling
    ///
    /// - Parameters:
    ///   - name: The name of the new Project
    ///   - categoryName: the category name of the new Project
    ///   - deadline: the deadline date for the new Project
    ///   - weight: the weight of the new Project, as a double
    /// - Returns: a new Project
    func newProject(name: String?, categoryName: String?, deadline: Date?, weight: Double, presetSessionLength: Double?, scheduledDate: Date?) -> Project {
        var cName = categoryName
        if cName == nil {
            cName = "Other"
        }
        var project = Project.init(name: name, category: categoryName, weight: weight, numberOfTimers: nil, presetSessionLength: presetSessionLength)
        
        let projectRef = FIRDatabase.database().reference().child("projects")
        
        let autoID = projectRef.childByAutoId()
        project.firebaseRef = autoID
        
        let timer = newTimer(project: project, weight: weight, deadline: deadline, scheduledDate: scheduledDate, newProject: true)
        project.activeTimer = timer
        
        if scheduledDate == nil {
            currentProject = project
        } else {
            scheduledProjects.append(project)
        }
        
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
        
        let oldCategory = p.categoryName
        p.name = name

        guard let ref = p.firebaseRef else { return nil }
        
        var updateKeys = [String: Any]()
        
        if let categoryName = categoryName {
            
            p.categoryName = categoryName
            
            if let oldCategory = oldCategory {
                CategoryContoller.sharedInstance.removeProjectFromCategory(categoryName: oldCategory, project: p)
            }
            
            if let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: categoryName) {
                CategoryContoller.sharedInstance.newProjectInExistingCategory(category: category, project: p)
            } else {
                
                var category = Category.init(name: categoryName)
                
                category.projects.append(p)
                category.projectRefs.append(ref.key)
                
                category.firebaseRef = UserController.sharedInstance.userRef?.child("categories").childByAutoId()
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
    func newTimer(project: Project, weight: Double, deadline: Date?, scheduledDate:Date?, newProject: Bool) -> ProjectTimer {
        var proj = project
        let timer = ProjectTimer.init(deadline: deadline, weight: weight, customizedSessionLength: project.presetSessionLength, scheduledDate:scheduledDate)
        
        if currentProject != nil && (scheduledDate == nil) {
           SessionController.sharedInstance.endSession(projectIsDone: false)
        }
        
        if project.numberOfTimers != nil {
            proj.numberOfTimers! += 1.0
        } else {
            proj.numberOfTimers = 1
        }
        
        if scheduledDate == nil {
            currentProject = proj
            currentProject?.activeTimer = timer
        } else {
            proj.activeTimer = timer
        }
        
        // Send notification
        if ((currentProject?.presetSessionLength) != nil) && scheduledDate == nil {
            NotificationController.sharedInstance.sessionNotification(ends: (currentProject?.presetSessionLength!)!, projectID: (project.firebaseRef?.key)!)
            
        } else if scheduledDate != nil {
            NotificationController.sharedInstance.scheduleSessionNotification(starts: scheduledDate!, project: project)
        }
        
        var updateKeys: [String : Any]
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        // if the project is not new
            if !newProject && scheduledDate == nil {
            updateKeys = ["/users/\(uid ?? "UID")/current project": proj.firebaseRef!.key,
                          "/projects/\(proj.firebaseRef!.key)/Active Timer": timer.toAnyObject()]
            
        
            } else if scheduledDate != nil {
                scheduledProjectRefs.append((proj.firebaseRef?.key)!)
                updateKeys = ["/users/\(uid ?? "UID")/Scheduled Projects": scheduledProjectRefs,
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
    
    func snoozeSessionTimer() {
        
        guard let seshLength = SessionController.sharedInstance.currentSession?.customizedSessionLength,
                let key = currentProject?.firebaseRef?.key else { return }
        
        currentProject?.activeTimer?.sessions.removeLast()
        SessionController.sharedInstance.currentSession?.customizedSessionLength = seshLength + 180
        currentProject?.activeTimer?.sessions.append(SessionController.sharedInstance.currentSession!)
        
        NotificationController.sharedInstance.sessionNotification(ends: 180, projectID: (currentProject?.firebaseRef?.key)!)
        
        let updateKeys =  ["/projects/\(key)": currentProject?.toAnyObject() as! [String: Any]]
        
        // Throw notification
        
        FIRDatabase.database().reference().updateChildValues(updateKeys) { (error, ref) in
            if let error = error {
                print(error)
            }
        }
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
                
                proj.average = total / Double(proj.timers.count)
                
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
    
    func deleteProject(project: Project, active: Bool, running: Bool) {
        
        if active {
            var index = -1
            for p in activeProjects {
                index += 1
                if p.isEqual(rhs: project) {
                    break
                }
            }
            activeProjects.remove(at: index)
            activeProjectsRefs.remove(at: index)
            
            let updateKeys = ["/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/active projects": activeProjectsRefs] as [String: Any]
            FIRDatabase.database().reference().updateChildValues(updateKeys)
            
        }
        
        if running {
            UserController.sharedInstance.userRef?.child("current project").removeValue()
        }
        
        removeProjectFromCategory(project: project)
        
        FIRDatabase.database().reference().child("projects").child((project.firebaseRef?.key)!).removeValue()
        
        
    }
    
    func removeProjectFromCategory(project: Project) {
        
        guard let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: project.categoryName!) else { return }
        
        var c = category
        
        // remove the category
        var cIndex = -1
        for p in c.projectRefs {
            cIndex += 1
            if p == project.firebaseRef?.key {
                break
            }
        }
        
        c.projectRefs.remove(at: cIndex)
        
        // if no projects left in category, delete category
        if c.projectRefs.count == 0 {
            UserController.sharedInstance.userRef?.child("categories").child((c.firebaseRef?.key)!).removeValue()
            
            // remove category from categories
        }
        
        let updateKeys = ["/users/\(FIRAuth.auth()?.currentUser?.uid ?? "UID")/categories/\((c.firebaseRef?.key)!)": c.toAnyObject()] as [String: Any]
        
        FIRDatabase.database().reference().updateChildValues(updateKeys)
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
    
    func dateString(_ date:Date) -> String {
        
//        let interval = date.timeIntervalSinceNow
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = .medium
        
        dateformatter.timeStyle = .short
    
        let format = dateformatter.string(from: date)
        
//        let calendar = Calendar.current
//        
//        let month = calendar.component(.month, from: date)
//        let weekday = calendar.component(.weekday, from: date)
//        let day = calendar.component(.day, from: date)
//        let hour = calendar.component(.hour, from: date)
//        let minute = calendar.component(.minute, from: date)
        
        return "\(format)"
        
    }
    
    /// Gives you a string of the hours and minutes from the given timeInterval.
    ///
    /// - Parameters:
    ///   - interval: the interval to change to a string
    ///   - bigVersion: If big it returns 'Hours' and 'Mins'. If not big it returns 'H' and 'M'.
    ///
    /// - Returns: a String of the hours and minutes
    func hourMinuteStringFromTimeInterval(interval: TimeInterval, bigVersion: Bool, deadline: Bool, seconds: Bool) -> String {
        let interval = Int(interval)
        let secs = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
// TODO: Days
        //        let days = (interval / 86400)
        
        let hourText = "H"
        let minText = "M"
        let secText = "S"
        
        
        // 00 : 00 : 00
        if bigVersion {
            var secondsString = "\(abs(secs))"
            var minutesString = "\(abs(minutes))"
            var hoursString = "\(abs(hours))"
            if abs(minutes) < 10 {
                minutesString = "0\(abs(minutes))"
            }
            if abs(secs) < 10 {
                secondsString = "0\(abs(secs))"
            }
            if abs(hours) < 10 {
                hoursString = "0\(abs(hours))"
            }
            
            if hours == 0 {
                return "\(minutesString) : \(secondsString)"
            } else {
                return "\(hoursString) : \(minutesString) : \(secondsString)"
            }
        }
        
        
        if hours == 0 && seconds {
            return "\(abs(minutes))" + minText + " \(abs(secs))" + secText
        } else if hours == 0 && !seconds {
            return "\(abs(minutes))" + minText
        }
        
        if minutes == 0 {
            if hours > 0 {
                return "\(abs(hours))" + hourText
            } else {
                if seconds {
                    return "\(abs(secs))" + secText
                } else if !seconds {
                    return "0" + minText
                }
                
            }
        }
        
        if deadline {
            return "\(hours)" + hourText +  " \(minutes)" + minText
        } else {
            return "\(abs(hours))" + hourText +  " \(abs(minutes))" + minText
        }
        
        
    }
    
}
