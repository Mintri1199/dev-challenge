//
//  SocketManager.swift
//  challenge
//
//  Created by Jackson Ho on 11/14/20.
//

import Foundation
import SocketIO

class SocketIOManager: ObservableObject {
  
  private let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:5000/")!, config: [.log(true)])
  
  let socket: SocketIOClient
    
  var errorMessage: String = ""
  @Published var showError: Bool = false
  @Published var isLeader: Bool = false {
    didSet {
      if isLeader {
        print("is now the leader")
      } else {
        print("is not the leader")
      }
    }
  }
  init() {
    socket = manager.defaultSocket
    socket.on(clientEvent: .connect) { (data, ack) in
      print("socket connected")
    }
    
    socket.on("changeLeader") { (data, ack) in
      self.isLeader = true
    }
    
  }
  
  func addHandlers() {
    socket.on(clientEvent: .connect) { (data, ack) in
      print("socket connected")
    }
    
    socket.on("play") { (data, ack) in
      // Check if the user is the leader of the room
      if !self.isLeader {
        return
      }
    }
    
    socket.on("pause") { (data, ack) in
      // Check if the user is the leader of the room
      if !self.isLeader {
        return
      }
    }
    
    socket.on("reset") { (data, ack) in
      // Check if the user is the leader of the room
      if !self.isLeader {
        return
      }
    }
    
    socket.onAny { print("Got event: \($0.event), with items: \($0.items!)") }
    
  }
  
  func checkNameAvailable(name: String) {
    // Check whether the name is available to create a room
  }
  
}

