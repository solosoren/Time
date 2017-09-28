//
//  LargeTimerTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 9/3/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class LargeTimerTableViewCell: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var leftLabel: UILabel!
    
    var tableview: RunningProjectViewController?
    
    func setUpCell() {

        if ProjectController.sharedInstance.getRunningTimerTotalLength() < 3600 {
            leftLabel.text = "M"
            rightLabel.text = "S"
        }
        timeLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: ProjectController.sharedInstance.getRunningTimerTotalLength(), bigVersion: true, deadline: false, seconds: true)
    }
    
    @IBAction func breakButtonPressed(_ sender: Any) {
        SessionController.sharedInstance.delegate = tableview?.breakUpdater
        SessionController.sharedInstance.startBreak(previousProjectRef: tableview?.project?.firebaseRef?.key)
    }
    
    @IBAction func endSessionButtonPressed(_ sender: Any) {
        
        SessionController.sharedInstance.endSession(projectIsDone: false)
        tableview?.delegate?.updateTableView()
    }

}
