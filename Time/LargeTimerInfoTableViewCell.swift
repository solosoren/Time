//
//  LargeTimerInfoTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 9/3/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class LargeTimerInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var leftView: UIView!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var leftButtonTitle: UILabel!
    @IBOutlet var leftButtonInfo: UILabel!
    @IBOutlet var leftButtonMoreImage: UIImageView!
    
    @IBOutlet var rightView: UIView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var rightButtonTitle: UILabel!
    @IBOutlet var rightButtonInfo: UILabel!
    @IBOutlet var rightButtonMoreImage: UIImageView!
    
    @IBAction func leftButtonPressed(_ sender: Any) {
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
    }
    
    var state = 0
    var tableview: LargeTimerViewController?


     func setUpCell() {
        
        
        switch state {
        case 1:
            
            rightButtonTitle.text = "Priority"
            
            if let priority = tableview?.project!.activeTimer?.weight {
                 rightButtonInfo.text = ProjectController.sharedInstance.weightString(weight: priority)
            } else {
                rightButtonInfo.text = "None"
// FIXME: rightButtonInfo color
            }
            rightButtonMoreImage.isHidden = true

            if tableview?.isActive == true {
                leftButtonTitle.text = "Total"
                guard let total = tableview?.project?.activeTimer?.totalLength else {
                    leftButtonInfo.text = "None"
                    break
                }
                
                leftButtonInfo.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: total, bigVersion: false, deadline: false, seconds: false)
                
            } else {
                // TODO: Figure out the Total box
                leftButtonTitle.text = "Total"
                leftButtonInfo.text = "--"
            }
            
        case 2:
            
            leftButtonTitle.text = "Avg"
            if let average = tableview?.project?.average {
                if average == 0 {
                    leftButtonInfo.text = "--"
                } else {
                    leftButtonInfo.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: average, bigVersion: false, deadline: false, seconds: true)
                }
            } else {
                leftButtonInfo.text = "--"
            }
            leftButtonMoreImage.isHidden = true
            
            rightButtonTitle.text = "Schedule"
            rightButtonInfo.text = "None"
            
        case 3:
            
            leftButtonTitle.text = "Longest"
//            FIXME: Longest timer
            leftButtonInfo.text = "--"
            
            rightButtonTitle.text = "Optimal T.O.D."
            rightButtonInfo.text = "Not Ready"
            
//            leftLabel.text = "Deadline:"
//            if let deadline = tableview?.project?.activeTimer?.deadline {
//
//                rightLabel.text = ProjectController.sharedInstance.dateString(deadline)
//            } else {
//                rightLabel.text = ""
//            }
//                leftLabel.text = "Last Timer:"
//                //TODO: Check timers
//                rightLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: tableview?.project?.timers.last?.totalLength ?? 0, bigVersion: true, deadline: false, seconds: true)
            
            
        case 6:
            
            leftButtonTitle.text = "Avg Session"
            
            if tableview?.isActive == true {
                if let total = tableview?.project?.activeTimer?.totalLength, let count = tableview?.project?.activeTimer?.sessions.count {
                    let avg = total / Double(count)
                    leftButtonInfo.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: avg, bigVersion: false, deadline: false, seconds: false)
                } else {
                    leftButtonInfo.text = "None"
                }
                
                rightButtonMoreImage.isHidden = true
                
                
                rightButtonTitle.text = "Deadline"
                
                if let deadline = tableview?.project?.activeTimer?.deadline {
                    rightButtonInfo.text = ProjectController.sharedInstance.dateString(deadline)
                } else {
                    rightButtonInfo.text = "None"
                }
            } else {
                rightButtonTitle.text = "Complete"
                if let total = tableview?.project?.timers.last?.totalLength {
                    
                    rightButtonInfo.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: total, bigVersion: false, deadline: false, seconds: false)
                }
                
                if let total = tableview?.project?.timers.last?.totalLength, let count = tableview?.project?.timers.last?.sessions.count {
                    let avg = total / Double(count)
                    leftButtonInfo.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: avg, bigVersion: false, deadline: false, seconds: false)
                } else {
                    leftButtonInfo.text = "None"
                }
                
            }

        default: break
        }
    }

}
