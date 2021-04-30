//
//  NotificationManager.swift
//  Stretch-iOS (iOS)
//
//  Created by Will Taylor on 06/03/2021.
//

import Foundation
import SwiftUI

class NotificationManager: ObservableObject {
  private var appState: AppState = DataManager.shared.getAppState()
  var notifications = [Notification]()
  
  private init() {}
  public static let shared = NotificationManager()
  
  private let stretchReminderId = "StretchReminder"
  private let discomfortReminderId = "DiscomfortReminder"
  
  func requestPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted == true && error == nil {
        print("Notifications permitted")
        self.scheduleNotifications()
      } else {
        print("Notifications not permitted")
      }
    }
  }
  
  func scheduleNotifications() {
    scheduleStretchReminder()
    scheduleDiscomfortReminder()
  }
  
  private func scheduleStretchReminder() {
    let content = UNMutableNotificationContent()
    content.title = "Don't forget to stretch!"
    content.body = "Take some time to stretch today. Let's build a better posture."
    content.sound = .default
    
    // Configure the recurring date
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    
    // remind user at midday
    dateComponents.hour = 12
    dateComponents.minute = 00
    
    // Create the trigger as a repeating event.
    let trigger = UNCalendarNotificationTrigger(
      dateMatching: dateComponents,
      repeats: true
    )
    
    // Create the request
    let request = UNNotificationRequest(
      identifier: stretchReminderId,
      content: content,
      trigger: trigger
    )
    
    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
      if error != nil {
        print("🔴 Could not send reminder!")
      } else {
        print("✅ Scheduled reminder")
      }
    }
  }
  
  private func scheduleDiscomfortReminder() {
    let content = UNMutableNotificationContent()
    content.title = "Submit a discomfort rating now!"
    content.body = "Submit a rating and see your progress."
    content.sound = .default
    
    // Configure the recurring date
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    
    // remind user at 6pm
    dateComponents.hour = 18
    dateComponents.minute = 00
    
    // Create the trigger as a repeating event.
    let trigger = UNCalendarNotificationTrigger(
      dateMatching: dateComponents,
      repeats: true
    )
    
    // Create the request
    let request = UNNotificationRequest(
      identifier: discomfortReminderId,
      content: content,
      trigger: trigger
    )
    
    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
      if error != nil {
        print("🔴 Could not send reminder!")
      } else {
        print("✅ Scheduled reminder")
      }
    }
  }
  
  func setBadgeCount(to count: Int) {
    UIApplication.shared.applicationIconBadgeNumber = count
  }
}

