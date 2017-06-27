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

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GIDSignInUIDelegate, TimerCellUpdater, LargeTimerUpdater, InitialDataUpdater, UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
	var selectedProject: Project?
	
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
		
		if ProjectController.sharedInstance.activeProjects.count > 0 {
			if ProjectController.sharedInstance.activeProjects.count > 4 && ProjectController.sharedInstance.currentProject != nil {
				return ProjectController.sharedInstance.activeProjects.count + 2
			}
			if ProjectController.sharedInstance.activeProjects.count > 7 {
				return ProjectController.sharedInstance.activeProjects.count + 2
			}
			
		}
		
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		
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
		
		 if indexPath.row == 0 && ProjectController.sharedInstance.currentProject != nil {
			selectedProject = ProjectController.sharedInstance.currentProject
			performSegue(withIdentifier: "projectSegue", sender: self)
			
		} else if indexPath.row > 1 && ProjectController.sharedInstance.activeProjects.count > indexPath.row - 2 {
			selectedProject = ProjectController.sharedInstance.activeProjects[indexPath.row - 2]
			performSegue(withIdentifier: "projectSegue", sender: self)
			
		}
//		else {
//			cell?.selectionStyle = UITableViewCellSelectionStyle.none
//		}
		
        tableView.deselectRow(at: indexPath, animated: true)
    }
	
	func updateTableView() {
		tableView.reloadData()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		// updates project name
		if textField.text != "" && textField.text != nil {
			let project = ProjectController.sharedInstance.currentProject
			if let p = ProjectController.sharedInstance.updateProject(project: project!, name: textField.text, categoryName: nil) {
				ProjectController.sharedInstance.currentProject = p
			}
			self.tableView.reloadData()
		}
		textField.resignFirstResponder()
		return true
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "projectSegue" {
			let destination = segue.destination as! LargeTimerViewController
			destination.delegate = self
			destination.project = selectedProject
		}
	}
    
}
















