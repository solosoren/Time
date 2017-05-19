//
//  Category.swift
//  Time
//
//  Created by Soren Nelson on 5/18/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation

struct Category {
    
    var name: String
    var projects = [Project]()
    
    init(name: String, projectName: String, weight: Double, deadline: Date?) {
        self.name = name
        
        self.projects = [Project.init(name: projectName, category: name, weight: weight, deadline: deadline)]
    }
    
    
    
    func isEqual(rhs: Category) -> Bool {
        if self.name == rhs.name {
            return true
        }
        return false
    }
    
//    func toAnyObject -> Any {
//        return [
//    }
    
    
}
