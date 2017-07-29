//
//  ActiveProjectTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 5/29/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class ActiveProjectTableViewCell: UITableViewCell {
    
    @IBOutlet var projectNameLabel:  UILabel!
    @IBOutlet var categoryNameLabel: UILabel!
    @IBOutlet var deadlineLabel:     UILabel!
    @IBOutlet var averageTimeLabel:  UILabel!
    
    func setUpCell(project: Project, active: Bool) {
        self.accessoryType = .disclosureIndicator
        
        if project.name == "" {
            projectNameLabel.text = "--"
            projectNameLabel.textColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
        } else {
            projectNameLabel.text =   project.name
        }
        
        self.categoryNameLabel.text =  project.categoryRef
        
        if let deadline = project.activeTimer?.deadline {
            
            self.deadlineLabel.text =  "Deadline: \(ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceNow, bigVersion: false, deadline: true, seconds: false))"
        } else if active {
            self.deadlineLabel.text = "Active"
        } else {
            self.deadlineLabel.text = "Inactive"
            
        }
        
        if ProjectController.sharedInstance.currentProject != nil && project.isEqual(rhs: ProjectController.sharedInstance.currentProject!) {
            self.deadlineLabel.text = "Running"
        }
        
        
        averageTimeLabel.text = "Avg: \(ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: project.estimatedLength, bigVersion: false, deadline: false, seconds: true))"
    }
    
}
