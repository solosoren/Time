//
//  TimerNameTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 8/29/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class TimerNameTableViewCell: UITableViewCell {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameUnderline: UIView!
    @IBOutlet var nameUnderlineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var nameUnderlineTrailingConstraint: NSLayoutConstraint!

    var tableview: AddViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func nameTextFieldWasFirstResponder() {
        nameTextField.resignFirstResponder()
        
        if nameTextField.hasText == false {
            nameUnderlineLeadingConstraint.constant = 40
            nameUnderlineTrailingConstraint.constant = -40
            UIView.animate(withDuration: 0.3, animations: {
                self.tableview?.view.layoutIfNeeded()
                self.nameUnderline.isHidden = true
                self.tableview?.view.layoutIfNeeded()
            })
        }
        
    }

}
