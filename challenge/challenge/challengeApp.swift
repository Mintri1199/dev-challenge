//
//  challengeApp.swift
//  challenge
//
//  Created by Jackson Ho on 11/9/20.
//

import SwiftUI

@main
struct challengeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
