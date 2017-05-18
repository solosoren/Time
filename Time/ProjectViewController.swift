//
//  ViewController.swift
//  Timer
//
//  Created by Soren Nelson on 4/8/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit
import Firebase

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
	var selectedRowIndex = -1
	var isSelected = false
	var checked = false
	
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		if checked == false {
			FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
				self.checked = true
				if let user = user {
					print("User up and running")
					//TODO: Current user
				} else {
					let view = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
					self.present(view, animated: true, completion: nil)
				}
				
			}
		}
		
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
















