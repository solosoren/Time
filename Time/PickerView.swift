//
//  PickerView.swift
//  Time
//
//  Created by Soren Nelson on 8/29/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class PickerView: UIView {
    
    @IBOutlet var pickerLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    var darkView: UIView?
    var deadline:Bool = false
    var schedule:Bool = false
    var addTableView: AddViewController?
    
    let regBlue = UIColor.init(red: 0.3, green: 0.57, blue: 0.89, alpha: 1.0)
    let regGray = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0)
    
    func setUp(deadline: Bool) {
        if deadline {
            pickerLabel.text = "Deadline"
            datePicker.setValue(regGray, forKeyPath: "textColor")
            datePicker.minimumDate = Date.init()
            datePicker.datePickerMode = .dateAndTime
            datePicker.minuteInterval = 15
        } else if schedule {
            pickerLabel.text = "Schedule"
            datePicker.setValue(regGray, forKeyPath: "textColor")
            datePicker.minimumDate = Date.init()
            datePicker.datePickerMode = .dateAndTime
            datePicker.minuteInterval = 15
        } else {
            pickerLabel.text = "Session Length"
            datePicker.setValue(regGray, forKey: "textColor")
            datePicker.datePickerMode = .countDownTimer
            datePicker.minuteInterval = 5
            datePicker.countDownDuration = 1800
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        removeFromSuperview()
        darkView?.removeFromSuperview()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        var timeInterval = datePicker.date.timeIntervalSinceNow
        
        if deadline == false {
            timeInterval = datePicker.countDownDuration
        }
        
        let text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: timeInterval, bigVersion: false, deadline: true, seconds: false)
        
        if text == "0M" || text.contains("-") {
            removeFromSuperview()
            darkView?.removeFromSuperview()
            return
        }
        
        if deadline {
            addTableView?.deadlineCell?.donePickingTime(text, deadline:datePicker.date)
        } else if schedule {
            addTableView?.startCell?.schedule(text, for: datePicker.date)
        } else {
            addTableView?.sessionCell?.donePickingTime(text, sessionLength: datePicker.countDownDuration)
        }
        
        removeFromSuperview()
        darkView?.removeFromSuperview()
    }
    
    
    
    
    
}
