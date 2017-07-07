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
    var homeView: ProjectViewController?
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
            
            averageTimeLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: project.estimatedLength, bigVersion: true, deadline: false)
            
            let seshes = project.activeTimer?.sessions.count ?? 1
            numberOfSessionsButton.setTitle("\(seshes)", for: .normal)

            if projectController.currentProject != nil && (projectController.currentProject?.isEqual(rhs: project))! {
                running = true
                
                timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false)
                weightNameLabel.text = projectController.weightString(weight: (project.activeTimer?.weight)!)
                totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: projectController.getRunningTimerTotalLength(), bigVersion: true, deadline: false)
                activeLabel.text = "Running"
                
            } else if isActive {
                
                totalLabel.text = "Last Session:"
                let lastSesh = project.activeTimer?.sessions.last?.totalLength ?? 0
                totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: lastSesh, bigVersion: true, deadline: false)
                
                let total = project.activeTimer?.totalLength ?? 0
                timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: total, bigVersion: true, deadline: false)
                
                
                weightNameLabel.text = projectController.weightString(weight: project.weight)
                
                breakButton.setTitle("Delete Project", for: .normal)
                endSessionButton.setTitle("Start Session", for: .normal)

            } else {
                
                activeLabel.text = "Inactive"
                timeLabel.text = "-"
                numberOfSessionsButton.setTitle("-", for: .normal)
                
                self.totalLabel.text = "Last Timer:"
                //TODO: Check timers
                totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: project.timers.last?.totalLength ?? 0, bigVersion: true, deadline: false)
                
                //TODO: Fix Name
                cancelTimerButton.setTitle("Make Repeating", for: .normal)
                breakButton.setTitle("Delete Project", for: .normal)
                endSessionButton.setTitle("Start", for: .normal)
                doneButton.setTitle("New", for: .normal)
            }
            
            if let deadline = project.activeTimer?.deadline {
                deadlineTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceNow, bigVersion: true, deadline: true)
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
            SessionController.sharedInstance.startSession(p: project)
            running = true
        } else {
            guard let project = project else { return }
            let _ = ProjectController.sharedInstance.newTimer(project: project, weight: project.weight, deadline: nil, newProject: false)
            running = true
            self.project = ProjectController.sharedInstance.currentProject
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
    
}










