//
//  LocalFileView.swift
//  challenge
//
//  Created by Jackson Ho on 11/10/20.
//

import SwiftUI

struct LocalFileView: View {
  // This view will list all the local sound files
  // The user can delete the sound file in this view
  
  @Environment(\.managedObjectContext) private var viewContext
  
  var body: some View {
    Text("Hello There")
      .navigationTitle("Downloaded Files")
  }
}

struct LocalFileView_Previews: PreviewProvider {
  static var previews: some View {
    LocalFileView()
  }
}
