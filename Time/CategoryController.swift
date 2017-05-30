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
    var ref = UserController.sharedInstance.userRef.child("categories")
    
    func newCategory(name: String, projectName: String, weight: Double, deadline: Date?) {
        var category = Category.init(name: name, projectName: projectName, weight: weight, deadline: deadline)
        let project = ProjectController.sharedInstance.newProject(name: projectName, categoryName: name, deadline: deadline, weight: weight)
        
        category.projects.append(project)
        category.projectRefs.append(project.firebaseRef!)
        
        categories.append(category)
        let uid = FIRAuth.auth()?.currentUser?.uid
        category.firebaseRef = ref.childByAutoId()
        
        let updateKeys = ["/users/\(uid ?? "UID")/categories/\(category.firebaseRef!.key)": category.toAnyObject() as! [String: Any]]
        FIRDatabase.database().reference().updateChildValues(updateKeys)
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
    
    //TODO: Fix this?
    func getCategoryFromRef(ref: String) -> Category? {
        for category in categories {
            if category.name == ref {
                return category
            }
        }
        return nil
    }
    
}
