//
//  ProjectsViewController.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import UIKit
import CoreData

class ProjectsViewController: UIViewController {
    
    private var projects: [Project] = []
    private let tableView = UITableView()
    private let coreDataStack = CoreDataStack.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        fetchProjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProjects() // Refresh data when view appears
    }
    
    private func setupUI() {
        title = "Projects"
        view.backgroundColor = .systemBackground
        
        // Add a "+" button to add new projects
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addProjectTapped)
        )
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchProjects() {
        // Use the sort descriptor to order projects by date
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        projects = coreDataStack.fetchEntities(Project.self, sortDescriptors: [sortDescriptor])
        tableView.reloadData()
    }
    
    @objc private func addProjectTapped() {
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
    
    private func createNewProject(name: String, description: String?) {
        let project = coreDataStack.createEntity(Project.self)
        project.name = name
        project.projectDescription = description
        project.createdDate = Date()
        project.status = "Active"
        
        coreDataStack.saveContext()
        fetchProjects()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProjectsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        let project = projects[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = project.name
        content.secondaryText = project.projectDescription
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // In a real app, this would navigate to a project detail screen
        let project = projects[indexPath.row]
        print("Selected project: \(project.name ?? "Unnamed")")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let project = projects[indexPath.row]
            coreDataStack.deleteEntity(project)
            projects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
