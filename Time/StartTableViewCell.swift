//
//  StartTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 8/29/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class StartTableViewCell: UITableViewCell {
    
    @IBOutlet var startNowButton: UIButton!
    @IBOutlet var scheduleButton: UIButton!
    
    var tableview: AddViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startNowButton.titleLabel?.textAlignment = .center
    }
    
    @IBAction func startNowButtonPressed(_ sender: Any) {
        //TODO: notify the user that a timer is already rolling
        
        var categoryText: String
        if tableview?.categoryCell?.categoryTextField.text != nil && tableview?.categoryCell?.categoryTextField.text != "" {
            categoryText = (tableview?.categoryCell?.categoryTextField.text!)!
        } else {
            categoryText = "Other"
        }
        
        var weight = tableview?.weight
        if weight == nil {
            weight = 0.5
        }
        
        if let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: categoryText) {
            
            let project = ProjectController.sharedInstance.newProject(name: tableview?.nameCell?.nameTextField.text!, categoryName: categoryText, deadline: tableview?.deadline, weight: weight!, presetSessionLength: tableview?.sessionLength, scheduledDate: nil)
            CategoryContoller.sharedInstance.newProjectInExistingCategory(category: category, project: project)
            
        } else {
            CategoryContoller.sharedInstance.newCategory(name: categoryText, projectName: tableview?.nameCell?.nameTextField.text!, weight:weight!, deadline: tableview?.deadline, presetSessionLength: tableview?.sessionLength, scheduledDate: nil)
            
        }
        
        tableview?.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func scheduleButtonPressed(_ sender: Any) {
        
        // Firebase: add project to active projects and scheduled
        // When loading up, pull up scheduled active projects first
        
        tableview?.nameCell?.nameTextFieldWasFirstResponder()
        tableview?.categoryCell?.categoryWasFirstResponder()
        tableview?.presentPickerView(deadline: false, schedule: true)
        

        
    }
    
    func schedule(_ text: String, for time: Date) {
        var categoryText: String
        if tableview?.categoryCell?.categoryTextField.text != nil && tableview?.categoryCell?.categoryTextField.text != "" {
            categoryText = (tableview?.categoryCell?.categoryTextField.text!)!
        } else {
            categoryText = "Other"
        }
        
        var weight = tableview?.weight
        if weight == nil {
            weight = 0.5
        }
        
        if let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: categoryText) {
            
            let project = ProjectController.sharedInstance.newProject(name: tableview?.nameCell?.nameTextField.text!, categoryName: categoryText, deadline: tableview?.deadline, weight: weight!, presetSessionLength: tableview?.sessionLength, scheduledDate: time)
            CategoryContoller.sharedInstance.newProjectInExistingCategory(category: category, project: project)
            
        } else {
            CategoryContoller.sharedInstance.newCategory(name: categoryText, projectName: tableview?.nameCell?.nameTextField.text!, weight:weight!, deadline: tableview?.deadline, presetSessionLength: tableview?.sessionLength, scheduledDate: time)
            
        }
        
        tableview?.dismiss(animated: true, completion: nil)
    }
    
    

}
