//
//  LobbyView.swift
//  challenge
//
//  Created by Jackson Ho on 11/14/20.
//

import SwiftUI

struct LobbyView: View {
  
  let socketManager = SocketIOManager()
  @State private var roomName: String = ""
  @State private var username: String = ""
  var body: some View {
    VStack {
      
      Form{
        Section{
          TextField("Enter Your Name", text: $username)
          TextField("Enter Room Name", text: $roomName)
        }
      
        Section {
          Button(action: {
            // Join Room with the given name
            socketManager.socket.emit("join", ["room": roomName, "username" : username ])
          }, label: {
            Text("Join Room")
          })
          Button(action: {
            // Create Room with the given name
            socketManager.socket.emit("createRoom", ["room": roomName, "username" : username ])
          }, label: {
            Text("Create Room")
          })
        }
        
        Section {
          Button("Leave Room") {
            socketManager.socket.emit("leave", ["room": roomName, "username" : username ])
          }
        }
      }
      
    }
    .navigationTitle(Text("Lobby"))
    .onAppear { socketManager.manager.connect() }
    .onDisappear{ socketManager.manager.disconnect() }
  }
}
