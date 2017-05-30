//
//  UserController.swift
//  Time
//
//  Created by Soren Nelson on 5/17/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class UserController {
    
    static let sharedInstance = UserController()
    var userRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
    
    
    func fetchInitialData() {
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let currentProject = value?["current project"] as? String
            if currentProject != nil {
                FIRDatabase.database().reference().child("projects").child(currentProject!).observeSingleEvent(of: .value, with: { (snapshot) in
                    var project = Project.init(snapshot: snapshot)
                    project.firebaseRef = snapshot.ref
                    ProjectController.sharedInstance.currentProject = project
                    
                })
            }
            
            let activeProjects = value?["active projects"] as? [String]
            if activeProjects != nil {
                for ref in activeProjects! {
                    FIRDatabase.database().reference().child("projects").child(ref).observeSingleEvent(of: .value, with: { (snapshot) in
                        ProjectController.sharedInstance.activeProjects.append(Project.init(snapshot: snapshot))
                        ProjectController.sharedInstance.activeProjectsRefs.append(ref)
                    })
                }
            }
            
            let categoryRefs = value?["categories"] as? NSDictionary
            if let categoryRefs = categoryRefs {
                for ref in categoryRefs.allKeys {
                    self.userRef.child("categories").child(ref as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        CategoryContoller.sharedInstance.categories.append(Category.init(snapshot: snapshot))
                    })
                    
                    
                }

            }
            
            
        })
    }
    
    
}
