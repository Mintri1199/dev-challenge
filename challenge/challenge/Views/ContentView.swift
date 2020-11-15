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
  // Core Data View Context
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FileMetadata.timeStamp, ascending: true)],
                animation: .default)
  
  private var items: FetchedResults<FileMetadata>
  
  let storage = Storage.storage()
  @State private var fileItems: [File] = []
  
  var body: some View {
    NavigationView {
      
      List {
        
        Section(header: Text("Downloaded")) {
          if items.isEmpty {
            Text("No downloaded files")
          } else {
            ForEach(items) { file in
              let playerInstance = AudioPlayer(fileName: file.name!)
              let destination = AudioControls(fileName: file.name!).environmentObject(playerInstance)
              
              NavigationLink(destination: destination) {
                Text(file.name!)
              }
            }
          }
        }
        
        Section(header: Text("Available to download")) {
          ForEach(fileItems) { item in
            Button(action: { item.downloaded ? print("File: \(item.name) is already downloaded") : downloadSoundFile(forFile: item) }, label: {
              HStack {
                Text(item.name)
                
                Spacer()
                
                Image(systemName: "square.and.arrow.down")
              }
            })
          }
        }
        
      }.navigationBarItems(leading: NavigationLink(destination: LocalFileView().environment(\.managedObjectContext, viewContext)) {
        Image(systemName: "folder")
      }, trailing:
        NavigationLink(destination: LobbyView()) {
          Text("Lobby")
        })
    }.onAppear {
      updateFileList()
      doubleCheckCoreData()
    }
  }
  
  struct File: Identifiable {
    let id = UUID()
    let name: String
    let filePath: String
    var downloaded: Bool = false
  }
  
  private func downloadSoundFile(forFile file: File) {
    withAnimation {
      let filePathReference = storage.reference(withPath: file.filePath)
      
      FileSystemManager.shared.writeSoundFile(forPath: filePathReference.name) { (result) in
        switch result {
          case .success(_):
            do {
              try PersistenceController.shared.addEntity(name: file.name)
            } catch {
              #if DEBUG
              print("unable to create file metadata in Core Data")
              #endif
              
              try! FileSystemManager.shared.deleteFile(withName: file.name)
            }
            
          case let .failure(error):
            #if DEBUG
            print("Unable to write for file: \(filePathReference.name)")
            print("Error: \(error)")
            #endif
        }
      }
    }
  }
  
  private func updateFileList() {
    let storageRef = storage.reference()
    storageRef.listAll { (result, error) in
      if let error = error {
        #if DEBUG
        print(error)
        #endif
        
      }
      for item in result.items {
        fileItems.append(File(name: item.name, filePath: item.fullPath))
      }
    }
  }
  
  private func doubleCheckCoreData() {
    let doesNotExists = items.compactMap { !FileSystemManager.shared.checkExist(fileName: $0.name!) ? $0 : nil }
    for entity in doesNotExists {
      try! PersistenceController.shared.deleteEntity(for: entity)
    }
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
    ContentView()
  }
}
