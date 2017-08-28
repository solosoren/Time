//
//  AddViewController.swift
//  Timer
//
//  Created by Soren Nelson on 4/15/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class AddTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameUnderline: UIView!
    @IBOutlet var nameUnderlineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var nameUnderlineTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryButton: UIButton!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var categoryLeftContraint: NSLayoutConstraint!
    @IBOutlet var categoryCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryUnderline: UIView!
    @IBOutlet var categoryUnderlineTrailingConstraintToTextField: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineLeadingConstraintToTextField: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineLeadingConstraintToButton: NSLayoutConstraint!
    @IBOutlet var categoryUnderlineTrailingConstraintToButton: NSLayoutConstraint!
    
    @IBOutlet var deadlineButton: UIButton!
    @IBOutlet var deadlineDatePicker: UIDatePicker!
    @IBOutlet var deadlineLabel: UILabel!
    @IBOutlet var deadlineLeftConstraint: NSLayoutConstraint!
    @IBOutlet var deadlineCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet var cancelDeadlinePickerButton: UIButton!
    
    @IBOutlet var regularSessionButton: UIButton!
    
    @IBOutlet var cancelSessionLengthButton: UIButton!
    @IBOutlet var sessionButton: UIButton!
    @IBOutlet var sessionDatePicker: UIDatePicker!
    @IBOutlet var sessionLabel: UILabel!
    @IBOutlet var sessionButtonHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var sessionButtonLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet var averageButton: UIButton!
    @IBOutlet var minorButton: UIButton!
    @IBOutlet var minorButtonHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var minorButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet var majorButton: UIButton!
    @IBOutlet var majorButtonHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var majorButtonRightConstraint: NSLayoutConstraint!
    
    @IBOutlet var startNowButton: UIButton!
    
    let regBlue = UIColor.init(red: 0.3, green: 0.57, blue: 0.89, alpha: 1.0)
    let regGray = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
    
    let projectController = ProjectController.sharedInstance
    var weight = 0.0
    
    override func viewWillAppear(_ animated: Bool) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadlineDatePicker.setValue(regGray, forKeyPath: "textColor")
        deadlineDatePicker.minimumDate = Date.init()
        sessionDatePicker.setValue(regGray, forKey: "textColor")
        categoryTextField.isEnabled = false
        startNowButton.titleLabel?.textAlignment = .center
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(nameTextField) {
            categoryWasFirstResponder()
            setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: false)
            setUp(datePicker: sessionDatePicker, label: sessionLabel, cancel: false)
            
            nameUnderlineLeadingConstraint.constant = -10
            nameUnderlineTrailingConstraint.constant = 10
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.nameUnderline.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
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
        setUp(datePicker: sessionDatePicker, label: sessionLabel, cancel: false)
        setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: false)
        
    }
    
    @IBAction func categoryButtonPressed(_ sender: Any) {
        
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
        setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: false)
        setUp(datePicker: sessionDatePicker, label: sessionLabel, cancel: false)
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
        setUp(datePicker: sessionDatePicker, label: sessionLabel, cancel: false)
        
        if !(deadlineLabel.text?.isEmpty)! {
            deadlineLabel.text = ""
        }
        
        if deadlineDatePicker.isHidden == true {
            ViewAnimations.sharedInstance.animate(oldConstraints: [deadlineCenterConstraint], for: [deadlineLeftConstraint], withDuration: 0.3, on: self.view)
            
            self.deadlineDatePicker.isHidden = false
            
            deadlineButton.setTitleColor(regBlue, for: .normal)
            cancelDeadlinePickerButton.isHidden = false
        } else {
            setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: false)
        }
    }
    
    @IBAction func cancelDeadlinePickerButtonPressed(_ sender: Any) {
        deadlineLabel.text = ""
        cancelDeadlinePickerButton.isHidden = true
        setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: true)
    }
    
    
    @IBAction func regularButtonPressed(_ sender: Any) {
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
        setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: false)
        
        regularSessionButton.setTitleColor(regBlue, for: .normal)
    }
    
    @IBAction func sessionButtonPressed(_ sender: Any) {
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
        setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: false)
        
        if !(sessionLabel.text?.isEmpty)! {
            sessionLabel.text = ""
        }
        if sessionDatePicker.isHidden == true {
            ViewAnimations.sharedInstance.animate(oldConstraints: [sessionButtonHorizontalConstraint], for: [sessionButtonLeftConstraint], withDuration: 0.3, on: self.view)
            
            if (sessionDatePicker.countDownDuration > 5400) {
                self.sessionDatePicker.countDownDuration = 1800; //Defaults to 30 minutes
            }
            
            self.sessionDatePicker.isHidden = false
            sessionButton.setTitleColor(regBlue, for: .normal)
            
            regularSessionButton.isHidden = true
            regularSessionButton.setTitleColor(regGray, for: .normal)
            cancelSessionLengthButton.isHidden = false
        } else {
            setUp(datePicker: sessionDatePicker, label: sessionLabel, cancel: false)
        }
        
    }
    
    @IBAction func cancelSessionLengthButtonPressed(_ sender: Any) {
        sessionLabel.text = ""
        regularSessionButton.isHidden = false
        regularSessionButton.setTitleColor(regBlue, for: .normal)
        cancelSessionLengthButton.isHidden = true
        setUp(datePicker: sessionDatePicker, label: sessionLabel, cancel: true)
    }
    
    
    
// Weight Buttons
    
    @IBAction func minorButtonPressed(_ sender: Any) {
        weightButtonPressed(button: minorButton)
        self.weight = 0.6
    }
    
    @IBAction func averageButtonPressed(_ sender: Any) {
        if averageButton.titleLabel?.text == "Priority" {
            averageButton.setTitle("Average", for: .normal)
            minorButton.isHidden = false
            majorButton.isHidden = false
            ViewAnimations.sharedInstance.animate(oldConstraints: [minorButtonHorizontalConstraint, majorButtonHorizontalConstraint], for: [minorButtonLeftConstraint, majorButtonRightConstraint], withDuration: 0.3, on: self.view)
            
        } else {
            weightButtonPressed(button: averageButton)
            self.weight = 0.5
        }
    }
    
    @IBAction func majorButtonPressed(_ sender: Any) {
        weightButtonPressed(button: majorButton)
        self.weight = 0.4
    }
    
// Start buttons
    @IBAction func startNowButtonPressed(_ sender: Any) {
        setUp(datePicker: sessionDatePicker, label: sessionLabel, cancel: false)
        setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: false)
        
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
        
        let presetSessionLength: TimeInterval?
        if (sessionLabel.text != "") || (sessionButton.currentTitleColor == regBlue && sessionDatePicker.countDownDuration > 0) {
            presetSessionLength = sessionDatePicker.countDownDuration
        } else {
            presetSessionLength = nil
        }
        
        if let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: categoryText) {
//            newProjectExistingCategory
            
            let project = projectController.newProject(name: nameTextField.text!, categoryName: categoryText, deadline: deadline, weight: self.weight, presetSessionLength: presetSessionLength)
            CategoryContoller.sharedInstance.newProjectInExistingCategory(category: category, project: project)
            
        } else {
            CategoryContoller.sharedInstance.newCategory(name: categoryText, projectName: nameTextField.text!, weight: self.weight, deadline: deadline, presetSessionLength: presetSessionLength)
            
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
    func setUp(datePicker: UIDatePicker, label: UILabel, cancel: Bool) {
        
        if !datePicker.isHidden {
            datePicker.isHidden = true
            
            if cancel == false {
                var timeInterval = datePicker.date.timeIntervalSinceNow
                
                if datePicker == sessionDatePicker {
                    timeInterval = datePicker.countDownDuration
                }
                
                label.text = self.projectController.hourMinuteStringFromTimeInterval(interval: timeInterval, bigVersion: false, deadline: true, seconds: false)
                
                //TODO: fix. Want the text to turn red and notify
                if (label.text == "0M") || (label.text!.contains("-")) {
                    label.text?.removeAll()
                    if datePicker == deadlineDatePicker {
                        cancelDeadlinePickerButton.isHidden = true
                    } else {
                        cancelSessionLengthButton.isHidden = true
                    }
                }
            }
        }
        
        if datePicker == deadlineDatePicker {
            deadlineButton.setTitleColor(regGray, for: .normal)
            if label.text == "" {
                ViewAnimations.sharedInstance.animate(oldConstraints: [deadlineLeftConstraint], for: [deadlineCenterConstraint], withDuration: 0.3, on: self.view)
            }
        } else if datePicker == sessionDatePicker {
            sessionButton.setTitleColor(regGray, for: .normal)
            if label.text == "" {
                ViewAnimations.sharedInstance.animate(oldConstraints: [sessionButtonLeftConstraint], for: [sessionButtonHorizontalConstraint], withDuration: 0.3, on: self.view)
            }
        }
    }
    
    // Sets up weight buttons
    func weightButtonPressed(button: UIButton) {
        setUp(datePicker: sessionDatePicker, label: sessionLabel, cancel: false)
        setUp(datePicker: deadlineDatePicker, label: deadlineLabel, cancel: false)
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













