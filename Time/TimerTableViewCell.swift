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

class TimerTableViewCell: UITableViewCell {

//Labels
    @IBOutlet var timerName:        UILabel!
    @IBOutlet var time:             UILabel!
    @IBOutlet var categoryName:     UILabel!
    @IBOutlet var deadline:         UILabel!
    
    @IBOutlet var timerNameTextField: UITextField!
    
    
//Buttons
    // Done/Goal
    @IBOutlet var doneButton:       UIButton!
    // End Session/Start
    @IBOutlet var endSessionButton: UIButton!
    // Break/Schedule
    @IBOutlet var breakButton:      UIButton!
    
    let projectController = ProjectController.sharedInstance
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
            
        // Button Titles
            doneButton.setTitle("Done", for: .normal)
            endSessionButton.setTitle("End Session", for: .normal)
            breakButton.setTitle("Break", for: .normal)
            
        // No running timer
        } else {
            timerName.isHidden =    true
            time.isHidden =          true
            categoryName.isHidden = true
            deadline.isHidden =     true
            timerNameTextField.isHidden = true
            
            breakButton.setTitle("Schedule", for: .normal)
            endSessionButton.setTitle("Start", for: .normal)
            doneButton.setTitle("Goal", for: .normal)
        }
        
        doneButton.titleLabel?.textAlignment =       .center
        endSessionButton.titleLabel?.textAlignment = .center
        breakButton.titleLabel?.textAlignment =      .center
    }

//MARK: Button actions
    
    /// Button on the left is pressed. If 'Done' it ends the current timer.
    ///
    /// - Done: Running Timer
    /// - Schedule: No Running Timer
    ///
    /// - Parameter sender: Left Button
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if let currentProject = projectController.currentProject {
            projectController.endTimer(project: currentProject)
            delegate?.updateTableView()
        }
    }
    
    /// Button in the middle is pressed. If 'End Session' it ends the current session.
    ///
    /// - End Session: Running Timer
    /// - Start: No Running Timer
    ///
    /// - Parameter sender: Middle Button
    @IBAction func endSessionButtonPressed(_ sender: Any) {
        
        // Running Timer
        if let _ = projectController.currentProject {
            SessionController.sharedInstance.endSession(projectIsDone: false)
            delegate?.updateTableView()
        // No Running Timer
        } else {
            CategoryContoller.sharedInstance.newCategory(name: nil, projectName: nil, weight: 0.5, deadline: nil)
            delegate?.updateTableView()
        }
    }

}
