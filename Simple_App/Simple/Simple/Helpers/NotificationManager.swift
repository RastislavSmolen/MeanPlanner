//
//  NotificationManager.swift
//  Simple
//
//  Created by Rastislav Smolen on 25/01/2023.
//

import Foundation
import NotificationCenter

class NotificationManager {
    func testNotification(){
          let center = UNUserNotificationCenter.current()
          let content = UNMutableNotificationContent()
          content.title = "Great new you can add new tasks"
          content.body = "Timer runned out"
          content.sound = .default
          content.userInfo = ["value": "Data with local notification"]
          let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(60))
          let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
          let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
          center.add(request) { (error) in
              if error != nil {
                  print("Error = \(error?.localizedDescription ?? "error local notification")")
              }
          }
    }
}
