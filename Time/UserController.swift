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

protocol InitialDataUpdater {
    func updateTableView()
    func resumeBreak()
}

class UserController {
    
    static let sharedInstance =  UserController()
    var userRef: FIRDatabaseReference?
    var delegate:                InitialDataUpdater?
    var loadingInt =             0
    var fetched = false
    
    /// Fetches the current project, the active projects, and the categories. The rest of the projects can be loaded later from the reference on the category object.
    ///
    /// -Return: Success bool
    func fetchInitialData() -> Bool {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return false }
        print("fetched")
        self.fetched = true
        userRef = FIRDatabase.database().reference().child("users").child(uid)
        
        userRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let currentProject = value?["current project"] as? String
            if currentProject != nil && currentProject != "" {
                FIRDatabase.database().reference().child("projects").child(currentProject!).observeSingleEvent(of: .value, with: { (snapshot) in
                    var project = Project.init(snapshot: snapshot)
                    project.firebaseRef = snapshot.ref
                    ProjectController.sharedInstance.currentProject = project
                    self.finishedLoading()
                })
            } else {
                self.finishedLoading()
            }
            
            
            if value?["break"] != nil {
                self.delegate?.resumeBreak()
            }
            
            let activeProjects = value?["active projects"] as? [String]
            if activeProjects != nil {
                var count = 0
                for ref in activeProjects! {
                    count += 1
                    FIRDatabase.database().reference().child("projects").child(ref).observeSingleEvent(of: .value, with: { (snapshot) in
                        var project = Project.init(snapshot: snapshot)
                        project.firebaseRef = snapshot.ref
                        ProjectController.sharedInstance.activeProjects.append(project)
                        ProjectController.sharedInstance.activeProjectsRefs.append(ref)
                        if count == activeProjects?.count {
                            self.finishedLoading()
                        }
                    })
                }
            } else {
                self.finishedLoading()
            }
            
            let categoryRefs = value?["categories"] as? NSDictionary
            if let categoryRefs = categoryRefs {
                var count = 0
                for ref in categoryRefs.allKeys {
                    count += 1
                    self.userRef?.child("categories").child(ref as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        CategoryContoller.sharedInstance.categories.append(Category.init(snapshot: snapshot))
                        
                        if count == categoryRefs.count {
                            self.finishedLoading()
                        }
                    })
                }
            } else {
                self.finishedLoading()
            }
            
        })
        return true
    }
    
    
    /// Helper method to know when the fetchInitialData() is finished loading.
    func finishedLoading() {
        if loadingInt == 2 {
            DispatchQueue.main.async {
                self.delegate?.updateTableView()
            }
            
        } else {
            loadingInt += 1
        }
    }
    
    
}
