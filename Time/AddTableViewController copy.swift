//
//  AddViewController.swift
//  Timer
//
//  Created by Soren Nelson on 4/15/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController, UITextFieldDelegate {
 
    
    @IBOutlet var categoryButton: UIButton!
    @IBOutlet var deadlineButton: UIButton!
    
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var deadlineDatePicker: UIDatePicker!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var deadlineLabel: UILabel!
    
    @IBOutlet var minorButton: UIButton!
    @IBOutlet var averageButton: UIButton!
    @IBOutlet var majorButton: UIButton!
    
    @IBOutlet var startNowButton: UIButton!
    
    @IBOutlet var categoryLeftContraint: NSLayoutConstraint!
    @IBOutlet var categoryCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet var deadlineLeftConstraint: NSLayoutConstraint!
    @IBOutlet var deadlineCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet var nameUnderline: UIView!
    @IBOutlet var nameUnderlineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var nameUnderlineTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryUnderline: UIView!
    @IBOutlet var categoryUnderlineTrailingConstraintToTextField: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineLeadingConstraintToTextField: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineLeadingConstraintToButton: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineTrailingConstraintToButton: NSLayoutConstraint!
    
    
    let regBlue = UIColor.init(red: 0.3, green: 0.57, blue: 0.89, alpha: 1.0)
    let regGray = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
    
    let projectController = ProjectController.sharedInstance
    var weight = 0.0
    
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(nameTextField) {
            categoryWasFirstResponder()
            setUpDatePickerLabel()
            
            nameUnderlineLeadingConstraint.constant = -10
            nameUnderlineTrailingConstraint.constant = 10
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.nameUnderline.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadlineDatePicker.setValue(regGray, forKeyPath: "textColor")
        deadlineDatePicker.minimumDate = Date.init()
        categoryTextField.isEnabled = false
        startNowButton.titleLabel?.textAlignment = .center
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.isEqual(nameTextField) {
            categoryButton.setTitleColor(regBlue, for: .normal)
            
            if categoryTextField.hasText == false {
                categoryCenterConstraint.isActive = false
                categoryLeftContraint.isActive = true
                categoryUnderlineLeadingConstraintToButton.isActive = false
                categoryUnderlineTrailingConstraintToButton.isActive = false
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.categoryUnderlineLeadingConstraintToTextField.isActive = true
                    self.categoryUnderlineTrailingConstraintToTextField.isActive = true
                    self.categoryLeftContraint.constant = 20
                    self.view.layoutIfNeeded()
                })
                categoryTextField.isEnabled = true
                categoryTextField.becomeFirstResponder()
            }
            
        } else if textField.isEqual(categoryTextField) {
            categoryWasFirstResponder()
            if deadlineLabel.text == "" {
                deadlineDatePicker.isHidden = false
                deadlineButton.setTitleColor(regBlue, for: .normal)
                self.deadlineCenterConstraint.isActive = false
                self.deadlineLeftConstraint.isActive = true
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.deadlineLeftConstraint.constant = 20
                    self.view.layoutIfNeeded()
                    self.deadlineDatePicker.isHidden = false
                })
            }
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
            if nameTextField.hasText == false {
                nameUnderlineLeadingConstraint.constant = 40
                nameUnderlineTrailingConstraint.constant = -40
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                    self.nameUnderline.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
            
        } else if categoryTextField.isFirstResponder {
            categoryWasFirstResponder()
        }
        setUpDatePickerLabel()
        
    }
    
    @IBAction func categoryButtonPressed(_ sender: Any) {
        
//        let timeInt = TimeInterval.init(0.3)
//        let animator = UIViewPropertyAnimator(duration: timeInt, dampingRatio: 0.6) {
//            self.categoryLeftContraint.constant = 20
//            self.categoryRightConstraint.constant = 20
//            self.view.layoutIfNeeded()
//        }
//        animator.startAnimation()
        categoryUnderline.isHidden = false
        self.view.layoutIfNeeded()
        
        categoryCenterConstraint.isActive = false
        categoryLeftContraint.isActive = true
        categoryUnderlineLeadingConstraintToButton.isActive = false
        categoryUnderlineTrailingConstraintToButton.isActive = false
            
        UIView.animate(withDuration: 0.3, animations: {
            self.categoryUnderlineLeadingConstraintToTextField.isActive = true
            self.categoryUnderlineTrailingConstraintToTextField.isActive = true
            self.categoryLeftContraint.constant = 20
            self.view.layoutIfNeeded()
        })
        
        categoryTextField.isEnabled = true
        
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
            if nameTextField.hasText == false {
                nameUnderlineLeadingConstraint.constant = 40
                nameUnderlineTrailingConstraint.constant = -40
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                    self.nameUnderline.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
        }
        categoryTextField.becomeFirstResponder()
        
        categoryButton.setTitleColor(regBlue, for: .normal)
        setUpDatePickerLabel()
        
        
    }

    @IBAction func deadlineButtonPressed(_ sender: Any) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
            if nameTextField.hasText == false {
                nameUnderlineLeadingConstraint.constant = 40
                nameUnderlineTrailingConstraint.constant = -40
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                    self.nameUnderline.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
        } else if categoryTextField.isFirstResponder {
            categoryWasFirstResponder()
        }
        
        if !(deadlineLabel.text?.isEmpty)! {
            deadlineLabel.text = ""
        } else {
            
            self.deadlineCenterConstraint.isActive = false
            self.deadlineLeftConstraint.isActive = true

            UIView.animate(withDuration: 0.3, animations: {
                self.deadlineLeftConstraint.constant = 20
                self.view.layoutIfNeeded()
                self.deadlineDatePicker.isHidden = false
            })
        }
        deadlineButton.setTitleColor(regBlue, for: .normal)

    }
    
// Weight Buttons
    
    @IBAction func minorButtonPressed(_ sender: Any) {
        weightButtonPressed(button: minorButton)
        self.weight = 0.6
    }
    
    @IBAction func averageButtonPressed(_ sender: Any) {
        weightButtonPressed(button: averageButton)
        self.weight = 0.5
    }
    
    @IBAction func majorButtonPressed(_ sender: Any) {
        weightButtonPressed(button: majorButton)
        self.weight = 0.4
    }
    
// Start buttons
    @IBAction func startNowButtonPressed(_ sender: Any) {
        setUpDatePickerLabel()
        
        //TODO: notify the user that a timer is already rolling
        //TODO: fix. Notify user no name?
        
        var deadline: Date?
        //TODO: fix. Want the text to turn red and notify
        if (deadlineLabel.text != "") || (deadlineButton.currentTitleColor == regBlue && deadlineDatePicker.date.timeIntervalSinceNow > 0) {
            deadline = deadlineDatePicker.date
        } else {
            deadline = nil
        }
        
        var categoryText: String
        if categoryTextField.text != nil && categoryTextField.text != "" {
            categoryText = categoryTextField.text!
        } else {
            categoryText = "Random"
        }
        
        if let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: categoryText) {
//            newProjectExistingCategory
            
            let project = projectController.newProject(name: nameTextField.text!, categoryName: categoryText, deadline: deadline, weight: self.weight)
            CategoryContoller.sharedInstance.newProjectInExistingCategory(category: category, project: project)
            
        } else {
            CategoryContoller.sharedInstance.newCategory(name: categoryText, projectName: nameTextField.text!, weight: self.weight, deadline: deadline)
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
// UI Helper Methods
    
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
                self.view.layoutIfNeeded()
            }
        }
        categoryButton.setTitleColor(regGray, for: .normal)
        categoryUnderline.isHidden = true
    }
    
    // Sets up the date picker when done picking time
    func setUpDatePickerLabel() {
        if !deadlineDatePicker.isHidden {
            deadlineDatePicker.isHidden = true
            
            let timeInterval = deadlineDatePicker.date.timeIntervalSinceNow
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.deadlineLabel.text = self.projectController.hourMinuteStringFromTimeInterval(interval: timeInterval, bigVersion: false, deadline: true)
            })
    
            //TODO: fix. Want the text to turn red and notify
            if (deadlineLabel.text == "0M") || (deadlineLabel.text!.contains("-")) {
                deadlineLabel.text?.removeAll()
            }
        }
        if deadlineLabel.text == "" {
            self.deadlineLeftConstraint.isActive = false
            self.deadlineCenterConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3) {

                self.view.layoutIfNeeded()
            }
        }
        deadlineButton.setTitleColor(regGray, for: .normal)
    }
    
    // Sets up weight buttons
    func weightButtonPressed(button: UIButton) {
        setUpDatePickerLabel()
        if categoryTextField.isFirstResponder {
            categoryWasFirstResponder()
        }
        switchOtherSelectedWeight()
        button.setTitleColor(regBlue, for: .normal)
    }
    
    // sets up the colors for the weight buttons
    func switchOtherSelectedWeight() {
        if minorButton.titleColor(for: .normal) == regBlue {
            minorButton.setTitleColor(regGray, for: .normal)
        } else if majorButton.titleColor(for: .normal) == regBlue {
            majorButton.setTitleColor(regGray, for: .normal)
        } else if averageButton.titleColor(for: .normal) == regBlue {
            averageButton.setTitleColor(regGray, for: .normal)
        }
    }
    
}













