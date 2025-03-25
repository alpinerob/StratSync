//
//  CustomCells.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import UIKit

class EventCell: UITableViewCell {
    func configure(with event: Event) {
        textLabel?.text = event.title
        
        if let date = event.startDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            detailTextLabel?.text = formatter.string(from: date)
        }
    }
}

class ProjectCell: UITableViewCell {
    func configure(with project: Project) {
        textLabel?.text = project.name
        detailTextLabel?.text = project.projectDescription
    }
}

class NotificationCell: UITableViewCell {
    func configure(with notification: Notification) {
        textLabel?.text = notification.title
        detailTextLabel?.text = notification.message
    }
}
