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
    func presentAlert(alert:UIAlertController)
}

class TimerTableViewCell: UITableViewCell, BreakUpdater {

//Labels
    @IBOutlet var timerName:        UILabel!
    @IBOutlet var time:             UILabel!
    @IBOutlet var minuteLabel:      UILabel!
    @IBOutlet var hourLabel:        UILabel!
    @IBOutlet var secondLabel:      UILabel!
    @IBOutlet var categoryName:     UILabel!
    @IBOutlet var deadline:         UILabel!
    @IBOutlet var sessionLength:    UILabel!
    
    @IBOutlet var timerNameTextField: UITextField!
    var breakTime: String?
    
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
            minuteLabel.isHidden = false
            hourLabel.isHidden = false
            secondLabel.isHidden = false
            breakButton.isHidden = false
            doneButton.isHidden = false
            
            
            // Timer Name Text Field
            if project.name == "" || project.name == nil {
                timerNameTextField.isEnabled = true
                timerNameTextField.placeholder = "Add Timer Name..."
            } else {
                timerNameTextField.text = ""
                timerNameTextField.isHidden = true
            }
            
            // Label text
            timerName.text =    project.name
            categoryName.text = project.categoryName
            if let timerDeadline = project.activeTimer!.deadline {
                deadline.text = "Deadline: \(projectController.hourMinuteStringFromTimeInterval(interval: timerDeadline.timeIntervalSinceNow, bigVersion: true, deadline: true, seconds: false))"
            } else {
                deadline.text = "Deadline: -"
            }
            
            if let presetSessionLength = SessionController.sharedInstance.currentSession?.customizedSessionLength {
                sessionLength.text = "Session Length: \(projectController.hourMinuteStringFromTimeInterval(interval: presetSessionLength, bigVersion: true, deadline: false, seconds: false))"
            } else {
                sessionLength.text = ""
            }
            
            time.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false, seconds: true)
            
            if abs(Int((project.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!)) < 3600 {
                minuteLabel.isHidden = true
                hourLabel.text = "M"
            } else {
                minuteLabel.isHidden = false
                hourLabel.text = "H"
            }
            
            runTimer()
            
        // Button Titles
            doneButton.setImage(#imageLiteral(resourceName: "White Checked"), for: .normal)
            endSessionButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            breakButton.setImage(#imageLiteral(resourceName: "Coffee"), for: .normal)
            
        // On Break
        } else if sessionController.onBreak {
            
            timerName.isHidden = false
            time.isHidden = false
            timerNameTextField.isHidden = true
            breakButton.isHidden = false
            doneButton.isHidden = false
            
            
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
            
            sessionLength.text = ""
            timerName.text = "Break"
            time.text = breakTime
            minuteLabel.isHidden = true
            hourLabel.isHidden = false
            secondLabel.isHidden = false
            hourLabel.text = "M"
            
            doneButton.setImage(#imageLiteral(resourceName: "Resume"), for: .normal)
            endSessionButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            breakButton.setImage(#imageLiteral(resourceName: "Snooze"), for: .normal)

            
        // No running timer
        } else {
        
            sessionLength.text = ""
            timerName.isHidden =    true
            time.isHidden =          true
            categoryName.isHidden = true
            deadline.isHidden =     true
            timerNameTextField.isHidden = true
            secondLabel.isHidden = true
            minuteLabel.isHidden = true
            hourLabel.isHidden = true
            
            breakButton.isHidden = true
            endSessionButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            doneButton.isHidden = true

        }
        
    }

//MARK: Button actions
    
    /// Button on the right is pressed. If 'Done' it ends the current timer.
    ///
    /// - Done: Running Timer
    /// - Schedule: No Running Timer
    /// - Resume Project: On Break
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
                        sessionController.startSessionNow(p: project, customizedSessionLength: project.presetSessionLength, scheduled: false)
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
            CategoryContoller.sharedInstance.newCategory(name: nil, projectName: nil, weight: 0.5, deadline: nil, presetSessionLength: nil, scheduledDate: nil)
            delegate?.updateTableView()
        }
    }
    
    /// Button in the left is pressed
    ///
    /// - Running: Start Break
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
        delegate?.updateTableView()
        
    }
    
    func runTimer() {
        projectController.projectTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if let project = projectController.currentProject {
            time.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false, seconds: true)
            
            
            if Double(abs(Int((project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!))) == SessionController.sharedInstance.currentSession?.customizedSessionLength {
                timerCompleted(true)
            }
            
            if abs(Int((project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!)) == 3600 {
                setUpCell()
            }
            
        } else {
            projectController.projectTimer.invalidate()
        }
    }
    
    func breakUpdate(length: String) {
        delegate?.updateTableView()
        breakTime = length
    }
    
    func timerCompleted(_ timer: Bool) {
        delegate?.updateTableView()
        
        if timer {
            // notify user
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Your session is complete", message: "Time for a break", preferredStyle: .alert)
                let breakAction = UIAlertAction(title: "Start Break", style: .default, handler: { (action) in
                    self.sessionController.delegate = self
                    self.sessionController.startBreak(previousProjectRef: self.projectController.currentProject?.firebaseRef?.key)
                    ProjectController.sharedInstance.projectTimer.invalidate()
                    self.delegate?.updateTableView()
                })
                let snooze = UIAlertAction(title: "Snooze", style: .default, handler: { (action) in
                    self.projectController.snoozeSessionTimer()
                    self.delegate?.updateTableView()
                    //snooze
                })
                let projectCompleted = UIAlertAction(title: "Project Complete", style: .default, handler: { (action) in
                    // project complete
                    ProjectController.sharedInstance.projectTimer.invalidate()
                    ProjectController.sharedInstance.endTimer(project: ProjectController.sharedInstance.currentProject!)
                    self.delegate?.updateTableView()
                    
                })
                
                alert.addAction(breakAction)
                alert.addAction(snooze)
                alert.addAction(projectCompleted)
                
                self.delegate?.presentAlert(alert: alert)
            })
        } else {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Break time is up", message: "Get back to work", preferredStyle: .alert)
                
                if let ref = self.sessionController.currentBreak?.previousProjectRef {
                    for project in self.projectController.activeProjects {
                        if ref == project.firebaseRef?.key {
                            let resumeAction = UIAlertAction(title: "Resume Project", style: .default, handler: { (action) in
                                self.sessionController.startSessionNow(p: project, customizedSessionLength: project.presetSessionLength, scheduled: false)

                            })
                            alert.addAction(resumeAction)
                        }
                    }
                }
                
                let snooze = UIAlertAction(title: "Snooze", style: .default, handler: { (action) in
                    self.sessionController.snooze()
                })
                let okay = UIAlertAction(title: "Okay", style: .cancel , handler: nil)
                
                
                alert.addAction(snooze)
                alert.addAction(okay)
                
                self.delegate?.presentAlert(alert: alert)
            })
        }
        
    }

}
