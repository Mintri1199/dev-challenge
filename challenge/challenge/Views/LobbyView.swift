//
//  LobbyView.swift
//  challenge
//
//  Created by Jackson Ho on 11/14/20.
//

import SwiftUI
import CoreData
import SocketIO
import FirebaseStorage

struct LobbyView: View {
  
  @ObservedObject var manager = SocketIOManager()
  @Environment(\.presentationMode) var presentationMode
  @State var roomName: String = ""
  @State var nickName: String = ""
  @State private var showError: Bool = false
  @State var showSoundOption: Bool = false
  @State var fileName: String = ""
  
  init() {
    addLobbyErrorHandler()
    manager.socket.on("require_file_name") { (data, _) in
      print(data)
      
    }
    
  }
  
  var body: some View {
    VStack {
      Form{
        Section{
          TextField("Enter Nickname", text: $nickName)
          TextField("Enter Room Name", text: $roomName)
        }
      
        Section {
          Button(action: joinRoom, label: {
            Text("Join Room")
          })
          
          Button(action: createRoom, label: {
            Text("Create Room")
          }).sheet(isPresented: $showSoundOption) {
            SoundOptionView(fileName: $fileName, roomName: roomName, nickName: nickName)
          }
          
          if !fileName.isEmpty {
            let playerInstance = AudioPlayer(fileName: fileName)
            let destination = AudioControls(fileName: fileName).environmentObject(playerInstance)
            NavigationLink(destination: destination,
                           label: {
                            Text("Go to Room")
                              .onTapGesture {
                                manager.socket.emit("createRoom", ["room" : roomName, "nickName" : nickName, "fileName" : fileName])
                              }
                            
                           })
          }
        }
      }
    }
    .navigationTitle(Text("Lobby"))
    .navigationBarItems(leading: Button(action: {
      manager.socket.disconnect()
      self.presentationMode.wrappedValue.dismiss()
    }, label: {
      HStack {
        Image(systemName: "chevron.left")
        Text("Back")
          .fontWeight(.regular)
      }
    }))
    .navigationBarBackButtonHidden(true)
    .onAppear { manager.socket.connect() }
    .alert(isPresented: $manager.showError, content: createAlert)
  }
  
  private func joinRoom() {
    if roomName.isEmpty {
      manager.errorMessage = "Please enter the room name"
      manager.showError.toggle()
    } else if nickName.isEmpty {
      manager.errorMessage = "Please enter a nickname"
      manager.showError.toggle()
    } else {
      manager.socket.emit("prepareToJoin", ["room" : roomName])
      
//      manager.socket.emit("join", ["room": roomName, "nickName" : nickName ])
    }
  }
  
  private func createRoom() {
    if roomName.isEmpty {
      manager.errorMessage = "Please enter the room name"
      manager.showError.toggle()
    } else if nickName.isEmpty {
      manager.errorMessage = "Please enter a nickname"
      manager.showError.toggle()
    } else {
      showSoundOption.toggle()
    }
  }
  
  private func addLobbyErrorHandler() {
    manager.socket.on("duplicate_room_name") { (_, _) in
      manager.errorMessage = "Room name already taken"
      manager.showError.toggle()
    }
    
    manager.socket.on("room_nonexistence") { (_, _) in
      manager.errorMessage = "Room does not exist"
      manager.showError.toggle()
    }
  }
  
  private func createAlert() -> Alert {
    return Alert(title: Text("Error"), message: Text(manager.errorMessage), dismissButton: Alert.Button.cancel())
  }
  
}

struct RequireSoundView: View {
  @Binding var fileName: String
  @Binding var roomName: String
  
  var body: some View {
    VStack {
      Text("Require file")
        .font(.title)
      Text("You have to download the require file to join the room")
    }
  }
  
  
}

struct SoundOptionView: View {
  @Binding var fileName: String
  var roomName: String
  var nickName: String
  
  @Environment(\.presentationMode) var presentationMode
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FileMetadata.timeStamp, ascending: true)],
  animation: .default)
  
  private var items: FetchedResults<FileMetadata>
  
  @State private var availableFiles: [File] = []
  @State private var selectedItem: File?
  
  var body: some View {
    VStack {
      Text("Choose a sound file for the room")
        .font(.title)
      
      List {
        Section(header: Text("Downloaded")) {
          if items.isEmpty {
            Text("No downloaded files")
          } else {
            ForEach(items) { file in
              Button(action: {
                self.fileName = file.name!
                self.presentationMode.wrappedValue.dismiss()
              }) {
                Text(file.name!)
              }
            }
          }
        }
        
        Section(header: Text("Available to download")) {
          ForEach(availableFiles) { item in
            
            Button(action: { downloadSoundFile(forFile: item) }, label: {
              HStack {
                Text(item.name)
                
                Spacer()
                
                Image(systemName: "square.and.arrow.down")
              }
            })
          }
        }
      }.onAppear { updateFileList() }
    }
  }
  
  struct File: Identifiable {
    let id = UUID()
    let name: String
    let filePath: String
  }
  
  private func downloadSoundFile(forFile file: File) {
    let storage = Storage.storage()
    withAnimation {
      let filePathReference = storage.reference(withPath: file.filePath)
      
      FileSystemManager.shared.writeSoundFile(forPath: filePathReference.name) { (result) in
        switch result {
          case .success(_):
            do {
              try PersistenceController.shared.addEntity(name: file.name)
              self.fileName = file.name
              self.presentationMode.wrappedValue.dismiss()
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
    let storage = Storage.storage()
    let storageRef = storage.reference()
    storageRef.listAll { (result, error) in
      if let error = error {
        #if DEBUG
        print(error)
        #endif
        
      }
      
      let viewContext = PersistenceController.shared.container.viewContext
      
      self.availableFiles = result.items.compactMap { (itemRef) -> File? in
        let request: NSFetchRequest<FileMetadata> = FileMetadata.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", itemRef.name)
        request.fetchLimit = 1
        
        do {
          let count = try viewContext.count(for: request)
          if count == 0 {
            return File(name: itemRef.name, filePath: itemRef.fullPath)
          } else {
            return nil
          }
        } catch {
          #if DEBUG
          print("Could not fetch \(error)")
          #endif
          return nil
        }
      }
    }
  }
}
