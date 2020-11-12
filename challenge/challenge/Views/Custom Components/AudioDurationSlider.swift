//
//  AudioDurationSlider.swift
//  challenge
//
//  Created by Jackson Ho on 11/11/20.
//

import SwiftUI

// Adapted from Aubree Quiroz: https://medium.com/better-programming/reusable-components-in-swiftui-custom-sliders-8c115914b856

struct CustomSliderComponents {
  let barLeft: CustomSliderModifier
  let barRight: CustomSliderModifier
  let knob: CustomSliderModifier
}

struct CustomSliderModifier: ViewModifier {
  enum Name {
    case barLeft
    case barRight
    case knob
  }
  
  let name: Name
  let size: CGSize
  let offset: CGFloat
  
  func body(content: Content) -> some View {
    content
      .frame(width: size.width)
      .position(x: size.width * 0.5, y: size.height * 0.5)
      .offset(x: offset)
  }
}


struct AudioDurationSlider<Component: View>: View {
  @Binding var value: Double
  var range: (Double, Double)
  var knobWidth: CGFloat?
  let viewBuilder: (CustomSliderComponents) -> Component
  
  init(value: Binding<Double>, range:(Double, Double), knobWidth: CGFloat? = nil, _ viewBuilder: @escaping (CustomSliderComponents) -> Component) {
    _value = value
    self.range = range
    self.viewBuilder = viewBuilder
    self.knobWidth = knobWidth
  }
  
  var body: some View {
    return GeometryReader { geometry in
      self.view(geometry: geometry)
    }
  }
  
  private func view(geometry: GeometryProxy) -> some View {
    let frame = geometry.frame(in: .global)
    //    let drag = DragGesture(minimumDistance: 0).onChanged({ drag in
    //      self.onDragChange(drag, frame)
    //    })
    
    let offsetX = self.getOffSetX(frame: frame)
    let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
    let barLeftSize = CGSize(width: CGFloat(offsetX + knobSize.width * 0.5), height: frame.height)
    let barRightSize = CGSize(width: frame.width - barLeftSize.width, height: frame.height)
    
    let modifiers = CustomSliderComponents(
      barLeft: CustomSliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
      barRight: CustomSliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
      knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX))
    
    // Uncomment the gesture if using functionality
    return ZStack { viewBuilder(modifiers) } //.gesture(drag)}
  }
  
  // Disable this methods unless adding more functionality later
  private func onDragChange(_ drag: DragGesture.Value, _ frame: CGRect) {
    let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
    let xRange = (min: Double(0), max: Double(width.view - width.knob))
    var value = Double(drag.startLocation.x + drag.translation.width) // knob center x
    value -= 0.5*width.knob // offset from center to leading edge of knob
    value = value > xRange.max ? xRange.max : value // limit to leading edge
    value = value < xRange.min ? xRange.min : value // limit to trailing edge
    value = value.convert(fromRange: (xRange.min, xRange.max), toRange: range)
    self.value = value
  }
  
  private func getOffSetX(frame: CGRect) -> CGFloat {
    let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
    let xRange: (Double, Double) = (0, Double(width.view - width.knob))
    let result = self.value.convert(fromRange: range, toRange: xRange)
    return CGFloat(result)
  }
}

fileprivate  struct CustomPreview: View {
  @State var value: Double = 30
  
  var body: some View {
    ZStack {
      Color(.red).edgesIgnoringSafeArea(.all)
      VStack(spacing: 30) {
        Group {
          AudioDurationSlider(value: $value, range: (0, 100), knobWidth: 10) { (modifiers: CustomSliderComponents) in
            ZStack {
              Color(.darkGray).cornerRadius(3).frame(height: 6).modifier(modifiers.barRight)
              Color(.lightGray).cornerRadius(3).frame(height: 6).modifier(modifiers.barLeft)
              
              ZStack {
                Rectangle()
                  .fill(Color(.lightGray))
                  .border(Color.black.opacity(0.3), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
              }.modifier(modifiers.knob)
            }
          }.frame(height: 25)
          
        }.frame(width:320)
      }
    }
  }
}

struct AudioDurationSlider_Previews: PreviewProvider {
  @State var value: Double = 30
  
  static var previews: some View {
    CustomPreview()
  }
}
