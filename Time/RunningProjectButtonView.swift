//
//  RunningProjectButtonView.swift
//  Time
//
//  Created by Soren Nelson on 9/27/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class RunningProjectButtonView: UIView {

    var tableview: RunningProjectViewController?
    
    override func draw(_ rect: CGRect) {
       
    }

    // Active: Delete Timer
    @IBAction func leftButtonPressed(_ sender: Any) {
        
        
        // FIXME:Leave view

    }
    
    // Edit
    @IBAction func centerButtonPressed(_ sender: Any) {
        
        
        
    }
    
    
    // Active: Finish
    @IBAction func rightButtonPressed(_ sender: Any) {
        
        ProjectController.sharedInstance.endTimer(project: ProjectController.sharedInstance.currentProject!)
        
        tableview?.delegate?.updateTableView()
        tableview?.dismiss(animated: true, completion: nil)
    }

}
