//
//  PriorityTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 8/29/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class PriorityTableViewCell: UITableViewCell {
    
    @IBOutlet var averageButton: UIButton!
    @IBOutlet var minorButton: UIButton!
    @IBOutlet var minorButtonHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var minorButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet var majorButton: UIButton!
    @IBOutlet var majorButtonHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var majorButtonRightConstraint: NSLayoutConstraint!
    
    var tableview: AddViewController?

    @IBAction func minorButtonPressed(_ sender: Any) {
        weightButtonPressed(button: minorButton)
        tableview?.weight = 0.6
    }
    
    @IBAction func averageButtonPressed(_ sender: Any) {
        if averageButton.titleLabel?.text == "Priority" {
            averageButton.setTitle("Average", for: .normal)
            minorButton.isHidden = false
            majorButton.isHidden = false
            ViewAnimations.sharedInstance.animate(oldConstraints: [minorButtonHorizontalConstraint, majorButtonHorizontalConstraint], for: [minorButtonLeftConstraint, majorButtonRightConstraint], withDuration: 0.3, on: self)
            
        } else {
            weightButtonPressed(button: averageButton)
            tableview?.weight = 0.5
        }
    }
    
    @IBAction func majorButtonPressed(_ sender: Any) {
        weightButtonPressed(button: majorButton)
        tableview?.weight = 0.4
    }
    
    // Sets up weight buttons
    func weightButtonPressed(button: UIButton) {
        tableview?.nameCell?.nameTextFieldWasFirstResponder()
        tableview?.categoryCell?.categoryWasFirstResponder()
        
        switchOtherSelectedWeight()
        button.setTitleColor(tableview?.regBlue, for: .normal)
    }
    
    // sets up the colors for the weight buttons
    func switchOtherSelectedWeight() {
        if minorButton.titleColor(for: .normal) == tableview?.regBlue {
            minorButton.setTitleColor(tableview?.regGray, for: .normal)
        } else if majorButton.titleColor(for: .normal) == tableview?.regBlue {
            majorButton.setTitleColor(tableview?.regGray, for: .normal)
        } else if averageButton.titleColor(for: .normal) == tableview?.regBlue {
            averageButton.setTitleColor(tableview?.regGray, for: .normal)
        }
    }

}
