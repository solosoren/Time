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
    var tableview: LargeTimerViewController?

    func setUpCell() {
        
        if tableview?.activeState == "Inactive" {
            timeLabel.text = "-"
        } else {
            timeLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: (tableview?.project?.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false, seconds: true)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
