//
//  ProjectController.swift
//  Timer
//
//  Created by Soren Nelson on 5/13/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation

class ProjectController {
    
    static let sharedInstance = ProjectController()
    var projects = [Project]()
    var currentProject: Project?
    var activeProjects = [Project]()
    
    // Creates a brand new project
    // Check to see if their is a category prior to calling
    func newProject(name: String, categoryName: String, deadline: Date?, weight: Double, completion:@escaping (Bool) -> Void) {
        
        let project = Project.init(name: name, category: categoryName, weight: weight, deadline: deadline)

        projects.append(project)
        activeProjects.append(project)
        currentProject = project
        
        completion(true)
        //TODO: If already a project, notify user. Ask if they want to end current timer.
    }
    
    // Creates a new timer to an existing project
    func newTimer(project: Project, weight: Double, deadline: Date?, completion:@escaping (Bool) -> Void) {
        let timer = ProjectTimer.init(deadline: deadline, weight: weight)
        
        currentProject = project
        currentProject?.activeTimer = timer
        currentProject?.timers.append(timer)
        activeProjects.append(currentProject!)
        
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
