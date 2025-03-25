//
//  NotificationService.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import UserNotifications
import CoreData

class NotificationService {
    
    static let shared = NotificationService()
    
    private init() {
        requestPermission()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    func scheduleEventReminder(for event: Event) {
        guard let title = event.title, let startDate = event.startDate else { return }
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Event Reminder"
        content.body = "Your event '\(title)' is starting soon"
        content.sound = .default
        
        // Create trigger (15 minutes before event)
        let triggerDate = startDate.addingTimeInterval(-15 * 60)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Create request
        let identifier = "event-\(event.objectID.uriRepresentation().absoluteString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelEventReminder(for event: Event) {
        let identifier = "event-\(event.objectID.uriRepresentation().absoluteString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

// MARK: - Extensions and Helpers

// NSSecureUnarchiveFromDataTransformer extension for Core Data
extension NSSecureUnarchiveFromDataTransformer {
    static let secureUnarchiveFromDataTransformerName = NSValueTransformerName(rawValue: "NSSecureUnarchiveFromDataTransformer")
    
    static func register() {
        let transformer = NSSecureUnarchiveFromDataTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: secureUnarchiveFromDataTransformerName)
    }
}

// Helper for creating fetch requests for Core Data entities
extension NSManagedObject {
    static func fetchRequest<T: NSManagedObject>() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: String(describing: self))
    }
}
