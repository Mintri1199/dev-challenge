//
//  AudioControls.swift
//  challenge
//
//  Created by Jackson Ho on 11/11/20.
//

import SwiftUI

// Adapated from Jordan Singer: https://gist.github.com/jordansinger/a7c6b076a8a1a1b80fbec63c86c97155

struct AudioControls: View {
  
  @State var currentDuration = 55
  
  var body: some View {
    VStack {
      Rectangle()
        .foregroundColor(.secondary)
        .cornerRadius(20)
        .frame(height: 320)
        
      Spacer()
      
      HStack {
        VStack(alignment: .leading) {
         Text("Title")
          .font(.title)
          .fontWeight(.semibold)
          
          Text("Artist")
            .font(.headline)
            .foregroundColor(.blue)
        }
        Spacer()
      }
      
      Spacer()
      
      VStack {
        
//        Slider(value: <#T##Binding<BinaryFloatingPoint>#>)
        
        Rectangle()
          .frame(height: 3)
          .cornerRadius(3)
          .foregroundColor(.secondary)
        
        HStack {
          // Start time & current playback time
          Text("0:00")
            .font(.caption)
            .foregroundColor(Color(UIColor.tertiaryLabel))
          
          Spacer()
          
          // End Time
          Text("4:00")
            .font(.caption)
            .foregroundColor(Color(UIColor.tertiaryLabel))
          
        }
      }
      
      Spacer()
      
      HStack {
        Spacer()
        
        Button(action: {
          // Toggle pause and play
        }, label: {
          Image(systemName: "gobackward")
            .font(.system(size: 54, weight: .bold, design: .default))
            
            .foregroundColor(.secondary)
            
        }).buttonStyle(PlainButtonStyle())
        
        Spacer()
        
        Button(action: {
          // Toggle pause and play
        }, label: {
          Image(systemName: false ? "pause.fill" : "play.fill" )
            .font(.system(size: 56, weight: .bold, design: .default))
            .foregroundColor(.secondary)
            
        }).buttonStyle(PlainButtonStyle())
        
        Spacer()
        
        
          
        
      }
    }
  }
}

struct AudioControls_Previews: PreviewProvider {
  static var previews: some View {
    AudioControls()
  }
}
