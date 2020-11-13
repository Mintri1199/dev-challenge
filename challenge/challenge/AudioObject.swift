//
//  AudioObject.swift
//  challenge
//
//  Created by Jackson Ho on 11/13/20.
//

import Foundation
import AVFoundation
class AudioPlayer: ObservableObject {
  var fileMusic: AVAudioPlayer?
  private var fileName: String
  
  init(fileName name: String) {
    fileName = name
  }
  
  func play() {
    
  }
}
