//
//  RunningProjectButtonView.swift
//  Time
//
//  Created by Soren Nelson on 9/27/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class RunningProjectButtonView: UIView {

    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var centerButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    var tableview: RunningProjectViewController?
    
    override func draw(_ rect: CGRect) {
       
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
        
        // FIXME:Leave view

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
    
    
    // Active: Done
    // Inactive: Start
    @IBAction func rightButtonPressed(_ sender: Any) {
        
        ProjectController.sharedInstance.endTimer(project: (tableview?.project!)!)
        tableview?.isActive = false
        
        tableview?.delegate?.updateTableView()
        
    }

}
