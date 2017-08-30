//
//  DeadlineTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 8/29/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class DeadlineTableViewCell: UITableViewCell {

    @IBOutlet var cancelDeadlinePickerButton: UIButton!
    @IBOutlet var deadlineButton: UIButton!
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var deadlineLeftConstraint: NSLayoutConstraint!
    @IBOutlet var deadlineCenterConstraint: NSLayoutConstraint!
    
    var tableview: AddViewController?
    
    @IBAction func deadlineButtonPressed(_ sender: Any) {
        tableview?.nameCell?.nameTextFieldWasFirstResponder()
        tableview?.categoryCell?.categoryWasFirstResponder()
        tableview?.presentPickerView(deadline: true)
    }
    
    @IBAction func cancelDeadlinePickerButtonPressed(_ sender: Any) {
        deadlineLabel.text = ""
        cancelDeadlinePickerButton.isHidden = true
        ViewAnimations.sharedInstance.animate(oldConstraints: [deadlineLeftConstraint], for: [deadlineCenterConstraint], withDuration: 0.3, on: self)
    }

    func donePickingTime(_ text:String, deadline:Date?) {
        if let deadline = deadline {
            deadlineLabel.text = text
            ViewAnimations.sharedInstance.animate(oldConstraints: [deadlineCenterConstraint], for: [deadlineLeftConstraint], withDuration: 0.3, on:self)
            
            cancelDeadlinePickerButton.isHidden = false
            tableview?.deadline = deadline
        }
    }
}
