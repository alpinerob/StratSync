//
//  DashboardViewController.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    private let coreDataStack = CoreDataStack.shared
    private var projects: [Project] = []
    private var upcomingEvents: [Event] = []
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let welcomeLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let projectsSummaryView = UIView()
    private let projectsHeaderLabel = UILabel()
    private let projectsCountLabel = UILabel()
    private let projectsTableView = UITableView()
    
    private let eventsHeaderLabel = UILabel()
    private let eventsTableView = UITableView()
    
    private let quickActionsView = UIView()
    private let quickActionsHeaderLabel = UILabel()
    private let newProjectButton = UIButton(type: .system)
    private let scheduleEventButton = UIButton(type: .system)
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        title = "Dashboard"
        view.backgroundColor = .systemBackground
        
        // Navigation bar setup
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Scroll view setup
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        // Welcome section
        welcomeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        welcomeLabel.text = "Welcome to SmallBusinessCompass"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .secondaryLabel
        
        // Projects summary section
        projectsSummaryView.backgroundColor = .secondarySystemBackground
        projectsSummaryView.layer.cornerRadius = 12
        
        projectsHeaderLabel.text = "Active Projects"
        projectsHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        projectsCountLabel.font = UIFont.systemFont(ofSize: 16)
        projectsCountLabel.textColor = .secondaryLabel
        
        projectsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectCell")
        projectsTableView.isScrollEnabled = false
        projectsTableView.backgroundColor = .clear
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        projectsTableView.tag = 1
        
        // Events section
        eventsHeaderLabel.text = "Upcoming Events"
        eventsHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        eventsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        eventsTableView.isScrollEnabled = false
        eventsTableView.backgroundColor = .clear
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.tag = 2
        
        // Quick actions section
        quickActionsView.backgroundColor = .secondarySystemBackground
        quickActionsView.layer.cornerRadius = 12
        
        quickActionsHeaderLabel.text = "Quick Actions"
        quickActionsHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        newProjectButton.setTitle("New Project", for: .normal)
        newProjectButton.backgroundColor = .systemBlue
        newProjectButton.setTitleColor(.white, for: .normal)
        newProjectButton.layer.cornerRadius = 8
        
        scheduleEventButton.setTitle("Schedule Event", for: .normal)
        scheduleEventButton.backgroundColor = .systemGreen
        scheduleEventButton.setTitleColor(.white, for: .normal)
        scheduleEventButton.layer.cornerRadius = 8
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(projectsSummaryView)
        projectsSummaryView.addSubview(projectsHeaderLabel)
        projectsSummaryView.addSubview(projectsCountLabel)
        projectsSummaryView.addSubview(projectsTableView)
        
        contentView.addSubview(eventsHeaderLabel)
        contentView.addSubview(eventsTableView)
        
        contentView.addSubview(quickActionsView)
        quickActionsView.addSubview(quickActionsHeaderLabel)
        quickActionsView.addSubview(newProjectButton)
        quickActionsView.addSubview(scheduleEventButton)
    }
    
    private func setupConstraints() {
        // Make all views use auto layout
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        projectsSummaryView.translatesAutoresizingMaskIntoConstraints = false
        projectsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        projectsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        projectsTableView.translatesAutoresizingMaskIntoConstraints = false
        eventsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        quickActionsView.translatesAutoresizingMaskIntoConstraints = false
        quickActionsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        newProjectButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        // ScrollView and ContentView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Welcome section
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Projects summary section
        NSLayoutConstraint.activate([
            projectsSummaryView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            projectsSummaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            projectsSummaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            projectsHeaderLabel.topAnchor.constraint(equalTo: projectsSummaryView.topAnchor, constant: 16),
            projectsHeaderLabel.leadingAnchor.constraint(equalTo: projectsSummaryView.leadingAnchor, constant: 16),
            
            projectsCountLabel.centerYAnchor.constraint(equalTo: projectsHeaderLabel.centerYAnchor),
            projectsCountLabel.trailingAnchor.constraint(equalTo: projectsSummaryView.trailingAnchor, constant: -16),
            
            projectsTableView.topAnchor.constraint(equalTo: projectsHeaderLabel.bottomAnchor, constant: 8),
            projectsTableView.leadingAnchor.constraint(equalTo: projectsSummaryView.leadingAnchor, constant: 8),
            projectsTableView.trailingAnchor.constraint(equalTo: projectsSummaryView.trailingAnchor, constant: -8),
            projectsTableView.heightAnchor.constraint(equalToConstant: 150),
            projectsTableView.bottomAnchor.constraint(equalTo: projectsSummaryView.bottomAnchor, constant: -16)
        ])
        
        // Events section
        NSLayoutConstraint.activate([
            eventsHeaderLabel.topAnchor.constraint(equalTo: projectsSummaryView.bottomAnchor, constant: 24),
            eventsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            eventsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            eventsTableView.topAnchor.constraint(equalTo: eventsHeaderLabel.bottomAnchor, constant: 8),
            eventsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            eventsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            eventsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Quick actions section
        NSLayoutConstraint.activate([
            quickActionsView.topAnchor.constraint(equalTo: eventsTableView.bottomAnchor, constant: 24),
            quickActionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quickActionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            quickActionsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            quickActionsHeaderLabel.topAnchor.constraint(equalTo: quickActionsView.topAnchor, constant: 16),
            quickActionsHeaderLabel.leadingAnchor.constraint(equalTo: quickActionsView.leadingAnchor, constant: 16),
            quickActionsHeaderLabel.trailingAnchor.constraint(equalTo: quickActionsView.trailingAnchor, constant: -16),
            
            newProjectButton.topAnchor.constraint(equalTo: quickActionsHeaderLabel.bottomAnchor, constant: 16),
            newProjectButton.leadingAnchor.constraint(equalTo: quickActionsView.leadingAnchor, constant: 16),
            newProjectButton.trailingAnchor.constraint(equalTo: quickActionsView.trailingAnchor, constant: -16),
            newProjectButton.heightAnchor.constraint(equalToConstant: 44),
            
            scheduleEventButton.topAnchor.constraint(equalTo: newProjectButton.bottomAnchor, constant: 12),
            scheduleEventButton.leadingAnchor.constraint(equalTo: quickActionsView.leadingAnchor, constant: 16),
            scheduleEventButton.trailingAnchor.constraint(equalTo: quickActionsView.trailingAnchor, constant: -16),
            scheduleEventButton.heightAnchor.constraint(equalToConstant: 44),
            scheduleEventButton.bottomAnchor.constraint(equalTo: quickActionsView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        newProjectButton.addTarget(self, action: #selector(createNewProjectTapped), for: .touchUpInside)
        scheduleEventButton.addTarget(self, action: #selector(scheduleEventTapped), for: .touchUpInside)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // Fetch active projects
        let projectPredicate = NSPredicate(format: "status == %@", "Active")
        let projectSortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        projects = coreDataStack.fetchEntities(Project.self, predicate: projectPredicate, sortDescriptors: [projectSortDescriptor])
        
        // Update projects count label
        projectsCountLabel.text = "\(projects.count) active"
        
        // Fetch upcoming events
        let today = Date()
        let calendar = Calendar.current
        let dateComponents = DateComponents(day: 7)
        guard let nextWeek = calendar.date(byAdding: dateComponents, to: today) else { return }
        
        let eventPredicate = NSPredicate(format: "date >= %@ AND date <= %@", today as NSDate, nextWeek as NSDate)
        let eventSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        upcomingEvents = coreDataStack.fetchEntities(Event.self, predicate: eventPredicate, sortDescriptors: [eventSortDescriptor])
        
        // Reload table views
        projectsTableView.reloadData()
        eventsTableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func createNewProjectTapped() {
        let alert = UIAlertController(title: "New Project", message: "Enter project details", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Project Name"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Project Description"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self,
                  let nameField = alert.textFields?[0],
                  let descField = alert.textFields?[1],
                  let name = nameField.text, !name.isEmpty else {
                return
            }
            
            self.createNewProject(name: name, description: descField.text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func scheduleEventTapped() {
        let alert = UIAlertController(title: "Schedule Event", message: "Enter event details", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Event Title"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Event Description"
        }
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        
        let containerView = UIView()
        alert.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(datePicker)
        
        // Adjust the alert size to accommodate the date picker
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 80),
            containerView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self,
                  let titleField = alert.textFields?[0],
                  let descField = alert.textFields?[1],
                  let title = titleField.text, !title.isEmpty else {
                return
            }
            
            self.createNewEvent(title: title, description: descField.text, date: datePicker.date)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        // Increase the size of the alert to fit the date picker
        alert.preferredContentSize = CGSize(width: 300, height: 400)
        
        present(alert, animated: true)
    }
    
    private func createNewProject(name: String, description: String?) {
        let project = coreDataStack.createEntity(Project.self)
        project.name = name
        project.projectDescription = description
        project.createdDate = Date()
        project.status = "Active"
        
        coreDataStack.saveContext()
        loadData()
    }
    
    private func createNewEvent(title: String, description: String?, date: Date) {
        let event = coreDataStack.createEntity(Event.self)
        event.title = title
        event.eventDescription = description
        event.date = date
        
        coreDataStack.saveContext()
        loadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 1: // Projects table
            return min(3, projects.count) // Show max 3 projects
        case 2: // Events table
            return min(3, upcomingEvents.count) // Show max 3 events
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 1: // Projects table
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
            let project = projects[indexPath.row]
            
            var content = cell.defaultContentConfiguration()
            content.text = project.name
            
            if let description = project.projectDescription, !description.isEmpty {
                content.secondaryText = description
            }
            
            cell.contentConfiguration = content
            return cell
            
        case 2: // Events table
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
            let event = upcomingEvents[indexPath.row]
            
            var content = cell.defaultContentConfiguration()
            content.text = event.title
            
            // Format date for display
            if let date = event.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                content.secondaryText = dateFormatter.string(from: date)
            }
            
            cell.contentConfiguration = content
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch tableView.tag {
        case 1: // Projects table
            // Handle project selection - navigate to project details
            let project = projects[indexPath.row]
            print("Selected project: \(project.name ?? "Unnamed")")
            // In a real app, you would navigate to a project detail view
            
        case 2: // Events table
            // Handle event selection - navigate to event details
            let event = upcomingEvents[indexPath.row]
            print("Selected event: \(event.title ?? "Unnamed")")
            // In a real app, you would navigate to an event detail view
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Add a "See All" button for tables with more items than we're showing
        switch tableView.tag {
        case 1: // Projects table
            if projects.count > 3 {
                return createSeeAllFooter { [weak self] in
                    // Navigate to Projects tab
                    self?.tabBarController?.selectedIndex = 1
                }
            }
        case 2: // Events table
            if upcomingEvents.count > 3 {
                return createSeeAllFooter { [weak self] in
                    // Navigate to Calendar tab
                    self?.tabBarController?.selectedIndex = 2
                }
            }
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableView.tag {
        case 1: // Projects table
            return projects.count > 3 ? 30 : 0
        case 2: // Events table
            return upcomingEvents.count > 3 ? 30 : 0
        default:
            return 0
        }
    }
    
    private func createSeeAllFooter(action: @escaping () -> Void) -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        return footerView
    }
}
