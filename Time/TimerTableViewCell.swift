//
//  TimerTableViewCell.swift
//  Timer
//
//  Created by Soren Nelson on 5/8/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

protocol TimerCellUpdater {
    func updateTableView()
}

class TimerTableViewCell: UITableViewCell, BreakUpdater {

//Labels
    @IBOutlet var timerName:        UILabel!
    @IBOutlet var time:             UILabel!
    @IBOutlet var categoryName:     UILabel!
    @IBOutlet var deadline:         UILabel!
    
    @IBOutlet var timerNameTextField: UITextField!
    
    var breakTime: String?
    var timer: Timer!
    
//Buttons
    // Done/Goal
    @IBOutlet var doneButton:       UIButton!
    // End Session/Start
    @IBOutlet var endSessionButton: UIButton!
    // Break/Schedule
    @IBOutlet var breakButton:      UIButton!
    
    let projectController = ProjectController.sharedInstance
    let sessionController = SessionController.sharedInstance
    var delegate:           TimerCellUpdater?
    
    func setUpCell() {
        let project =  projectController.currentProject
        
        timerNameTextField.isEnabled = false
        
        // Running timer
        if let project = project {
            
            timerName.isHidden =    false
            time.isHidden =         false
            categoryName.isHidden = false
            deadline.isHidden =     false
            timerNameTextField.isHidden = false
            
            // Timer Name Text Field
            if project.name == "" || project.name == nil {
                timerNameTextField.isEnabled = true
                timerNameTextField.placeholder = "Add Timer Name..."
            } else {
                timerNameTextField.isHidden = true
            }
            
            // Label text
            timerName.text =    project.name
            categoryName.text = project.categoryRef
            if let timerDeadline = project.activeTimer!.deadline {
                deadline.text = "Deadline: \(projectController.hourMinuteStringFromTimeInterval(interval: timerDeadline.timeIntervalSinceNow, bigVersion: true, deadline: true))"
            } else {
                deadline.text = "Deadline: -"
            }
            time.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false)
            
            runTimer()
            
        // Button Titles
            doneButton.setTitle("Done", for: .normal)
            endSessionButton.setTitle("End Session", for: .normal)
            breakButton.setTitle("Break", for: .normal)
            
        // On Break
        } else if sessionController.onBreak {
            
            timerName.isHidden = false
            time.isHidden = false
            timerNameTextField.isHidden = true
            
            if let previousProject = sessionController.currentBreak?.previousProjectRef {
                for project in projectController.activeProjects {
                    if project.firebaseRef?.key == previousProject {
                        
                        deadline.isHidden = false
                        var projectName:String
                        if project.name == nil || project.name == "" {
                            projectName = "-"
                        } else {
                            projectName = project.name!
                        }
                        deadline.text = "Previous Project: \(projectName)"
                    }
                }
            }
            
            
            
            timerName.text = "Break"
            time.text = breakTime
            
            doneButton.setTitle("Resume Project", for: .normal)
            endSessionButton.setTitle("End Break", for: .normal)
            breakButton.setTitle("Snooze", for: .normal)

            
        // No running timer
        } else {
        
            timerName.isHidden =    true
            time.isHidden =          true
            categoryName.isHidden = true
            deadline.isHidden =     true
            timerNameTextField.isHidden = true
            
            breakButton.setTitle("Schedule", for: .normal)
            endSessionButton.setTitle("Start Timer", for: .normal)
            doneButton.setTitle("Goal", for: .normal)
        }
        
        doneButton.titleLabel?.textAlignment =       .center
        endSessionButton.titleLabel?.textAlignment = .center
        breakButton.titleLabel?.textAlignment =      .center
        
    }

//MARK: Button actions
    
    /// Button on the right is pressed. If 'Done' it ends the current timer.
    ///
    /// - Done: Running Timer
    /// - Schedule: No Running Timer
    /// - Resume Project: Break
    ///
    /// - Parameter sender: Right Button
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if let currentProject = projectController.currentProject {
            projectController.endTimer(project: currentProject)
            delegate?.updateTableView()
        } else if sessionController.onBreak {
            if let ref = sessionController.currentBreak?.previousProjectRef {
                for project in projectController.activeProjects {
                    if ref == project.firebaseRef?.key {
                        sessionController.startSession(p: project)
                    }
                }
            }
        }
    }
    
    /// Button in the middle is pressed. If 'End Session' it ends the current session.
    ///
    /// - End Session: Running Timer
    /// - Start: No Running Timer
    /// - End Break: On Break
    ///
    /// - Parameter sender: Middle Button
    @IBAction func endSessionButtonPressed(_ sender: Any) {
        
        // Running Timer
        if let _ = projectController.currentProject {
            SessionController.sharedInstance.endSession(projectIsDone: false)
            delegate?.updateTableView()
            
        // On break
        } else if sessionController.onBreak {
            sessionController.endBreak()
            delegate?.updateTableView()
            
        // No Running Timer
        } else {
            CategoryContoller.sharedInstance.newCategory(name: nil, projectName: nil, weight: 0.5, deadline: nil)
            delegate?.updateTableView()
        }
    }
    
    /// Button in the left is pressed
    ///
    /// - Snooze: On Break
    ///
    /// - Parameter sender: Left Button
    @IBAction func breakButtonPressed(_ sender: Any) {
        
        if sessionController.onBreak == false {
            sessionController.delegate = self
            sessionController.startBreak(previousProjectRef: projectController.currentProject?.firebaseRef?.key)
        } else if sessionController.onBreak == true {
            sessionController.snooze()
        }
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if let project = projectController.currentProject {
            time.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false)
        } else {
            timer.invalidate()
        }
        
    }
    
    
    func breakUpdate(length: String) {
        delegate?.updateTableView()
        breakTime = length
    }
    
    func timerCompleted() {
        delegate?.updateTableView()
    }

}
