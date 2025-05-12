//
//  NotificationManager.swift
//  Habit Tracker
//
//  Created by Amy Cai on 12/5/2025.
//
import UserNotifications
 
class NotificationManager {
  static let shared = NotificationManager()
  
  private init() {}
  
  func schedule(habitID: UUID, title: String, time: Date, weekdays: [Int]) {
    let center = UNUserNotificationCenter.current()
            cancel(id: habitID.uuidString)
 
            for weekday in weekdays {
                var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                dateComponents.weekday = weekday
 
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = "It's time to complete your habit!"
                content.sound = .default
 
                let request = UNNotificationRequest(
                    identifier: "\(habitID.uuidString)_\(weekday)",
                    content: content,
                    trigger: trigger
                )
 
                center.add(request)
            }
        }
 
        func cancel(id: String) {
            let ids = (1...7).map { "\(id)_\($0)" }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
  }
}
 
 
