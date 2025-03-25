//
//  HomeViewController.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    private let tableView = UITableView()
    private var upcomingEvents: [Event] = []
    private var recentProjects: [Project] = []
    private var notifications: [Notification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        tableView.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        
        view.addSubview(tableView)
        
        // Simple layout - in a real app use proper constraints
        tableView.frame = view.bounds
    }
    
    private func fetchData() {
        // Fetch data from Core Data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch upcoming events
        let eventFetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        eventFetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        eventFetchRequest.fetchLimit = 5
        
        // Fetch recent projects
        let projectFetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        projectFetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
        projectFetchRequest.fetchLimit = 3
        
        // Fetch notifications
        let notificationFetchRequest: NSFetchRequest<Notification> = Notification.fetchRequest()
        notificationFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        notificationFetchRequest.fetchLimit = 10
        
        do {
            upcomingEvents = try context.fetch(eventFetchRequest)
            recentProjects = try context.fetch(projectFetchRequest)
            notifications = try context.fetch(notificationFetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

// TableView extensions would go here
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return upcomingEvents.count
        case 1: return recentProjects.count
        case 2: return notifications.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            let event = upcomingEvents[indexPath.row]
            cell.configure(with: event)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
            let project = recentProjects[indexPath.row]
            cell.configure(with: project)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
            let notification = notifications[indexPath.row]
            cell.configure(with: notification)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Upcoming Events"
        case 1: return "Recent Projects"
        case 2: return "Notifications"
        default: return nil
        }
    }
}
