//
//  AudioObject.swift
//  challenge
//
//  Created by Jackson Ho on 11/13/20.
//

import Foundation
import AVFoundation
class AudioPlayer: ObservableObject {
  @Published var filePlayer: AVAudioPlayer?
  @Published var currentTime: TimeInterval = 0
  var duration: TimeInterval = 0
  
  func fetchFile(withName name: String) {
    let fileURL = FileSystemManager.shared.createLocalURL(name: name)
    do {
      filePlayer = try AVAudioPlayer(contentsOf: fileURL)
      currentTime = filePlayer!.currentTime
      duration = filePlayer!.duration
      filePlayer?.prepareToPlay()
    } catch {
      #if DEBUG
      print(error)
      #endif
    }
  }
}
