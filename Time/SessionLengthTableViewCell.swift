//
//  SessionLengthTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 8/29/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class SessionLengthTableViewCell: UITableViewCell {

    @IBOutlet var regularSessionButton: UIButton!
    
    @IBOutlet var cancelSessionLengthButton: UIButton!
    @IBOutlet var sessionStyleButton: UIButton!
    @IBOutlet var sessionTimeLabel: UILabel!
    @IBOutlet var sessionButtonHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var sessionButtonLeftConstraint: NSLayoutConstraint!
    
    var tableview: AddViewController?
    
    
    @IBAction func regularButtonPressed(_ sender: Any) {
        tableview?.nameCell?.nameTextFieldWasFirstResponder()
        tableview?.categoryCell?.categoryWasFirstResponder()
        regularSessionButton.setTitleColor(tableview?.regBlue, for: .normal)
    }
    
    @IBAction func sessionButtonPressed(_ sender: Any) {
        tableview?.nameCell?.nameTextFieldWasFirstResponder()
        tableview?.categoryCell?.categoryWasFirstResponder()
        tableview?.presentPickerView(deadline: false, schedule: false)
    }
    
    @IBAction func cancelSessionLengthButtonPressed(_ sender: Any) {
        sessionTimeLabel.text = ""
        regularSessionButton.isHidden = false
        regularSessionButton.setTitleColor(tableview?.regBlue, for: .normal)
        cancelSessionLengthButton.isHidden = true
        ViewAnimations.sharedInstance.animate(oldConstraints: [sessionButtonLeftConstraint], for: [sessionButtonHorizontalConstraint], withDuration: 0.3, on: self)
    }
    
    func donePickingTime(_ text:String, sessionLength:TimeInterval?) {
        
        sessionTimeLabel.text = text
        ViewAnimations.sharedInstance.animate(oldConstraints: [sessionButtonHorizontalConstraint], for: [sessionButtonLeftConstraint], withDuration: 0.3, on: self)
        regularSessionButton.isHidden = true
        regularSessionButton.setTitleColor(tableview?.regGray, for: .normal)
        cancelSessionLengthButton.isHidden = false
        tableview?.sessionLength = sessionLength
        
    }

}
