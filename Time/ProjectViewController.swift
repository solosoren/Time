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

protocol SignInDelegate {
	func finishedSigningIn()
}

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GIDSignInUIDelegate, TimerCellUpdater, LargeProjectUpdater, RunningProjectUpdater, InitialDataUpdater, UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
	var selectedProject: Project?
	var timerCell: TimerTableViewCell?
	var signingIn = false
	var signInDelegate: SignInDelegate?
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UserController.sharedInstance.delegate = self
		
		FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
			if user == nil {
				if !self.signingIn {
					
					self.signingIn = true
					self.performSegue(withIdentifier: "SignIn", sender: self)
				}
			} else {
				if !UserController.sharedInstance.fetched  {
					let _ = UserController.sharedInstance.fetchInitialData()
				
				}
			}
		}
		tableView.reloadData()
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		GIDSignIn.sharedInstance().uiDelegate = self
		
        tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
		
//		if #available(iOS 11.0, *) {
//			navigationController?.navigationBar.prefersLargeTitles = true
//		}
		
//		GIDSignIn.sharedInstance().signOut()
//		
//		do {
//			try FIRAuth.auth()?.signOut()
//		} catch let signOutError as NSError {
//			print ("Error signing out: %@", signOutError)
//		}

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
				
        if indexPath.row == 0 {
			timerCell = tableView.dequeueReusableCell(withIdentifier: "CurrentTimerCell", for: indexPath) as? TimerTableViewCell
			timerCell?.delegate = self
			timerCell?.setUpCell()
            return timerCell!
        } else if indexPath.row == 1 {
            let segmentedCell = tableView.dequeueReusableCell(withIdentifier: "SegmentedCell", for: indexPath)
            return segmentedCell
			
		} else if indexPath.row <= ProjectController.sharedInstance.scheduledProjects.count + 1 {
			let projectsCell = tableView.dequeueReusableCell(withIdentifier: "ProjectsCell", for: indexPath) as! ActiveProjectTableViewCell
			
			projectsCell.setUpCell(project: ProjectController.sharedInstance.scheduledProjects[indexPath.row - 2], active: false, scheduled:true)
			
			return projectsCell
			
		} else if indexPath.row <= ProjectController.sharedInstance.activeProjects.count + ProjectController.sharedInstance.scheduledProjects.count + 1 {
			
			let projectsCell = tableView.dequeueReusableCell(withIdentifier: "ProjectsCell", for: indexPath) as! ActiveProjectTableViewCell
			
			projectsCell.setUpCell(project: ProjectController.sharedInstance.activeProjects[indexPath.row - ProjectController.sharedInstance.scheduledProjects.count - 2], active: true, scheduled:false)
            return projectsCell
		} else {
			
			// returning empty cells
			let projectsCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) 
			return projectsCell
		}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if ProjectController.sharedInstance.activeProjects.count > 0 {
			return ProjectController.sharedInstance.activeProjects.count + 2 + ProjectController.sharedInstance.activeProjects.count
		} else if ProjectController.sharedInstance.scheduledProjects.count > 0 {
			return 2 + ProjectController.sharedInstance.activeProjects.count
		}
		
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		
        if indexPath.row == 0 {
			if ProjectController.sharedInstance.currentProject != nil || SessionController.sharedInstance.onBreak {
				return 260
			} else {
				return 85
			}
			
        } else if indexPath.row == 1 {
            return 40
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		 if indexPath.row == 0 && ProjectController.sharedInstance.currentProject != nil {
			selectedProject = ProjectController.sharedInstance.currentProject
			performSegue(withIdentifier: "RunningProjectSegue", sender: self)
			
		} else if indexPath.row > 1 && ProjectController.sharedInstance.scheduledProjects.count > 0 && indexPath.row <= ProjectController.sharedInstance.scheduledProjects.count + 1 {
			
			selectedProject = ProjectController.sharedInstance.scheduledProjects[indexPath.row - 2]
			performSegue(withIdentifier: "projectSegue", sender: self)
			
			
		} else if indexPath.row > 1 && indexPath.row <= ProjectController.sharedInstance.activeProjects.count + ProjectController.sharedInstance.scheduledProjects.count + 1 {
			
			selectedProject = ProjectController.sharedInstance.activeProjects[indexPath.row - 2 - ProjectController.sharedInstance.scheduledProjects.count]
			performSegue(withIdentifier: "projectSegue", sender: self)
			
		}
		
        tableView.deselectRow(at: indexPath, animated: true)
    }
	
	func updateTableView() {
		tableView.reloadData()
		if signingIn {
			self.signingIn = false
			signInDelegate?.finishedSigningIn()
		}
	}
	
	func presentAlert(alert: UIAlertController) {
		self.present(alert, animated: true, completion: nil)
	}
	
	func resumeBreak() {
		guard let timerCell = timerCell else { return }
		
		SessionController.sharedInstance.delegate = timerCell
		SessionController.sharedInstance.continueBreak()
		
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
		if segue.identifier == "SignIn" {
			let destination = segue.destination as! SignInViewController
			destination.homeVC = self
		}
		
		if segue.identifier == "projectSegue" {
			let navController = segue.destination as! UINavigationController
			let destination = navController.topViewController as! LargeTimerViewController
			destination.project = selectedProject
			destination.isActive = true
		}
		
		if segue.identifier == "RunningProjectSegue" {
			let navController = segue.destination as! UINavigationController
			let destination = navController.topViewController as! RunningProjectViewController
			destination.delegate = self
			destination.breakUpdater = timerCell
		}
	}

}
















