//
//  Persistence.swift
//  challenge
//
//  Created by Jackson Ho on 11/9/20.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "challenge")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
  }
  
  func addEntity(name: String) throws {
    let newItem = FileMetadata(context: container.viewContext)
    newItem.name = name
    newItem.timeStamp = Date()
  
    try container.viewContext.save()
  }
  
  func deleteEntity(for obj: NSManagedObject) throws {
    container.viewContext.delete(obj)
    
    try container.viewContext.save()
  }
}
