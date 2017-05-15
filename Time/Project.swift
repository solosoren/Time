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
    var category: String
    var weight: Double
    var timers = [ProjectTimer]()
    var estimatedLength: TimeInterval?
    var activeTimer: ProjectTimer?
    
    init(name: String, category: String, weight: Double) {
        self.name = name
        self.category = category
        self.estimatedLength = 0
        self.weight = weight
    }
    
    func isEqual(rhs: Project) -> Bool {
        if self.name == rhs.name && self.category == rhs.category {
            return true
        }
        return false
    }
    
}
