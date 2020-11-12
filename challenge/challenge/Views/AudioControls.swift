//
//  AudioControls.swift
//  challenge
//
//  Created by Jackson Ho on 11/11/20.
//

import SwiftUI

// Adapated from Jordan Singer: https://gist.github.com/jordansinger/a7c6b076a8a1a1b80fbec63c86c97155

struct AudioControls: View {
  
  @State var currentDuration: Double = 55
  
  
  var body: some View {
    VStack {
      
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
      
      VStack {
        Group {
          AudioDurationSlider(value: $currentDuration, range: (0, 100), knobWidth: 10) { (modifiers: CustomSliderComponents) in
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
      }
      
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
          //TODO: Add bindable value here
          // Toggle pause and play
        }, label: {
          Image(systemName: false ? "pause.fill" : "play.fill" )
            .font(.system(size: 56, weight: .bold, design: .default))
            .foregroundColor(.secondary)
            
        }).buttonStyle(PlainButtonStyle())
        
        Spacer()
        
      }
    }.padding(.horizontal, 20)
  }
}

struct AudioControls_Previews: PreviewProvider {
  static var previews: some View {
    AudioControls()
  }
}
