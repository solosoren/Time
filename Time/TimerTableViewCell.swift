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

    @IBOutlet var timerName:        UILabel!
    @IBOutlet var time:             UILabel!
    @IBOutlet var categoryName:     UILabel!
    @IBOutlet var deadline:         UILabel!
    @IBOutlet var doneButton:       UIButton!
    @IBOutlet var endSessionButton: UIButton!
    @IBOutlet var breakButton:      UIButton!
    
    let projectController = ProjectController.sharedInstance
    
    var delegate:           TimerCellUpdater?
    
    
    func setUpCell() {
        let project =  projectController.currentProject
        // if their is a running project
        if let project = project {
            
            // if a timer was started while in app then the labels would be set to hidden so set them to not hidden
            if timerName.isHidden {
                timerName.isHidden =    false
                time.isHidden =         false
                categoryName.isHidden = false
                deadline.isHidden =     false
                
                doneButton.setTitle("Break", for: .normal)
                endSessionButton.setTitle("End Session", for: .normal)
                breakButton.setTitle("Done", for: .normal)
            }
            timerName.text =    project.name
            categoryName.text = project.categoryRef
            
            // Optional
            if let timerDeadline = project.activeTimer!.deadline {
                deadline.text = "Deadline: \(projectController.hourMinuteStringFromTimeInterval(interval: timerDeadline.timeIntervalSinceNow, bigVersion: true))"
            } else {
                deadline.text = "Deadline: -"
            }
            
            time.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceReferenceDate)!, bigVersion: true)
            
            // if their is no running project
        } else {
            timerName.isHidden =    true
            time.isHidden =          true
            categoryName.isHidden = true
            deadline.isHidden =     true
            
            doneButton.setTitle("Restart Project", for: .normal)
            endSessionButton.setTitle("Continue Timer", for: .normal)
            breakButton.setTitle("Start Timer", for: .normal)
        }
        
        doneButton.titleLabel?.textAlignment =       .center
        endSessionButton.titleLabel?.textAlignment = .center
        breakButton.titleLabel?.textAlignment =      .center
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if let currentProject = projectController.currentProject {
            let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: currentProject.categoryRef)
            projectController.endTimer(category: category!, project: currentProject)
            delegate?.updateTableView()
        }
    }

    @IBAction func endSessionButtonPressed(_ sender: Any) {
        
        if let _ = projectController.currentProject {
            SessionController.sharedInstance.endSession(projectIsDone: false)
            delegate?.updateTableView()
        }
    }

}
