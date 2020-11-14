//
//  AudioObject.swift
//  challenge
//
//  Created by Jackson Ho on 11/13/20.
//

import Foundation
import AVFoundation
class AudioPlayer: ObservableObject {
  @Published var filePlayer: AVAudioPlayer
  
  init(fileName: String) {
    let fileURL = FileSystemManager.shared.createLocalURL(name: fileName)
    filePlayer = try! AVAudioPlayer(contentsOf: fileURL)
    filePlayer.prepareToPlay()
  }
}
