//
//  LargeTimerTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 5/16/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

protocol LargeTimerCellUpdater {
    func updateTableView()
}

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
    var delegate: LargeTimerCellUpdater?
    var project:  Project?
    var category: Category?
    
    func setUpCell() {
        
        if let project = project {
            self.timerName.text = project.name
            self.categoryName.text = project.categoryRef
            //        running/active
            
            let projectController = ProjectController.sharedInstance
            
            if projectController.currentProject != nil && (projectController.currentProject?.isEqual(rhs: project))! {
                self.running = true
                
                self.timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false)
                self.weightNameLabel.text = projectController.weightString(weight: (project.activeTimer?.weight)!)
                self.totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: projectController.getRunningTimerTotalLength(), bigVersion: true, deadline: false)
                self.activeLabel.text = "Running"
                
            } else {
                self.running = false
                self.timeLabel.text = "-"
                let total = project.activeTimer?.totalLength ?? 0
                
                self.totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: total, bigVersion: true, deadline: false)
                self.weightNameLabel.text = projectController.weightString(weight: project.weight)
                self.breakButton.setTitle("Delete Project", for: .normal)
                self.endSessionButton.setTitle("Start Session", for: .normal)
            }
            
            if let deadline = project.activeTimer?.deadline {
                self.deadlineTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceNow, bigVersion: true, deadline: true)
                if (self.deadlineTimeLabel.text?.contains("-"))! {
                    // TODO: Fix Color
                    //  self.deadlineTimeLabel.textColor = UIColor.red
                }
            } else {
                self.deadlineTimeLabel.text = "-"
            }
        }
        
        breakButton.titleLabel?.textAlignment = .center
        cancelTimerButton.titleLabel?.textAlignment = .center
        endSessionButton.titleLabel?.textAlignment = .center
        
        // TODO: Add Typical time. Check Sketch
    }
    
    @IBAction func cancelTimer(_ sender: Any) {
        
    }
    
    @IBAction func updateTimer(_ sender: Any) {
        
    }
    
    @IBAction func notesButtonPressed(_ sender: Any) {
        
    }

    // Running: Break
    // Active: Delete Timer
    @IBAction func breakButtonPressed(_ sender: Any) {
        
    }
    
    // Running: end session
    // Active: start session
    @IBAction func endSessionPressed(_ sender: Any) {
        if running {
            SessionController.sharedInstance.endSession(projectIsDone: false)
            self.running = false
        } else {
            guard let project = project else { return }
            SessionController.sharedInstance.startSession(p: project)
            self.running = true
        }
        self.delegate?.updateTableView()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        //TODO: Fix
        let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: (project?.categoryRef)!)
        ProjectController.sharedInstance.endTimer(category: category!, project: project!)
        self.delegate?.updateTableView()
    }
}
