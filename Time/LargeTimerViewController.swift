//
//  LargeTimerTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 5/16/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

protocol LargeTimerUpdater {
    func updateTableView()
}

class LargeTimerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableview: UITableView!
    var largeTimerCell: LargeTimerTableViewCell?
    var infoCell: LargeTimerInfoTableViewCell?
    var sessionCell: LargeTimerSessionInfoTableViewCell?
    var buttonCell: LargeTimerButtonTableViewCell?
    
    var running = false
    var isActive = false
    var activeState = "Inactive"
    var delegate: LargeTimerUpdater?
    var breakUpdater: BreakUpdater?
    var project:  Project?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationItem.title = project?.name
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUp() {
        
        if let project = project {
            let projectController = ProjectController.sharedInstance
            
            // TODO: tap to add name or some shit
//            if project.name != nil && project.name != ""  {
//                timerName.text = project.name
//            } else {
//                timerName.text = "-"
//            }
            
//            if project.categoryRef != nil && project.categoryRef != "" {
//                categoryName.text = project.categoryRef
//            } else {
//                self.categoryName.text = "-"
//            }

            if projectController.currentProject != nil && (projectController.currentProject?.isEqual(rhs: project))! {
                running = true
                activeState = "Running"
//                if abs((project.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!) < 3600.0 {
//                    
//                }
                
                runTimer()
                
            } else if isActive {
                activeState = "Active"
            } else {
                activeState = "Inactive"

            }
            
        }
        
        tableview.reloadData()
        // TODO: Add Typical time. Check Sketch
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            largeTimerCell = tableView.dequeueReusableCell(withIdentifier: "LargeTimer", for: indexPath) as? LargeTimerTableViewCell
            largeTimerCell?.tableview = self
            largeTimerCell?.setUpCell()
            return largeTimerCell!
            
        } else if indexPath.row <= 4 || indexPath.row == 6 {
            
            infoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? LargeTimerInfoTableViewCell
            infoCell?.tableview = self
            infoCell?.state = indexPath.row
            infoCell?.setUpCell()
            
            return infoCell!
            
        } else if indexPath.row == 5 {
            
            sessionCell = tableView.dequeueReusableCell(withIdentifier: "SessionInfoCell", for: indexPath) as? LargeTimerSessionInfoTableViewCell
            sessionCell?.tableview = self
            sessionCell?.setUpCell()
            return sessionCell!
            
        } else {
            
            buttonCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? LargeTimerButtonTableViewCell
            buttonCell?.tableview = self
            buttonCell?.state = indexPath.row
            buttonCell?.setUpCell()
            return buttonCell!
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if tableView.frame.height < 600 {
            if indexPath.row == 0 {
                
                return tableView.frame.height - (45 * 6) - 180
                
            } else if indexPath.row <= 6 {
                return 45
                
            } else {
                return 90
            }
        
        } else if view.frame.height < 700 {
            if indexPath.row == 0 {
                return tableView.frame.height - (55 * 6) - 180
                
            } else if indexPath.row <= 6 {
                return 53
                
            } else {
                return 90
            }
            
        } else {
            if indexPath.row == 0 {
                return tableView.frame.height - (55 * 6) - 220
                
            } else if indexPath.row <= 6 {
                return 55
                
            } else {
                return 100
            }
        }
    }
    
    
    
    func runTimer() {
        ProjectController.sharedInstance.projectTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        
        if let project = ProjectController.sharedInstance.currentProject {
            largeTimerCell?.timeLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false, seconds: true)
            
            
            if Double(abs(Int((project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!))) == SessionController.sharedInstance.currentSession?.customizedSessionLength {
                timerCompleted(true)
            }

            
            if abs(Int((project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!)) == 3600 {
                setUp()
            }
            
        } else {
            ProjectController.sharedInstance.projectTimer.invalidate()
        }
        
    }

    func timerCompleted(_ timer: Bool) {
        delegate?.updateTableView()
        
        if timer {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Your session is complete.", message: "Time for a break.", preferredStyle: .alert)
                let breakAction = UIAlertAction(title: "Start Break", style: .default, handler: { (action) in
                    SessionController.sharedInstance.delegate = self.breakUpdater
                    SessionController.sharedInstance.startBreak(previousProjectRef: ProjectController.sharedInstance.currentProject?.firebaseRef?.key)
                    
                    self.running = false
                    self.isActive = false
                    self.delegate?.updateTableView()
                    ProjectController.sharedInstance.projectTimer.invalidate()
                })
                let snooze = UIAlertAction(title: "Snooze", style: .default, handler: { (action) in
                    ProjectController.sharedInstance.snoozeSessionTimer()
                    self.delegate?.updateTableView()
                })
                let projectCompleted = UIAlertAction(title: "Project Completed", style: .default, handler: { (action) in
                    ProjectController.sharedInstance.projectTimer.invalidate()
                    ProjectController.sharedInstance.endTimer(project: ProjectController.sharedInstance.currentProject!)
                    self.delegate?.updateTableView()
                })
                
                alert.addAction(breakAction)
                alert.addAction(snooze)
                alert.addAction(projectCompleted)
                
                self.present(alert, animated: true, completion: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Break time is up", message: "Get back to work", preferredStyle: .alert)
                
                if let ref = SessionController.sharedInstance.currentBreak?.previousProjectRef {
                    for project in ProjectController.sharedInstance.activeProjects {
                        if ref == project.firebaseRef?.key {
                            let resumeAction = UIAlertAction(title: "Resume Project", style: .default, handler: { (action) in
                                SessionController.sharedInstance.startSessionNow(p: project, customizedSessionLength: project.presetSessionLength)
                                
                            })
                            alert.addAction(resumeAction)
                        }
                    }
                }
                
                let snooze = UIAlertAction(title: "Snooze", style: .default, handler: { (action) in
                    SessionController.sharedInstance.snooze()
                })
                let okay = UIAlertAction(title: "Okay", style: .cancel , handler: nil)
                
                
                alert.addAction(snooze)
                alert.addAction(okay)
                
                self.present(alert, animated: true, completion: nil)
            })
        }
        
    }
}










