//
//  CategoryController.swift
//  Time
//
//  Created by Soren Nelson on 5/18/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class CategoryContoller {
    
    static let sharedInstance = CategoryContoller()
    
    var categories =  [Category]()
    
    func newCategory(name: String, projectName: String, weight: Double, deadline: Date?, completion:@escaping (Bool) -> Void) {
        let category = Category.init(name: name, projectName: projectName, weight: weight, deadline: deadline)
        
        categories.append(category)
        
        UserController.sharedInstance.userRef.setValue(["Categories": name])
        
        ProjectController.sharedInstance.newProject(name: projectName, categoryName: name, deadline: deadline, weight: weight) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // Check to see if a category already exists
    func checkForCategory(categoryName: String) -> Bool {
        
        for category in categories {
            if category.name == categoryName {
                return true
            }
        }
        
        return false
        
    }
    
}
