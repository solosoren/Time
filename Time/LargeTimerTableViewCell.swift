//
//  LargeTimerTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 5/16/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class LargeTimerTableViewCell: UITableViewCell {

    // Labels
    @IBOutlet var timerName:         UILabel!
    @IBOutlet var categoryName:      UILabel!
    @IBOutlet var activeLabel:       UILabel!
    @IBOutlet var timeLabel:         UILabel!
    @IBOutlet var deadlineTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel:    UILabel!
    @IBOutlet var averageTimeLabel:  UILabel!
    // TODO: Fix
    @IBOutlet var sessionsTimeLabel: UILabel!
    @IBOutlet var weightNameLabel:   UILabel!
    
    // Buttons
    @IBOutlet var cancelTimerButton: UIButton!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var notesButton: UIButton!
    @IBOutlet var breakButton: UIButton!
    @IBOutlet var endSessionButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    
    var running = false
    var project:  Project?
    var category: Category?
    
    override func draw(_ rect: CGRect) {
        
        if let project = project {
            self.timerName.text = project.name
            self.categoryName.text = project.categoryRef
            //        running/active
            
            let projectController = ProjectController.sharedInstance
            
            if projectController.currentProject != nil && (projectController.currentProject?.isEqual(rhs: project))! {
                self.running = true
                
                self.timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true)
                self.weightNameLabel.text = projectController.weightString(weight: (project.activeTimer?.weight)!)
                self.totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: projectController.getRunningTimerTotalLength(), bigVersion: true)
                self.activeLabel.text = "Running"
                
            } else {
                self.timeLabel.text = "-"
                self.totalTimeLabel.text = "\(project.activeTimer?.totalLength ?? 0)"
                self.weightNameLabel.text = projectController.weightString(weight: project.weight)
            }
            
            if let deadline = project.activeTimer?.deadline {
                self.deadlineTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceReferenceDate, bigVersion: true)
            } else {
                self.deadlineTimeLabel.text = "-"
            }
        }
        
        cancelTimerButton.titleLabel?.textAlignment = .center
        endSessionButton.titleLabel?.textAlignment = .center
        
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
            SessionController.sharedInstance.endSession(projectIsDone: false)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        //TODO: Fix
        let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: (project?.categoryRef)!)
        ProjectController.sharedInstance.endTimer(category: category!, project: project!)
    }
}
