//
//  CategoryNameTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 8/29/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class CategoryNameTableViewCell: UITableViewCell {
    
    @IBOutlet var categoryButton: UIButton!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var categoryLeftContraint: NSLayoutConstraint!
    @IBOutlet var categoryCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryUnderline: UIView!
    @IBOutlet var categoryUnderlineTrailingConstraintToTextField: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineLeadingConstraintToTextField: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineLeadingConstraintToButton: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineTrailingConstraintToButton: NSLayoutConstraint!
    
    var tableview: AddViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryTextField.isEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func categoryButtonPressed(_ sender: Any) {
        
        categoryUnderline.isHidden = false
        tableview?.view.layoutIfNeeded()
        
        categoryCenterConstraint.isActive = false
        categoryLeftContraint.isActive = true
        categoryUnderlineLeadingConstraintToButton.isActive = false
        categoryUnderlineTrailingConstraintToButton.isActive = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.categoryUnderlineLeadingConstraintToTextField.isActive = true
            self.categoryUnderlineTrailingConstraintToTextField.isActive = true
            self.categoryLeftContraint.constant = 20
            self.tableview?.view.layoutIfNeeded()
        })
        
        categoryTextField.isEnabled = true
        
        tableview?.nameCell?.nameTextFieldWasFirstResponder()
        
        categoryTextField.becomeFirstResponder()
        categoryButton.setTitleColor(tableview?.regBlue, for: .normal)
    }
    
    // Set up category when done
    // Call when category is no longer wanted to be first responder
    func categoryWasFirstResponder() {
        categoryTextField.resignFirstResponder()
        categoryTextField.isEnabled = false
        
        if !categoryTextField.hasText {
            self.categoryLeftContraint.isActive = false
            self.categoryCenterConstraint.isActive = true
            self.categoryUnderlineLeadingConstraintToTextField.isActive = false
            self.categoryUnderlineTrailingConstraintToTextField.isActive = false
            
            UIView.animate(withDuration: 0.3) {
                self.categoryUnderlineLeadingConstraintToButton.isActive = true
                self.categoryUnderlineTrailingConstraintToButton.isActive = true
                self.tableview?.view.layoutIfNeeded()
            }
        }
        categoryButton.setTitleColor(tableview?.regGray, for: .normal)
        categoryUnderline.isHidden = true
    }

}
