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
  
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FileMetadata.name, ascending: true)],
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
              Text(file.name!)
                .onTapGesture { print(file) }
            }
          }
        }
        
        
        Section(header: Text("Available to download")) {
          ForEach(fileItems) { item in
            Button(action: { item.downloaded ? print("File: \(item.name) is already downloaded") : downloadSoundFile(forFile: item) }, label: {
              HStack {
                Text(item.name)
                
                Spacer()
                
                if item.downloaded {
                  Image(systemName: "checkmark")

                } else {
                  Image(systemName: "square.and.arrow.down")
                }
              }
            })
          }
        }
        
      }
      .navigationBarItems(trailing: NavigationLink(destination: LocalFileView().environment(\.managedObjectContext, viewContext)) {
        Image(systemName: "folder")
      })
    }.onAppear(perform: updateFileList)
  }
  
  struct File: Identifiable {
    let id = UUID()
    let name: String
    let filePath: String
    var downloaded: Bool = false
  }
  
  private func downloadSoundFile(forFile file: File) {
    print("tap for file: \(file.name)")
    withAnimation {
      let filePathReference = storage.reference(withPath: file.filePath)
      
      FileSystemManager.shared.writeSoundFile(forPath: filePathReference.name) { (result) in
        switch result {
          case let .success(url):
            do {
              try PersistenceController.shared.addEntity(name: file.name,
                                                     storagePath: filePathReference.fullPath,
                                                     localPath: url.absoluteString)
              
              print("Save file into FileSystem and Core Data")
            } catch {
              #if DEBUG
              print("unable to create file metadata in Core Data")
              #endif
              
              FileSystemManager.shared.deleteFile(atPath: url.absoluteString)
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
        // TAG: print statement
        print(error)
      }
      for item in result.items {
        fileItems.append(File(name: item.name, filePath: item.fullPath))
      }
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
