//
//  ProgressTableViewCell.swift
//  Time
//
//  Created by Soren Nelson on 9/28/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    
    @IBOutlet var sessionLengthLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    var totalProgress: Double?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let project = ProjectController.sharedInstance.currentProject
        
        if let seshLength = SessionController.sharedInstance.currentSession?.customizedSessionLength {
            totalProgress = seshLength
            sessionLengthLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: seshLength, bigVersion: false, deadline: false, seconds: false)
        } else {
            if let total = project?.activeTimer?.totalLength, let count = project?.activeTimer?.sessions.count {
                totalProgress = total/Double(count)
                sessionLengthLabel.text = ProjectController.sharedInstance.hourMinuteStringFromTimeInterval(interval: total / Double(count), bigVersion: false, deadline: false, seconds: false)
            }
        }
        
        updateProgress()
    }
    
    func updateProgress() {
        let counter = abs(Int((ProjectController.sharedInstance.currentProject?.activeTimer?.sessions.last?.startTime.timeIntervalSinceNow)!))
        
        let fractionalProgress = Float(counter) / Float(totalProgress!)
        let animated = counter != 0
        
        progressView.setProgress(fractionalProgress, animated: animated)
    }

}
