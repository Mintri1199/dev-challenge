//
//  ContentView.swift
//  challenge
//
//  Created by Jackson Ho on 11/9/20.
//

import SwiftUI
import CoreData
import FirebaseStorage

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>
  let storage = Storage.storage()
  @State private var fileItems: [File] = []
  
  var body: some View {
    
    List {
      ForEach(fileItems) { item in
        Text(item.name)
      }
    }
    
    
    Text("Hello")
      .onAppear(perform: {
        updateList()
      })
    
    
    //        List {
    //            ForEach(items) { item in
    //                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
    //            }
    //            .onDelete(perform: deleteItems)
    //        }
    //        .toolbar {
    //            #if os(iOS)
    //            EditButton()
    //            #endif
    //
    //            Button(action: addItem) {
    //                Label("Add Item", systemImage: "plus")
    //            }
    //        }
  }
  
  private func updateList() {
    let storageRef = storage.reference()
    storageRef.listAll { (result, error) in
      if let error = error {
        // TAG: print statement
        print(error)
      }
      for item in result.items {
        fileItems.append(File(name: item.name, referencePath: item.fullPath))
      }
    }
  }
  
  private func addItem() {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()
      
      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  
  struct File: Identifiable {
    let id = UUID()
    let name: String
    let referencePath: String
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
