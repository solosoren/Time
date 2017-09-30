//
//  NotificationController.swift
//  Time
//
//  Created by Soren Nelson on 8/21/17.
//  Copyright © 2017 SORN. All rights reserved.
//

import Foundation
import UserNotifications

protocol PermissionDelegate {
    func requestGranted()
}

class NotificationController {
    
    static let sharedInstance = NotificationController()
    var allowsNotifications: Bool = false
    var delegate: PermissionDelegate?
    
    func requestForPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            // adjust code if they accept vs don't
            if granted {
                // TODO: Set up Categories
                self.delegate?.requestGranted()
            } else {
                
            }
        }
    }
    
    private func timeUpNotificationThatEndsOn(_ ends: TimeInterval, with identifier: String, and content: UNMutableNotificationContent) {
        
        let currentDate = Date.init()
        let sendDate = currentDate.addingTimeInterval(ends)
        let comp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sendDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
//                print("Sent notification for \(trigger.dateComponents.minute ?? 00)")
            }
        }
    }
    
    func sessionNotification(ends: TimeInterval, with projectID:String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Your Session Is Over"
        content.body = "Time for a break"
        
        let identifier = "\(projectID) NOTIFICATION"
        
        timeUpNotificationThatEndsOn(ends, with: identifier, and: content)
    }
    
    func breakNotification(ends: TimeInterval, with projectID: String?) {
        
        let content = UNMutableNotificationContent()
        content.title = "Your Break is Over"
        content.body = "Get back to work"
        
        let identifier = "BREAK FOR \(UserController.sharedInstance.userRef?.key ?? projectID ?? "")"
        
        timeUpNotificationThatEndsOn(ends, with: identifier, and: content)
    }
    
    
    func scheduleSessionNotification(starts: Date, project: Project) {
        
        let content = UNMutableNotificationContent()
        content.title = "You scheduled a session for \(project.name ?? "") right now"
        content.body = "Let's get started"
        
        let identifier = "\((project.firebaseRef?.key)!) SCHEDULED NOTIFICATION"
        
        let comp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: starts)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
                
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
// TODO: Completion block for error scheduling
            }
        }
        
// timeUpNotification(ends: ends, identifier: identifier, content: content)
        
    }
    
    func deadlineNotification(_ deadline: Date, for project: Project) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Deadline"
        content.body = "If you haven't finished \(project.name ?? ""), you should get started now to finish by your deadline."
        
        let identifier = "\((project.firebaseRef?.key)!) DEADLINE NOTIFICATION"
        
        var timeLeft: TimeInterval
        if let totalLength = project.activeTimer?.totalLength {
            timeLeft = 0 + totalLength - project.average
        } else {
            timeLeft = 0 - project.average
        }
        
        let sendDate = deadline.addingTimeInterval(timeLeft)
        let comp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sendDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
// TODO: Completion block for error scheduling
            }
        }
    }
    
    func sessionRunningTooLong() {
        
    }
    
    func scrubNotificationWith(identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (notifications) in
            for notification in notifications {
                print(notification.date)
            }
        }
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
