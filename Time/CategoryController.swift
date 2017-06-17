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
    
    
    /// Creates a new category. Only is called when you are creating a project with a new category.
    ///
    /// - Parameters:
    ///   - name: the name of the category.
    ///   - projectName: the anem of the Project being created
    ///   - weight: the weight of the Project, as a double
    ///   - deadline: the deadline of the project
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
    
    /// Checks to see if a category already exists.
    ///
    /// - Parameter categoryName: the category to check
    /// - Returns: whether or not the category exists.
    func checkForCategory(categoryName: String) -> Bool {
        
        for category in categories {
            if category.name == categoryName {
                return true
            }
        }
        
        return false
    }
    
    
// FIXME: not working
    
    /// Gets the category from the given reference
    ///
    /// - Parameter ref: the categories reference
    /// - Returns: an optional category
    func getCategoryFromRef(ref: String) -> Category? {
        for category in categories {
            if category.name == ref {
                return category
            }
        }
        return nil
    }
    
    func fetchProjectsFromCategoryRef(category: Category, _completion:@escaping(_ category:Category?, _ success:Bool) -> Void) {
        
        guard let firebaseRef = category.firebaseRef else { return }
        var cat = category
        
        ref.child(firebaseRef.key).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            guard let projects = value?["Projects"] as? [String] else { return }

            var count = 0
            for reference in projects {
                count += 1
                FIRDatabase.database().reference().child("projects").child(reference).observeSingleEvent(of: .value, with: { (snapshot) in
                    var project = Project.init(snapshot: snapshot)
                    project.firebaseRef = snapshot.ref
                    cat.projects.append(project)
                    
                    if count == projects.count {
                        _completion(category, true)
                    }
                })
            }
            
        })
    }
    
}













