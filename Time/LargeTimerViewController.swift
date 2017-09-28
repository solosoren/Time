//
//  LargeTimerTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 5/16/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

protocol LargeProjectUpdater {
    func updateTableView()
}

class LargeTimerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var navItem: UINavigationItem!
    
    @IBOutlet var tableview: UITableView!
    var largeTimerCell: LargeTimerTableViewCell?
    var infoCell: LargeTimerInfoTableViewCell?
   
    @IBOutlet var buttonView: LargeTimerButtonView!
    
    var isActive = false
    var delegate: LargeProjectUpdater?
    var breakUpdater: BreakUpdater?
    var project:  Project?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        if isActive == true {
            navigationItem.title = "Active Project"
        } else {
            navigationItem.title = "Inactive Project"
        }
        
        buttonView.tableview = self        
        tableview.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let titleCell = tableview.dequeueReusableCell(withIdentifier: "ProjectHeaderCell", for: indexPath) as! LargeTimerProjectTitleTableViewCell
            titleCell.projectTitle.text = project?.name
            titleCell.projectCategory.text = project?.categoryName
            
            return titleCell
            
        } else if indexPath.row < 4 || indexPath.row == 6 {
            
            infoCell = tableView.dequeueReusableCell(withIdentifier: "LargeTimerInfoCell", for: indexPath) as? LargeTimerInfoTableViewCell
            infoCell?.tableview = self
            infoCell?.state = indexPath.row
            infoCell?.setUpCell()
            
            return infoCell!
            
        } else if indexPath.row == 4 {
            
            let barCell = tableView.dequeueReusableCell(withIdentifier: "BarAcrossCell", for: indexPath)
            return barCell
            
        } else {
            
            let secondaryHeaderCell = tableView.dequeueReusableCell(withIdentifier: "CurrentTimerHeaderCell", for: indexPath) as! LargeTimerSecondaryHeaderTableViewCell
            if isActive == true {
                secondaryHeaderCell.header.text = "Current Timer"
            } else {
                secondaryHeaderCell.header.text = "Previous Timer"
            }
            return secondaryHeaderCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        var spaceBetween = 30
        if indexPath.row == 0 {
            return 70 + 20
        } else if indexPath.row < 4 || indexPath.row == 6 {
            return 85 + 30
        } else if indexPath.row == 4 {
            return 21
        } else {
            return 26 + 15
        }
    }
    

}










