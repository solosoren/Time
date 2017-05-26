//
//  LargeTimerTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 5/16/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class LargeTimerTableViewCell: UITableViewCell {


    @IBOutlet var timerName: UILabel!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var activeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var deadlineTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var averageTimeLabel: UILabel!
    
    // TODO: Fix
    @IBOutlet var sessionsTimeLabel: UILabel!
    @IBOutlet var weightNameLabel: UILabel!
    
    var running = false
    var project: Project?
    var category: Category?
    
    func setUpCell(project: Project) {
        self.project = project
        
        self.timerName.text = project.name
        self.categoryName.text = project.categoryRef
//        running/active
        let projectController = ProjectController.sharedInstance
        
        if let activeTimer = project.activeTimer {
            
            self.timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: (activeTimer.sessions.last?.startTime.timeIntervalSinceReferenceDate)!, bigVersion: true)
            
            self.weightNameLabel.text = projectController.weightString(weight: activeTimer.weight)
            self.running = true
            
        } else {
            self.timeLabel.text = "-"
            self.weightNameLabel.text = projectController.weightString(weight: project.weight)
        }
        
        if let deadline = project.activeTimer?.deadline {
            self.deadlineTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceReferenceDate, bigVersion: true)
        } else {
            self.deadlineTimeLabel.text = "-"
        }
        
        self.totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: projectController.getRunningTimerTotalLength(), bigVersion: true)
        
    }
    
    
    @IBAction func cancelTimer(_ sender: Any) {
        
    }
    
    @IBAction func updateTimer(_ sender: Any) {
        
    }
    
    @IBAction func notesButtonPressed(_ sender: Any) {
        
    }

    
    @IBAction func breakButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func endSessionPressed(_ sender: Any) {
        if running {
            SessionController.sharedInstance.endSession()
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        //TODO: Fix
        let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: (project?.categoryRef)!)
        ProjectController.sharedInstance.endTimer(category: category!, project: project!)
    }
}
