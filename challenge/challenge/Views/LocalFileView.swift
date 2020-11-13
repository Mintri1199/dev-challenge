//
//  LocalFileView.swift
//  challenge
//
//  Created by Jackson Ho on 11/10/20.
//

import SwiftUI
import CoreData

struct LocalFileView: View {
  // This view will list all the local sound files
  // The user can delete the sound file in this view
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FileMetadata.name, ascending: true)],
                animation: .default)
  
  private var files: FetchedResults<FileMetadata>
  
  var body: some View {
    List {
      ForEach(files) { (file) in
        HStack {
          Text(file.name!)
          
          Spacer()
          
          Image(systemName: "checkmark")
            .foregroundColor(.green)
        }
      }
      .onDelete(perform: deleteFile)
    }
  }
  
  
  private func deleteFile(offSets: IndexSet) {
    withAnimation {
      let file = files[offSets.first!]
      let manager = FileSystemManager.shared
      do {
        try manager.deleteFile(withName: file.name!)
        try PersistenceController.shared.deleteEntity(for: file)
      } catch {

        #if DEBUG
        print("Error when trying to delete file")
        print(error)
        #endif
        
      }
    }
  }
}

struct LocalFileView_Previews: PreviewProvider {
  static var previews: some View {
    LocalFileView()
  }
}
