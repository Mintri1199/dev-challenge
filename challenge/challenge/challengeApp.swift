//
//  challengeApp.swift
//  challenge
//
//  Created by Jackson Ho on 11/9/20.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct challengeApp: App {
  // Inject into SwiftUI life-cycle via adaptor
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
