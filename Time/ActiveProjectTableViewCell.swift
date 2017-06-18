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
    
    func setUpCell(project: Project) {
        self.accessoryType = .disclosureIndicator
        self.projectNameLabel.text =   project.name
        self.categoryNameLabel.text =  project.categoryRef
        self.deadlineLabel.text =      "Deadline: -"
        
        if let deadline = project.activeTimer?.deadline {
            
            self.deadlineLabel.text =  "Deadline: \(ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceNow, bigVersion: false, deadline: true))"
        }
        
        //        self.averageTimeLabel.text = estimatedLength
    }
    
}
