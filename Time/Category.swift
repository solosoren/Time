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
    var projects = [Project]()
    
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
        
        var refProjects = [FIRDatabaseReference]()
        for project in projects {
            refProjects.append(project.firebaseRef!)
        }
        return ["Name": name as NSString,
                "Projects": refProjects]
    }
    
    
}
