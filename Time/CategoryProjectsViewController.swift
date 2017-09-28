//
//  CategoryProjectsViewController.swift
//  Time
//
//  Created by Soren Nelson on 6/18/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class CategoryProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LargeProjectUpdater {

    @IBOutlet var tableview: UITableView!
    
    var category: Category?
    var selectedProject: Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard  let category = category else { return }
                
        self.navigationController?.title = category.name
        
        // TODO: Spinner Wheel
        if category.projectRefs.count > 0 {
            DispatchQueue.main.async(execute: {
                CategoryContoller.sharedInstance.fetchProjectsFromCategoryRef(category: category, _completion: { (cat, success) in
                    guard let cat = cat else { return }
                    self.category = cat
                    self.tableview.reloadData()
                })
            })
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let _ = category?.projects else { return 0 }
        return (category?.projects.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryProjectsCell", for: indexPath) as! ActiveProjectTableViewCell
        guard let _ = category?.projects else { return cell }
        
        if (category?.projects[indexPath.row].activeTimer) != nil {
            cell.setUpCell(project: (category?.projects[indexPath.row])!, active: true, scheduled: false)
        } else {
            cell.setUpCell(project: (category?.projects[indexPath.row])!, active: false, scheduled: false)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 77
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let projects = category?.projects else { return }
        if indexPath.row < projects.count {
            selectedProject = category?.projects[indexPath.row]
            performSegue(withIdentifier: "CategoryProjectSegue", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateTableView() {
        tableview.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryProjectSegue" {
            
            guard let selectedProject = selectedProject else { return }
            
            let navController = segue.destination as! UINavigationController
            let destination = navController.topViewController as! LargeTimerViewController

            for p in ProjectController.sharedInstance.activeProjects {
                if p.isEqual(rhs: selectedProject) {
                    destination.isActive = true
                }
            }
            destination.project = selectedProject
        }
    }
    

}
