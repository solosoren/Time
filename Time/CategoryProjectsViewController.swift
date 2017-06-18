//
//  CategoryProjectsViewController.swift
//  Time
//
//  Created by Soren Nelson on 6/18/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class CategoryProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableview: UITableView!
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard  let category = category else { return }
        
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
        cell.setUpCell(project: (category?.projects[indexPath.row])!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    

}
