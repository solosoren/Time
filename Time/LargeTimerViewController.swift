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

class LargeTimerViewController: UIViewController {

    // Labels
    @IBOutlet var timerName:         UILabel!
    @IBOutlet var categoryName:      UILabel!
    @IBOutlet var activeLabel:       UILabel!
    @IBOutlet var timeLabel:         UILabel!
    
    @IBOutlet var deadlineTimeLabel: UILabel!
    // Active: Last Session || Inactive: Last Timer
    @IBOutlet var totalTimeLabel:    UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var averageTimeLabel:  UILabel!
    // TODO: Fix
    @IBOutlet var weightNameLabel:   UILabel!
    @IBOutlet var numberOfSessionsButton: UIButton!
    
// Buttons
    //Current & Active:cancel timer || inactive:Make Repeating
    @IBOutlet var cancelTimerButton: UIButton!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var notesButton: UIButton!
    //Current:Break || Active & Inactive:Delete Project
    @IBOutlet var breakButton: UIButton!
    //Current:End Session || Active:Start Session || Inactive:Start
    @IBOutlet var endSessionButton: UIButton!
    //Current & Active:Done || Inactive:New
    @IBOutlet var doneButton: UIButton!
    
    var running = false
    var isActive = false
    var delegate: LargeTimerUpdater?
    var breakUpdater: BreakUpdater?
    var project:  Project?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setUp() {
        
        if let project = project {
            let projectController = ProjectController.sharedInstance
            
            // TODO: tap to add name or some shit
            if project.name != nil && project.name != ""  {
                timerName.text = project.name
            } else {
                timerName.text = "-"
            }
            
            if project.categoryRef != nil && project.categoryRef != "" {
                categoryName.text = project.categoryRef
            } else {
                self.categoryName.text = "-"
            }
            
            averageTimeLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: project.estimatedLength, bigVersion: false, deadline: false, seconds: true)
            
            let seshes = project.activeTimer?.sessions.count ?? 1
            numberOfSessionsButton.setTitle("\(seshes)", for: .normal)

            if projectController.currentProject != nil && (projectController.currentProject?.isEqual(rhs: project))! {
                running = true
                
                timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false, seconds: true)
                
                if abs((project.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!) < 3600.0 {
                    
                }
                
                weightNameLabel.text = projectController.weightString(weight: (project.activeTimer?.weight)!)
                totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: projectController.getRunningTimerTotalLength(), bigVersion: true, deadline: false, seconds: true)
                activeLabel.text = "Running"
                runTimer()
                
            } else if isActive {
                
                totalLabel.text = "Last Session:"
                let lastSesh = project.activeTimer?.sessions.last?.totalLength ?? 0
                totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: lastSesh, bigVersion: true, deadline: false, seconds: true)
                
                let total = project.activeTimer?.totalLength ?? 0
                timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: total, bigVersion: true, deadline: false, seconds: true)
                
                
                weightNameLabel.text = projectController.weightString(weight: project.weight)
                
                breakButton.setTitle("Delete Project", for: .normal)
                endSessionButton.setTitle("Start Session", for: .normal)

            } else {
                
                activeLabel.text = "Inactive"
                timeLabel.text = "-"
                numberOfSessionsButton.setTitle("-", for: .normal)
                
                self.totalLabel.text = "Last Timer:"
                //TODO: Check timers
                totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: project.timers.last?.totalLength ?? 0, bigVersion: true, deadline: false, seconds: true)
                
                //TODO: Fix Name
                cancelTimerButton.setTitle("Make Repeating", for: .normal)
                breakButton.setTitle("Delete Project", for: .normal)
                endSessionButton.setTitle("Start", for: .normal)
                doneButton.setTitle("New", for: .normal)
            }
            
            if let deadline = project.activeTimer?.deadline {
                deadlineTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceNow, bigVersion: true, deadline: true, seconds: false)
                if (deadlineTimeLabel.text?.contains("-"))! {
                    // TODO: Fix Color
                    //  self.deadlineTimeLabel.textColor = UIColor.red
                }
            } else {
                deadlineTimeLabel.text = "-"
            }
        }
        
        breakButton.titleLabel?.textAlignment = .center
        cancelTimerButton.titleLabel?.textAlignment = .center
        endSessionButton.titleLabel?.textAlignment = .center
        
        // TODO: Add Typical time. Check Sketch
    }
    
    // Running & Active: Cancel
    // Inactive: Make Repeating
    @IBAction func cancelTimer(_ sender: Any) {
        
    }
    
    @IBAction func updateTimer(_ sender: Any) {
        
    }
    
    @IBAction func notesButtonPressed(_ sender: Any) {
        
    }

    // TODO: Running: Break
    // Active & Inactive: Delete Timer
    @IBAction func breakButtonPressed(_ sender: Any) {
        
        if running {
            SessionController.sharedInstance.delegate = breakUpdater
            SessionController.sharedInstance.startBreak(previousProjectRef: self.project?.firebaseRef?.key)
            self.running = false
            self.isActive = false
            
        } else {
            guard let project = project else { return }
            ProjectController.sharedInstance.deleteProject(project: project, active: isActive, running: false)
            
        }
        
        setUp()
        delegate?.updateTableView()
    }
    
    // Running: end session
    // Active: start session
    // TODO: Inactive: start
    @IBAction func endSessionPressed(_ sender: Any) {
        if running {
            SessionController.sharedInstance.endSession(projectIsDone: false)
            running = false
            isActive = true
        } else if isActive {
            guard let project = project else { return }
            SessionController.sharedInstance.startSession(p: project, customizedSessionLength: project.presetSessionLength)
            running = true
            if SessionController.sharedInstance.onBreak {
                SessionController.sharedInstance.endBreak()
            }
        } else {
            guard let project = project else { return }
            let _ = ProjectController.sharedInstance.newTimer(project: project, weight: project.weight, deadline: nil,  newProject: false)
            running = true
            self.project = ProjectController.sharedInstance.currentProject
            if SessionController.sharedInstance.onBreak {
                SessionController.sharedInstance.endBreak()
            }
        }
        setUp()
        delegate?.updateTableView()
    }
    
    // Running & Active: Done
    // TODO: Inactive: New
    @IBAction func doneButtonPressed(_ sender: Any) {
        if isActive || running {
            ProjectController.sharedInstance.endTimer(project: project!)
            delegate?.updateTableView()
            self.running = false
            self.isActive = false
            setUp()
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func runTimer() {
        ProjectController.sharedInstance.projectTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        
        if let project = ProjectController.sharedInstance.currentProject {
            timeLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: (project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false, seconds: true)
            
            
            if Double(abs(Int((project.activeTimer!.sessions.last?.startTime.timeIntervalSinceNow)!))) == 10 {
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
                                SessionController.sharedInstance.startSession(p: project, customizedSessionLength: project.presetSessionLength)
                                
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










