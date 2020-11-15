//
//  SocketManager.swift
//  challenge
//
//  Created by Jackson Ho on 11/14/20.
//

import Foundation
import SocketIO

struct SocketIOManager {
  let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:5000/")!, config: [.log(true)])
  let socket: SocketIOClient
  init() {
    socket = manager.defaultSocket
    socket.on(clientEvent: .connect) { (data, ack) in
      print("socket connected")
    }
  }
  
  func addHandlers() {
    socket.on(clientEvent: .connect) { (data, ack) in
      print("socket connected")
    }
    
    socket.on("createRoom") { (data, ack) in
      // Check whenever the user is the leader of the room or not
      
    }
    
    socket.on("joinRoom") { (data, ack) in
      // Check whenever the user is the leader of the room or not
    }
    
    socket.on("play") { (data, ack) in
      // Check if the user is the leader of the room
    }
    
    socket.on("pause") { (data, ack) in
      // Check if the user is the leader of the room
    }
    
    socket.on("reset") { (data, ack) in
      // Check if the user is the leader of the room
    }
    
    //
    socket.on("changeLeader") { (data, ack) in
      // Change the leader of the room
    }
    
    socket.onAny { print("Got event: \($0.event), with items: \($0.items!)") }
  }
  
  func checkNameAvailable(name: String) {
    // Check whether the name is available to create a room
  }
  
}

