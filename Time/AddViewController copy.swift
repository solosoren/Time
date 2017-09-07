//
//  AddViewController.swift
//  Timer
//
//  Created by Soren Nelson on 4/15/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var deadline: Date?
    var sessionLength: TimeInterval?
    
    @IBOutlet var pickerView: PickerView!
    var nameCell:TimerNameTableViewCell?
    var categoryCell: CategoryNameTableViewCell?
    var deadlineCell: DeadlineTableViewCell?
    var sessionCell: SessionLengthTableViewCell?
    var priorityCell: PriorityTableViewCell?
    var startCell: StartTableViewCell?
    
    let regBlue = UIColor.init(red: 0.3, green: 0.57, blue: 0.89, alpha: 1.0)
    let regGray = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
    
    let projectController = ProjectController.sharedInstance
    var weight = 0.0
    
    override func viewWillAppear(_ animated: Bool) {}
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(nameCell?.nameTextField) {
            categoryCell?.categoryWasFirstResponder()
            
            nameCell?.nameUnderlineLeadingConstraint.constant = -10
            nameCell?.nameUnderlineTrailingConstraint.constant = 10
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.nameCell?.nameUnderline.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(nameCell?.nameTextField) {
            categoryCell?.categoryButton.setTitleColor(regBlue, for: .normal)
            
            if categoryCell?.categoryTextField.hasText == false {
                categoryCell?.categoryCenterConstraint.isActive = false
                categoryCell?.categoryLeftContraint.isActive = true
                categoryCell?.categoryUnderlineLeadingConstraintToButton.isActive = false
                categoryCell?.categoryUnderlineTrailingConstraintToButton.isActive = false
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.categoryCell?.categoryUnderlineLeadingConstraintToTextField.isActive = true
                    self.categoryCell?.categoryUnderlineTrailingConstraintToTextField.isActive = true
                    self.categoryCell?.categoryLeftContraint.constant = 20
                    self.view.layoutIfNeeded()
                })
                categoryCell?.categoryTextField.isEnabled = true
                categoryCell?.categoryTextField.becomeFirstResponder()
            }
            
        } else if textField.isEqual(categoryCell?.categoryTextField) {
            categoryCell?.categoryWasFirstResponder()
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            nameCell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as? TimerNameTableViewCell
            nameCell?.tableview = self
            return nameCell!
        } else if indexPath.row == 1 {
            categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryNameTableViewCell
            categoryCell?.tableview = self
            return categoryCell!
        } else if indexPath.row == 2 {
            deadlineCell = tableView.dequeueReusableCell(withIdentifier: "DeadlineCell", for: indexPath) as? DeadlineTableViewCell
            deadlineCell?.tableview = self
            return deadlineCell!
        } else if indexPath.row == 3 {
            sessionCell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) as? SessionLengthTableViewCell
            sessionCell?.tableview = self
            return sessionCell!
        } else if indexPath.row == 4 {
            priorityCell = tableView.dequeueReusableCell(withIdentifier: "PriorityCell", for: indexPath) as? PriorityTableViewCell
            priorityCell?.tableview = self
            return priorityCell!
        }
        
        startCell = tableView.dequeueReusableCell(withIdentifier: "StartCell", for: indexPath) as? StartTableViewCell
        startCell?.tableview = self
        return startCell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 135
        } else {
            return (view.frame.height - 215)/5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameCell?.nameTextFieldWasFirstResponder()
        categoryCell?.categoryWasFirstResponder()
    }
    

    
 
    
//MARK: Date Picker
    func presentPickerView(deadline: Bool, schedule: Bool) {
        let darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        darkView.backgroundColor = UIColor.black
        darkView.alpha = 0.5
        view.addSubview(darkView)
        
        pickerView.darkView = darkView
        pickerView.deadline = deadline
        pickerView.schedule = schedule
        
        pickerView.addTableView = self
        pickerView.center = CGPoint.init(x: view.center.x, y: view.center.y - 50)
        pickerView.setUp(deadline: deadline)
        view.addSubview(pickerView)
    }
    
}













