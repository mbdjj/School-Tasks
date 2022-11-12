//
//  NotificationHandler.swift
//  School Tasks
//
//  Created by Marcin Bartminski on 10/05/2022.
//

import UserNotifications
import UIKit
import SwiftUI

class NotificationHandler {
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var taskArray: FetchedResults<Task>?
    
    static let shared = NotificationHandler()
    
    //MARK: - methods
    
    func requestNotificationPermission() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound, .criticalAlert)
        
        userNotificationCenter.requestAuthorization(options: authOptions) { _, error in
            if let error = error {
                print("Error requesting authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func sheduleNotification(about task: Task) {
        let content = UNMutableNotificationContent()
        content.title = "Tasks"
        content.body = task.title ?? ""
        content.badge = 1
        content.sound = .defaultCritical
        content.interruptionLevel = .timeSensitive
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.dateOfNotification ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.uuid!.uuidString, content: content, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteNotification(about task: Task) {
        if !task.notify { return }
        
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [task.uuid!.uuidString])
    }
    
    private func setBadges(to number: Int) {
        UIApplication.shared.applicationIconBadgeNumber = number
    }
    
    func setBadges() {
        var numberOfBadges = 0
        
        for task in self.taskArray! {
            if task.notify {
                if task.dateOfNotification! < Date() && !task.isDone {
                    numberOfBadges += 1
                }
            }
        }
        
        self.setBadges(to: numberOfBadges)
    }
    
    func clearBadges() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
}
