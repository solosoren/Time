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
    func newProject(name: String, category: String, deadline: Date?, weight: Double) {
        
        let timer = ProjectTimer.init(deadline: deadline, weight: 0.5)
        
        var project = Project.init(name: name, category: category, weight: weight)
        
        project.activeTimer = timer
        project.timers.append(timer)
        
        projects.append(project)
        activeProjects.append(project)
        currentProject = project
        //TODO: If already a project, notify user. Ask if they want to end current timer.
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
