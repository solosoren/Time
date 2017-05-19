//
//  TimerTableViewCell.swift
//  Timer
//
//  Created by Soren Nelson on 5/8/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell {

    @IBOutlet var timerName: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var deadline: UILabel!
    let projectController = ProjectController.sharedInstance
    
    func setUpCell() {
        
        if let project = projectController.currentProject  {
            timerName.text = project.name
            categoryName.text = project.categoryRef
            
// Optional
            if let timerDeadline = project.activeTimer!.deadline {
                deadline.text = "Deadline: \(projectController.hourMinuteStringFromTimeInterval(interval: timerDeadline.timeIntervalSinceNow, bigVersion: true))"
            } else {
                deadline.text = "Deadline: -"
            }
            
            time.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true)
            
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        if let currentProject = projectController.currentProject {
            projectController.endTimer(project: currentProject)
        }
    }

    @IBAction func endSessionButtonPressed(_ sender: Any) {
        if let _ = projectController.currentProject {
            SessionController.sharedInstance.endSession()
        }
    }

}
