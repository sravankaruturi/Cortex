//
//  NotificationManager.swift
//  Cortex
//
//  Created by Sravan Karuturi on 10/15/23.
//

import Foundation
import UserNotifications


class NotificationManager{
    
    public static let instance = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.badge, .alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    public func removeNotificationForItem(_ item: ItemModel){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id])
    }
    
    public func rescheduleNotifications(_ item: ItemModel){
        
        removeNotificationForItem(item)
        scheduleNotifications(item)
        
    }
    
    public func scheduleNotifications(_ item: ItemModel){
        // Schedule the notifications based on the item.
        
        let content = UNMutableNotificationContent()
        content.title = item.title
        content.body = item.title
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: item.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: item.id,
                    content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
               // Handle any errors.
               print(error!.localizedDescription)
           }
        }
        
    }
    
}
