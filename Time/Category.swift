//
//  Category.swift
//  Time
//
//  Created by Soren Nelson on 5/18/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Category {
    
    var name: String
    var activeProjects: [Project]?
    var inactiveProjects: [Project]?
    // Store everything in projects when you query everything from firebase
    // When you need all the active/ inactive projects, loop through and sort them accordingly
    var projects: [Project]?
    var currentProject: Project?
    var firebaseRef: FIRDatabaseReference?
    
    init(name: String, projectName: String, weight: Double, deadline: Date?) {
        self.name = name
    }
    
    func isEqual(rhs: Category) -> Bool {
        if self.name == rhs.name {
            return true
        }
        return false
    }
    
    func toAnyObject() -> Any {
        
        var refProjects = [String]()
        for project in projects! {
            refProjects.append((project.firebaseRef?.key)!)
        }
        
        
        if let current = currentProject {
            return ["Name": name as NSString,
                    "Current Project": current.firebaseRef!,
                    "Projects": refProjects]
        }
        return ["Name": name as NSString,
                "Projects": refProjects]
    }
    
    
}
