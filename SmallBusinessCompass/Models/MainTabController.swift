//
//  MainTabController.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        
        // Custom appearance for tab bar
        UITabBar.appearance().tintColor = .systemBlue
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    private func setupViewControllers() {
        // Dashboard Tab
        let dashboardVC = DashboardViewController()
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        dashboardNav.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "chart.pie"), tag: 0)
        
        // Projects Tab
        let projectsVC = ProjectsViewController()
        let projectsNav = UINavigationController(rootViewController: projectsVC)
        projectsNav.tabBarItem = UITabBarItem(title: "Projects", image: UIImage(systemName: "folder"), tag: 1)
        
        // Calendar Tab
        let calendarVC = CalendarViewController()
        let calendarNav = UINavigationController(rootViewController: calendarVC)
        calendarNav.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 2)
        
        // Team Tab
        let teamVC = TeamViewController()
        let teamNav = UINavigationController(rootViewController: teamVC)
        teamNav.tabBarItem = UITabBarItem(title: "Team", image: UIImage(systemName: "person.3"), tag: 3)
        
        // Settings Tab
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        viewControllers = [dashboardNav, projectsNav, calendarNav, teamNav, settingsNav]
    }
}
