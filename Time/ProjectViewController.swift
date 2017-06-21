//
//  ViewController.swift
//  Timer
//
//  Created by Soren Nelson on 4/8/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GIDSignInUIDelegate, TimerCellUpdater, LargeTimerCellUpdater, InitialDataUpdater {
    
    @IBOutlet var tableView: UITableView!
	var selectedRowIndex = -1
	var isSelected = false
	var signedIn = false
	
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UserController.sharedInstance.delegate = self
		
		FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
			if user == nil {
				GIDSignIn.sharedInstance().signIn()
			}
		}
		tableView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		GIDSignIn.sharedInstance().uiDelegate = self
		
        tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if isSelected {
			let timerCell = tableView.dequeueReusableCell(withIdentifier: "LargeTimerCell", for: indexPath) as! LargeTimerTableViewCell
			timerCell.delegate = self
			if selectedRowIndex > 1 {
				timerCell.project = ProjectController.sharedInstance.activeProjects[selectedRowIndex - 2]
				timerCell.setUpCell()
			} else {
				if let currentProject = ProjectController.sharedInstance.currentProject {
					timerCell.project = currentProject
					timerCell.setUpCell()
				}
			}
			return timerCell
		}
        
        if indexPath.row == 0 {
            let timerCell = tableView.dequeueReusableCell(withIdentifier: "CurrentTimerCell", for: indexPath) as! TimerTableViewCell
			timerCell.delegate = self
			timerCell.setUpCell()
            return timerCell
        } else if indexPath.row == 1 {
            let segmentedCell = tableView.dequeueReusableCell(withIdentifier: "SegmentedCell", for: indexPath)
            return segmentedCell
			
		// because I am going to return a full tableview regardless of the amount of projects. Check if their are projects before calling setUpCell()
        } else if indexPath.row <= ProjectController.sharedInstance.activeProjects.count + 1 {
			
			let projectsCell = tableView.dequeueReusableCell(withIdentifier: "ProjectsCell", for: indexPath) as! ActiveProjectTableViewCell
			
			projectsCell.setUpCell(project: ProjectController.sharedInstance.activeProjects[indexPath.row - 2])
            return projectsCell
		} else {
			
			// returning empty cells
			let projectsCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) 
			return projectsCell
		}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isSelected {
			return 1
		}
		if ProjectController.sharedInstance.activeProjects.count > 0 {
			if ProjectController.sharedInstance.activeProjects.count > 8 {
				self.tableView.isScrollEnabled = true
				return ProjectController.sharedInstance.activeProjects.count + 2
			}
			return 9
		}
		self.tableView.isScrollEnabled = false
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if isSelected {
			return view.frame.size.height
		}
		
        if indexPath.row == 0 {
			if ProjectController.sharedInstance.currentProject != nil {
				return 215
			} else {
				return 90
			}
			
        } else if indexPath.row == 1 {
            return 40
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let cell = tableView.cellForRow(at: indexPath)
		
		if isSelected {
			isSelected = false
			tableView.reloadData()
			self.tabBarController?.tabBar.isHidden = false
			
		} else if indexPath.row == 0 && !isSelected && ProjectController.sharedInstance.currentProject != nil {
			selectedRowIndex = indexPath.row
			isSelected = true
			tableView.reloadData()
			self.tabBarController?.tabBar.isHidden = true
			
		} else if indexPath.row > 1 && !isSelected && ProjectController.sharedInstance.activeProjects.count > indexPath.row - 2 {
			selectedRowIndex = indexPath.row
			isSelected = true
			tableView.reloadData()
			self.tabBarController?.tabBar.isHidden = true
			
		}
//		else {
//			cell?.selectionStyle = UITableViewCellSelectionStyle.none
//		}
		
        tableView.deselectRow(at: indexPath, animated: true)
    }
	
	func updateTableView() {
		tableView.reloadData()
	}
    
}
















