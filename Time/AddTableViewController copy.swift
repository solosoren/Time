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
    
    let regBlue = UIColor.init(red: 0.3, green: 0.57, blue: 0.89, alpha: 1.0)
    let regGray = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
    
    let projectController = ProjectController.sharedInstance
    var weight = 0.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadlineDatePicker.setValue(regGray, forKeyPath: "textColor")
        deadlineDatePicker.minimumDate = Date.init()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.isEqual(nameTextField) {
            categoryTextField.becomeFirstResponder()
            categoryButton.setTitleColor(regBlue, for: .normal)
        } else  if textField.isEqual(categoryTextField) {
            categoryWasFirstResponder()
            if deadlineLabel.text == "" {
                deadlineDatePicker.isHidden = false
                deadlineButton.setTitleColor(regBlue, for: .normal)
            }
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        } else if categoryTextField.isFirstResponder {
            categoryWasFirstResponder()
        }
        setUpDatePickerLabel()
        
    }
    
    @IBAction func categoryButtonPressed(_ sender: Any) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }
        categoryTextField.becomeFirstResponder()
        
        categoryButton.setTitleColor(regBlue, for: .normal)
        setUpDatePickerLabel()
        
        
    }

    @IBAction func deadlineButtonPressed(_ sender: Any) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        } else if categoryTextField.isFirstResponder {
            categoryWasFirstResponder()
        }
        
        if !(deadlineLabel.text?.isEmpty)! {
            deadlineLabel.text = ""
        }
        deadlineDatePicker.isHidden = false
        
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
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
// Start buttons
    @IBAction func startNowButtonPressed(_ sender: Any) {
        setUpDatePickerLabel()
        
        if !nameTextField.hasText || !categoryTextField.hasText {
            //TODO: fix. Want the text to turn red and notify
            return
        }
        
        var deadline: Date?
        //TODO: fix. Want the text to turn red and notify
        if (deadlineLabel.text != "") || (deadlineButton.currentTitleColor == regBlue && deadlineDatePicker.date.timeIntervalSinceNow > 0) {
            deadline = deadlineDatePicker.date
        } else {
            deadline = nil
        }
        
        if CategoryContoller.sharedInstance.checkForCategory(categoryName: categoryTextField.text!) {
            let _ = projectController.newProject(name: nameTextField.text!, categoryName: categoryTextField.text!, deadline: deadline, weight: self.weight)
        } else {
            CategoryContoller.sharedInstance.newCategory(name: categoryTextField.text!, projectName: nameTextField.text!, weight: self.weight, deadline: deadline, completion: { (success) in
                if !success {
                    // Throw an error
                }
            })
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
// UI Helper Methods
    
    // Set up category when done
    // Call when category is no longer wanted to be first responder
    func categoryWasFirstResponder() {
        categoryTextField.resignFirstResponder()
        categoryButton.setTitleColor(regGray, for: .normal)
    }
    
    // Sets up the date picker when done picking time
    func setUpDatePickerLabel() {
        if !deadlineDatePicker.isHidden {
            deadlineDatePicker.isHidden = true
            
            let timeInterval = deadlineDatePicker.date.timeIntervalSinceNow
            deadlineLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: timeInterval, bigVersion: false)
            
            //TODO: fix. Want the text to turn red and notify
            if (deadlineLabel.text == "0M") || (deadlineLabel.text!.contains("-")) {
                deadlineLabel.text?.removeAll()
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













