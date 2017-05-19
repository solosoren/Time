//
//  Project.swift
//  Timer
//
//  Created by Soren Nelson on 5/13/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation

struct Project {
    
    var name: String
    var categoryRef: String
    var weight: Double
    var timers = [ProjectTimer]()
    var estimatedLength: TimeInterval?
    var activeTimer: ProjectTimer?
    
    init(name: String, category: String, weight: Double, deadline: Date?) {
        self.name = name
        self.categoryRef = category
        self.estimatedLength = 0
        self.weight = weight
        
        let timer = ProjectTimer.init(deadline: deadline, weight: 0.5)
        self.activeTimer = timer
        self.timers.append(timer)
    }
    
    func isEqual(rhs: Project) -> Bool {
        if self.name == rhs.name && self.categoryRef == rhs.categoryRef {
            return true
        }
        return false
    }
    
}
