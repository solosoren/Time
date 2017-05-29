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
    var projectRefs = [FIRDatabaseReference]()
    var firebaseRef: FIRDatabaseReference?
    
    init(name: String, projectName: String, weight: Double, deadline: Date?) {
        self.name = name
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? NSDictionary
        self.firebaseRef = snapshot.ref
        self.name = value?["Name"] as! String
        let refs = value?["Projects"] as? NSArray
        self.projectRefs = refs as! [FIRDatabaseReference]
    }
    
    func isEqual(rhs: Category) -> Bool {
        if self.name == rhs.name {
            return true
        }
        return false
    }
    
    func toAnyObject() -> Any {
        
        var refProjects = [String]()
        for project in projectRefs {
            refProjects.append((project.key))
        }
        
        return ["Name": name as NSString,
                "Projects": refProjects]
    }
    
    
}
