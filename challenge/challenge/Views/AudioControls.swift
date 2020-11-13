//
//  AudioControls.swift
//  challenge
//
//  Created by Jackson Ho on 11/11/20.
//

import SwiftUI

// Adapted from Jordan Singer: https://gist.github.com/jordansinger/a7c6b076a8a1a1b80fbec63c86c97155

struct AudioControls: View {
  
  var fileName: String
  @State var currentDuration: Double = 0
  @State var isPlaying: Bool = false
  @ObservedObject var audioPlayer = AudioPlayer()
  
  var body: some View {
    VStack {
      
      Spacer()
      
      HStack {
        Text("Title")
          .font(.title)
          .fontWeight(.semibold)
        
        Spacer()
      }
      
      VStack {
        Group {
          AudioDurationSlider(value: $currentDuration, range: (0, audioPlayer.duration), knobWidth: 10) { (modifiers: CustomSliderComponents) in
            ZStack {
              Color(.darkGray).cornerRadius(3).frame(height: 6).modifier(modifiers.barRight)
              Color(.lightGray).cornerRadius(3).frame(height: 6).modifier(modifiers.barLeft)
              
              ZStack {
                Rectangle()
                  .fill(Color(.lightGray))
                  .border(Color.black.opacity(0.3), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
              }.modifier(modifiers.knob)
            }
          }.frame(height: 12)
          
          HStack {
            Text(convertSecondsToTimeStr(seconds: currentDuration))
              .font(.caption)
              .foregroundColor(Color(UIColor.tertiaryLabel))
            
            Spacer()
            
            Text(convertSecondsToTimeStr(seconds: audioPlayer.duration))
              .font(.caption)
              .foregroundColor(Color(UIColor.tertiaryLabel))
            
          }
        }
      }
      
      HStack {
        Spacer()
        
        Button(action: {
          audioPlayer.filePlayer!.currentTime = 0
          audioPlayer.filePlayer?.play()
        }, label: {
          Image(systemName: "gobackward")
            .font(.system(size: 54, weight: .bold, design: .default))
            .foregroundColor(.secondary)
          
        }).buttonStyle(PlainButtonStyle())
        
        Spacer()
        
        Button(action: {
          if audioPlayer.filePlayer!.isPlaying {
            audioPlayer.filePlayer?.pause()
            isPlaying.toggle()
            //TODO: remove the operation here to stop updating the slider
            
          } else {
            playAction()
            //TODO: Add operation here to continuously update the slider
          }
        }, label: {
          Image(systemName: isPlaying ? "pause.fill" : "play.fill" )
            .font(.system(size: 56, weight: .bold, design: .default))
            .foregroundColor(.secondary)
          
        }).buttonStyle(PlainButtonStyle())
        
        Spacer()
        
      }
    }.padding(.horizontal, 20).onAppear {
      self.audioPlayer.fetchFile(withName: self.fileName)
      self.currentDuration = self.audioPlayer.filePlayer!.currentTime
    }
  }
  
  private func playAction() {
    audioPlayer.filePlayer?.play()
    isPlaying.toggle()
  }
  
  
  
  private func convertSecondsToTimeStr(seconds: TimeInterval) -> String {
    let closestAmount = Int(seconds)
    let (hours, minutes, seconds) = (closestAmount / 3600, (closestAmount % 3600) / 60, (closestAmount % 3600) % 60)
    
    var str = hours > 0 ? "\(hours)" : ""
    str = minutes > 0 ? str + " \(minutes)" : str
    str = seconds > 0 ? str + " \(seconds)" : str
    return str.isEmpty ? "0:00" : str
  }
}

struct AudioControls_Previews: PreviewProvider {
  static var previews: some View {
    AudioControls(fileName: "Dreams.mp3")
  }
}
