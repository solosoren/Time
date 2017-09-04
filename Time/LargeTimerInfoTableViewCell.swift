//
//  LargeTimerInfoTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 9/3/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class LargeTimerInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    var state = 0
    var tableview: LargeTimerViewController?


     func setUpCell() {
        
        
        switch state {
        case 1:
            if let categoryName = tableview?.category?.name {
                leftLabel.text = categoryName
            } else {
                leftLabel.text = "Random"
            }

            rightLabel.text = tableview?.activeState
            
        case 2:
            leftLabel.text = "Deadline:"
            if let deadline = tableview?.project?.activeTimer?.deadline {
                
                rightLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceNow, bigVersion: true, deadline: true, seconds: false)
            } else {
                rightLabel.text = "-"
            }
            
        case 3:
            leftLabel.text = "Total:"
            
            if tableview?.activeState == "Running" {
                leftLabel.text = "Total:"
                rightLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: ProjectController.sharedInstance.getRunningTimerTotalLength(), bigVersion: true, deadline: false, seconds: true)
                
            } else if tableview?.activeState == "Active" {
                leftLabel.text = "Last Session:"
                let lastSesh = tableview?.project?.activeTimer?.sessions.last?.totalLength ?? 0
                rightLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: lastSesh, bigVersion: true, deadline: false, seconds: true)
                    
            } else {
                
                leftLabel.text = "Last Timer:"
                //TODO: Check timers
                rightLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: tableview?.project?.timers.last?.totalLength ?? 0, bigVersion: true, deadline: false, seconds: true)
            }
            
//            let total = tableview?.project?.activeTimer?.totalLength ?? 0
//            rightLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: total, bigVersion: true, deadline: false, seconds: true)
            
        case 4:
            leftLabel.text = "Average:"
            
            if let estimatedLength = tableview?.project?.estimatedLength {
                rightLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: estimatedLength, bigVersion: false, deadline: false, seconds: true)
            }
            
        case 6:
            leftLabel.text = "Priority"
            if tableview?.activeState == "Running" {
                rightLabel.text = ProjectController.sharedInstance.weightString(weight: (tableview?.project!.activeTimer?.weight)!)
            } else {
                rightLabel.text = ProjectController.sharedInstance.weightString(weight: (tableview?.project?.weight)!)
            }
            
            
        default: break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
