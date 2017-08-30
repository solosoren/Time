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
            categoryText = "Random"
        }
        
        var weight = tableview?.weight
        if weight == nil {
            weight = 0.5
        }
        
        if let category = CategoryContoller.sharedInstance.getCategoryFromRef(ref: categoryText) {
            //            newProjectExistingCategory
            
            let project = ProjectController.sharedInstance.newProject(name: tableview?.nameCell?.nameTextField.text!, categoryName: categoryText, deadline: tableview?.deadline, weight: weight!, presetSessionLength: tableview?.sessionLength)
            CategoryContoller.sharedInstance.newProjectInExistingCategory(category: category, project: project)
            
        } else {
            CategoryContoller.sharedInstance.newCategory(name: categoryText, projectName: tableview?.nameCell?.nameTextField.text!, weight:weight!, deadline: tableview?.deadline, presetSessionLength: tableview?.sessionLength)
            
        }
        
        tableview?.dismiss(animated: true, completion: nil)
    }

}
