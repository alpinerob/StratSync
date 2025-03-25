//
//  SceneDelegate.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/12/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Create a tab bar controller as the root
        let tabBarController = UITabBarController()
        
        // Create view controllers for each tab
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        let projectsVC = ProjectsViewController()
        projectsVC.tabBarItem = UITabBarItem(title: "Projects", image: UIImage(systemName: "folder"), tag: 1)
        let projectsNav = UINavigationController(rootViewController: projectsVC)
        
        let calendarVC = CalendarViewController()
        calendarVC.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 2)
        let calendarNav = UINavigationController(rootViewController: calendarVC)
        
        let teamVC = TeamViewController()
        teamVC.tabBarItem = UITabBarItem(title: "Team", image: UIImage(systemName: "person.3"), tag: 3)
        let teamNav = UINavigationController(rootViewController: teamVC)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        // Set the tab bar's view controllers
        tabBarController.viewControllers = [homeNav, projectsNav, calendarNav, teamNav, settingsNav]
        
        // Set the tab bar controller as the window's root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
