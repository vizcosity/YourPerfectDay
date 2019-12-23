//
//  Notifications.swift
//  Handles creation and management of notifications for Benson.
//
//  Created by Aaron Baw on 07/12/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation
import UserNotifications

class BensonNotifier {
    
    var alertTimes: [Int] = [6, 12, 15, 18, 21]
    
    var notificationCenter = UNUserNotificationCenter.current()
    
    init(alertTimes: [Int]?, message: String){
        let notificationAuthOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
        notificationCenter.requestAuthorization(options: notificationAuthOptions) { (result, error) in
            print("[App Delegate] | \(result ? "Received authorization to send push notifications." : "User declined push notifications.")")
        }
        self.alertTimes = alertTimes ?? self.alertTimes
        
        self.alertTimes.forEach {
            let fireDate = createDailyFireDate(forHour: $0)
            self.schedule(notification: message, for: fireDate!)
        }
    }
    
    private func createDailyFireDate(forHour hour: Int) -> Date? {
        let calendar = Calendar.current
        let now = Date();
        var components = calendar.dateComponents(in: .autoupdatingCurrent, from: now)

            components.timeZone = TimeZone.current
            components.hour = hour;
            components.minute = 00;
            components.second = 00;

            let date = calendar.date(from: components);
            let formatter = DateFormatter();
            formatter.dateFormat = "MM-dd-yyyy HH:mm";

            guard let dates = date else {
                return nil;
            }
            var fireDate: String?
            fireDate = formatter.string(from: dates);
            self.log("Created firedate \(fireDate ?? "")"); // Just to Check
        return dates
    }
    
    private func schedule(notification: String, for date: Date) {
        let content = UNMutableNotificationContent()
        content.body = notification
        self.schedule(notification: content, for: date, identifier: "Notification for \(date.debugDescription)")
    }
    
    private func schedule(notification: UNMutableNotificationContent, for date: Date, identifier: String){
        let dailyTrigger = Calendar.current.dateComponents([.hour, .minute, .second], from: date);
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dailyTrigger, repeats: true);
        let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
        self.notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    private func log(_ message: String){
        print("[Benson Notifier] | \(message)")
    }
    
}
