//
//  RunningProjectViewController.swift
//  Time
//
//  Created by Soren Nelson on 9/27/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

protocol RunningProjectUpdater {
    func updateTableView()
}

class RunningProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableview: UITableView!
    
    var delegate: RunningProjectUpdater?
    var breakUpdater: BreakUpdater?
    var project = ProjectController.sharedInstance.currentProject
    var largeTimerCell: LargeTimerTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        runTimer()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectHeaderCell", for: indexPath) as! LargeTimerProjectTitleTableViewCell
            cell.projectTitle.text = project?.name ?? "--"
            cell.projectCategory.text = project?.categoryName ?? ""
            return cell
        }
        
        if indexPath.row == 1 {
            largeTimerCell = tableView.dequeueReusableCell(withIdentifier: "LargeTimer", for: indexPath) as? LargeTimerTableViewCell
            largeTimerCell?.tableview = self
            largeTimerCell!.setUpCell()
            return largeTimerCell!
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCell", for: indexPath) as! ProgressTableViewCell
            
            if let seshLength = SessionController.sharedInstance.currentSession?.customizedSessionLength {
                cell.sessionLengthLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: seshLength, bigVersion: false, deadline: false, seconds: false)
            } else {
                if let total = project?.activeTimer?.totalLength, let count = project?.activeTimer?.sessions.count {
                    cell.sessionLengthLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: total / Double(count), bigVersion: false, deadline: false, seconds: false)
                }
            }
            return cell
        }
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunningProjectInfoCell", for: indexPath) as! RunningProjectInfoTableViewCell
        if let total = project?.activeTimer?.totalLength {
            cell.projectTotalTimeLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: total, bigVersion: false, deadline: false, seconds: false)
        } else {
            cell.projectTotalTimeLabel.text = "--"
        }

        if let deadline = project?.activeTimer?.deadline {
            cell.deadlineLabel.text = ProjectController.sharedInstance.dateString(deadline)
        } else {
            cell.deadlineLabel.text = "None"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 75 + 25
        }
        if indexPath.row == 1 {
            return 75 + 120
        }
        if indexPath.row == 2 {
            return 15 + 120
        }
            return 90 + 90
    }
    
    func runTimer() {
        ProjectController.sharedInstance.projectTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        
        if let project = project {
            largeTimerCell?.timeLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false, seconds: false)
            
            if Double(abs(Int((project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!))) == SessionController.sharedInstance.currentSession?.customizedSessionLength {
                timerCompleted(true)
            }
            
            if abs(Int((project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!)) == 3600 {
                tableview.reloadData()
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
                    // FIXME: Allow for break viewing
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
                                SessionController.sharedInstance.startSessionNow(p: project, customizedSessionLength: project.presetSessionLength, scheduled: false)
                                
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
