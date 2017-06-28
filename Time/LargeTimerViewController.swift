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
    // Active & Inactive: Last Session
    @IBOutlet var totalTimeLabel:    UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var averageTimeLabel:  UILabel!
    // TODO: Fix
    @IBOutlet var weightNameLabel:   UILabel!
    @IBOutlet var numberOfSessionsButton: UIButton!
    
// Buttons
    //Current & Active:cancel || inactive:Make Repeating
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
            
            // TODO: tap to add name or some shit
            self.timerName.text = project.name ?? "Timer Name: -"
            self.categoryName.text = project.categoryRef ?? "Category: -"
            let seshes = project.activeTimer?.sessions.count ?? 1
            self.numberOfSessionsButton.setTitle("\(seshes)", for: .normal)
            
            let projectController = ProjectController.sharedInstance
            
            if projectController.currentProject != nil && (projectController.currentProject?.isEqual(rhs: project))! {
                self.running = true
                
                self.timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: (project.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!, bigVersion: true, deadline: false)
                self.weightNameLabel.text = projectController.weightString(weight: (project.activeTimer?.weight)!)
                self.totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: projectController.getRunningTimerTotalLength(), bigVersion: true, deadline: false)
                self.activeLabel.text = "Running"
                
            } else if isActive {
                
                self.totalLabel.text = "Last Session:"
                let lastSesh = project.activeTimer?.sessions.last?.totalLength ?? 0
                self.totalTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: lastSesh, bigVersion: true, deadline: false)
                
                let total = project.activeTimer?.totalLength ?? 0
                self.timeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: total, bigVersion: true, deadline: false)
                
                
                self.weightNameLabel.text = projectController.weightString(weight: project.weight)
                
                self.breakButton.setTitle("Delete Project", for: .normal)
                self.endSessionButton.setTitle("Start Session", for: .normal)

            } else {
                
                self.activeLabel.text = "Inactive"
                self.timeLabel.text = "-"
                self.numberOfSessionsButton.setTitle("-", for: .normal)
                
                self.totalLabel.text = "Last Session:"
                
                //TODO: Fix Name
                self.cancelTimerButton.setTitle("Make Repeating", for: .normal)
                self.breakButton.setTitle("Delete Project", for: .normal)
                self.endSessionButton.setTitle("Start", for: .normal)
                self.doneButton.setTitle("New", for: .normal)
            }
            
            if let deadline = project.activeTimer?.deadline {
                self.deadlineTimeLabel.text = projectController.hourMinuteStringFromTimeInterval(interval: deadline.timeIntervalSinceNow, bigVersion: true, deadline: true)
                if (self.deadlineTimeLabel.text?.contains("-"))! {
                    // TODO: Fix Color
                    //  self.deadlineTimeLabel.textColor = UIColor.red
                }
            } else {
                self.deadlineTimeLabel.text = "-"
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
        
    }
    
    // Running: end session
    // Active: start session
    // TODO: Inactive: start
    @IBAction func endSessionPressed(_ sender: Any) {
        if running {
            SessionController.sharedInstance.endSession(projectIsDone: false)
            self.running = false
        } else if isActive {
            guard let project = project else { return }
            SessionController.sharedInstance.startSession(p: project)
            self.running = true
        } else {
            guard let project = project else { return }
            //
            SessionController.sharedInstance.startSession(p: project)
            self.running = true
        }
        
        self.delegate?.updateTableView()
    }
    
    // Running & Active: Done
    // TODO: Inactive: New
    @IBAction func doneButtonPressed(_ sender: Any) {
        if isActive || running {
            ProjectController.sharedInstance.endTimer(project: project!)
            self.delegate?.updateTableView()
        }
    }
    
}










