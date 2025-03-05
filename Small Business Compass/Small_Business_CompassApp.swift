//
//  Small_Business_CompassApp.swift
//  Small Business Compass
//
//  Created by Rob Sergent on 3/5/25.
//

import SwiftUI

@main
struct Small_Business_CompassApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
