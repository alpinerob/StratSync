//
//  OtherViewControllers.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import UIKit

// Simplified stubs for other main controllers
class CalendarViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        view.backgroundColor = .systemBackground
    }
}

class TeamViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Team"
        view.backgroundColor = .systemBackground
    }
}

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Detail View Controllers

class ProjectDetailViewController: UIViewController {
    
    private let project: Project
    
    init(project: Project) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = project.name
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        // Simple UI for project details display
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = "Project: \(project.name ?? "")"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description: \(project.projectDescription ?? "")"
        descriptionLabel.numberOfLines = 0
        
        let dateLabel = UILabel()
        if let date = project.creationDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            dateLabel.text = "Created: \(formatter.string(from: date))"
        }
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(dateLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
