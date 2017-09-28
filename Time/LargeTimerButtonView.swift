//
//  LargeTimerButtonView.swift
//  Time
//
//  Created by Soren Nelson on 9/27/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class LargeTimerButtonView: UIView {
    
    @IBOutlet var leftButtonHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var leftCenterLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var centerButton: UIButton!
    @IBOutlet var rightCenterButton: UIButton!
    @IBOutlet var rightCenterLabel: UILabel!
    @IBOutlet var rightButton: UIButton!
    var tableview: LargeTimerViewController?
    
    override func draw(_ rect: CGRect) {
        if tableview?.isActive == false {
            rightCenterButton.isHidden = true
            rightCenterLabel.isHidden = true
            rightButton.setImage(#imageLiteral(resourceName: "Blue Play"), for: .normal)
            rightLabel.text = "New Timer"
            leftButtonHorizontalConstraint.constant = 0
        } else {
            leftLabel.text = "Delete Timer"
            rightCenterButton.isHidden = false
            rightCenterLabel.isHidden = false
            leftButtonHorizontalConstraint.constant = -46
        }
    }
    
   
    // state 8:
    //      Running: break
    //      Active & Inactive: Delete Project
    
    // Active: Delete Timer
    // Inactive Delete Project
    @IBAction func leftButtonPressed(_ sender: Any) {
        
      
//            if tableview?.activeState == "Running" {
//                SessionController.sharedInstance.delegate = tableview?.breakUpdater
//                SessionController.sharedInstance.startBreak(previousProjectRef: tableview?.project?.firebaseRef?.key)
//                tableview?.running = false
//                tableview?.isActive = false
//                tableview?.activeState = "Inactive"
//
//            }
        
        if tableview?.isActive == false {
            guard let project = tableview?.project else { return }
            ProjectController.sharedInstance.deleteProject(project: project, active: (tableview?.isActive)!, running: false)
            // FIXMe:Leave view
        }
        
        tableview?.delegate?.updateTableView()
    
        
    }
    
    

    
    //      Running: End Session
    //      Active: Start Session
    //      Inactive: Start
    
    // Edit
    @IBAction func centerButtonPressed(_ sender: Any) {
        

//            if tableview?.activeState == "Running" {
//                SessionController.sharedInstance.endSession(projectIsDone: false)
//                tableview?.running = false
//                tableview?.isActive = true
//                tableview?.activeState = "Active"
//                
//            }
        
    }
    
    
    @IBAction func rightCenterButtonPressed(_ sender: Any) {
        // FIXME: Switch Views to playing current project
        if tableview?.isActive == true {
            guard let project = tableview?.project else { return }
            
            var scheduled = false
            for ref in ProjectController.sharedInstance.scheduledProjectRefs {
                if project.firebaseRef?.key == ref {
                    scheduled = true
                }
            }
            SessionController.sharedInstance.startSessionNow(p: project, customizedSessionLength: project.presetSessionLength, scheduled: scheduled)
            
            if SessionController.sharedInstance.onBreak {
                SessionController.sharedInstance.endBreak()
            }
        }
            
        tableview?.delegate?.updateTableView()
            
    }
    

    // Active: Done
    // Inactive: Start
    @IBAction func rightButtonPressed(_ sender: Any) {
        
        
        if tableview?.isActive == true {
            ProjectController.sharedInstance.endTimer(project: (tableview?.project!)!)
            tableview?.isActive = false

        } else {
            guard let project = tableview?.project else { return }
            let _ = ProjectController.sharedInstance.newTimer(project: project, weight: project.weight, deadline: nil, scheduledDate: nil,  newProject: false)
            tableview?.project = ProjectController.sharedInstance.currentProject
            if SessionController.sharedInstance.onBreak {
                SessionController.sharedInstance.endBreak()
            }
        }
        
        tableview?.delegate?.updateTableView()
        
    }
    

}
