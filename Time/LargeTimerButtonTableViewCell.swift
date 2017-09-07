//
//  LargeTimerButtonTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 9/3/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class LargeTimerButtonTableViewCell: UITableViewCell {

    @IBOutlet var leftButton: UIButton!
    @IBOutlet var centerButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    var state = 7
    var tableview: LargeTimerViewController?
    
    func setUpCell() {
        
        leftButton.titleLabel?.textAlignment = .center
        centerButton.titleLabel?.textAlignment = .center
        rightButton.titleLabel?.textAlignment = .center
        
        if state == 7 {
            //Current & Active:cancel timer || inactive:Make Repeating
            leftButton.setTitle("Cancel Timer", for: .normal)
            centerButton.setTitle("Update", for: .normal)
            rightButton.setTitle("Notes", for: .normal)
            
            if tableview?.activeState == "Inactive" {
                leftButton.setTitle("Make Repeating", for: .normal)
            }
        } else {
            
            leftButton.setTitle("Break", for: .normal)
            centerButton.setTitle("End Session", for: .normal)
            rightButton.setTitle("Done", for: .normal)
            
            if tableview?.activeState == "Active" {
                leftButton.setTitle("Delete Project", for: .normal)
                centerButton.setTitle("Start Session", for: .normal)
                
            } else if tableview?.activeState == "Inactive" {
                leftButton.setTitle("Delete Project", for: .normal)
                centerButton.setTitle("Start", for: .normal)
                rightButton.setTitle("New", for: .normal)
            }
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    // state 7:
    //      Running & Active: Cancel Timer
    //      Inactive: Make Repeating
    //
    // state 8:
    //      Running: break
    //      Active & Inactive: Delete Project
    //
    @IBAction func leftButtonPressed(_ sender: Any) {
        
        if state == 7 {
            
            
        } else {
            if tableview?.activeState == "Running" {
                SessionController.sharedInstance.delegate = tableview?.breakUpdater
                SessionController.sharedInstance.startBreak(previousProjectRef: tableview?.project?.firebaseRef?.key)
                tableview?.running = false
                tableview?.isActive = false
                tableview?.activeState = "Inactive"
                
            } else {
                guard let project = tableview?.project else { return }
                ProjectController.sharedInstance.deleteProject(project: project, active: (tableview?.isActive)!, running: false)
                
            }
            
            tableview?.setUp()
            tableview?.delegate?.updateTableView()
        }
        
    }
    
    
    // state 7: Update
    //
    // state 8:
    //      Running: End Session
    //      Active: Start Session
    //      Inactive: Start
    //
    @IBAction func centerButtonPressed(_ sender: Any) {
        
        if state == 7 {
            
        } else {
            if tableview?.activeState == "Running" {
                SessionController.sharedInstance.endSession(projectIsDone: false)
                tableview?.running = false
                tableview?.isActive = true
                tableview?.activeState = "Active"
                
            } else if tableview?.activeState == "Active" {
                guard let project = tableview?.project else { return }
                SessionController.sharedInstance.startSessionNow(p: project, customizedSessionLength: project.presetSessionLength)
                tableview?.running = true
                tableview?.activeState = "Running"
                if SessionController.sharedInstance.onBreak {
                    SessionController.sharedInstance.endBreak()
                }
            } else {
                guard let project = tableview?.project else { return }
                let _ = ProjectController.sharedInstance.newTimer(project: project, weight: project.weight, deadline: nil, scheduledDate: nil,  newProject: false)
                tableview?.running = true
                tableview?.activeState = "Running"
                tableview?.project = ProjectController.sharedInstance.currentProject
                if SessionController.sharedInstance.onBreak {
                    SessionController.sharedInstance.endBreak()
                }
            }
            tableview?.setUp()
            tableview?.delegate?.updateTableView()
        }
        
    }
    
    
    // state 7: Notes
    //
    // state 8:
    //      Running & Active: Done
    //      Inactive: New
    //
    @IBAction func rightButtonPressed(_ sender: Any) {
        
        if state == 7 {
            
        } else {
            if tableview?.activeState == "Active" || tableview?.activeState == "Running" {
                ProjectController.sharedInstance.endTimer(project: (tableview?.project!)!)
                tableview?.delegate?.updateTableView()
                tableview?.running = false
                tableview?.isActive = false
                tableview?.activeState = "Inactive"
                tableview?.setUp()
            }
            
        }
    }
    
    

}
