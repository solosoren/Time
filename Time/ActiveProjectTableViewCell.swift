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
    
    func setUpCell(project: Project, active: Bool, scheduled: Bool) {
        self.accessoryType = .disclosureIndicator
        
        if project.name == "" {
            projectNameLabel.text = "--"
            projectNameLabel.textColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
        } else {
            projectNameLabel.text =   project.name
        }
        
        self.categoryNameLabel.text =  project.categoryName
        
        if scheduled == true {
            self.deadlineLabel.text = "\(ProjectController.sharedInstance.dateString((project.activeTimer?.sessions.last?.startTime)!))"
            self.deadlineLabel.textColor = UIColor.init(red: 0.3, green: 0.57, blue: 0.89, alpha: 1.0)
            
        } else {
            self.deadlineLabel.textColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
            
            if let deadline = project.activeTimer?.deadline {
                self.deadlineLabel.text =  "Deadline: \(ProjectController.sharedInstance.dateString(deadline))"
                
            } else if active {
                self.deadlineLabel.text = "Active"
                
            } else {
                self.deadlineLabel.text = "Inactive"
            }
        }
        
        
        if ProjectController.sharedInstance.currentProject != nil && project.isEqual(rhs: ProjectController.sharedInstance.currentProject!) {
            self.deadlineLabel.text = "Running"
        }
        
        
        averageTimeLabel.text = "Avg: \(ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: project.average, bigVersion: false, deadline: false, seconds: true))"
    }
    
}





