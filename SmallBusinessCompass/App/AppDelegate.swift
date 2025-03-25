//
//  AppDelegate.swift
//  SmallBusinessCompass
//
//  Created by Rob Sergent on 3/10/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize CoreData stack early
        _ = CoreDataStack.shared.persistentContainer
        print("✅ App launched successfully, CoreData initialized")
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Save changes before app terminates
        CoreDataStack.shared.saveContext()
    }
}
