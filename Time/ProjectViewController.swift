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

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GIDSignInUIDelegate {
    
    @IBOutlet var tableView: UITableView!
	var selectedRowIndex = -1
	var isSelected = false
	var checked = false
	
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
        tableView.reloadData()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
			if user != nil {
//				self.checked = true
				//TODO: Current user
			} else {
				GIDSignIn.sharedInstance().signIn()
			}
			
		}
		
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		GIDSignIn.sharedInstance().uiDelegate = self
		
        tableView.reloadData()
        tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
		
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if isSelected {
			//TODO: figure out which timer is being pressed on
			let timerCell = tableView.dequeueReusableCell(withIdentifier: "LargeTimerCell", for: indexPath) as! LargeTimerTableViewCell
			return timerCell
		}
        
        if indexPath.row == 0 {
            let timerCell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerTableViewCell
            timerCell.setUpCell()
            return timerCell
        } else if indexPath.row == 1 {
            let segmentedCell = tableView.dequeueReusableCell(withIdentifier: "SegmentedCell", for: indexPath)
            return segmentedCell
        } else {
             let projectsCell = tableView.dequeueReusableCell(withIdentifier: "ProjectsCell", for: indexPath)
            return projectsCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isSelected {
			return 1
		}
		
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if isSelected {
			return view.frame.size.height
		}
		
        if indexPath.row == 0 {
            return 215
        } else if indexPath.row == 1 {
            return 40
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
		
		if isSelected {
			isSelected = false
			tableView.reloadData()
			
		} else if indexPath.row != 1 && !isSelected {
			selectedRowIndex = indexPath.row
			isSelected = true
			tableView.reloadData()
			
		} else {
			cell?.selectionStyle = UITableViewCellSelectionStyle.none
		}
		
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
















