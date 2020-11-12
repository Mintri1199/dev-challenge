//
//  FileSystemManager.swift
//  challenge
//
//  Created by Jackson Ho on 11/10/20.
//

import Foundation
import FirebaseStorage


class FileSystemManager {
  
  static let shared = FileSystemManager()
  
  private let storage = Storage.storage()
  private let manager = FileManager.default
  private(set) var dirPath: String = ""
  
  enum FileSystemError: String, Error {
    
    case duplicateFileName = "Attempted to download duplicate with duplicate name"
    case unableToDownload = "Unable to download file"
    case unableToDelete = "Unable to delete file at "
  }
  
  func createCustomDirectory() {
    
    let paths = manager.urls(for: .documentDirectory, in: .userDomainMask)
    print(paths)
    let documentsDirectory: String = paths.first?.absoluteString ?? ""
    
    dirPath = documentsDirectory + "Sounds/"
  }
  
  func writeSoundFile(forPath path: String, completion: @escaping (Result<URL,FileSystemError>) -> Void) {
    
    if dirPath.isEmpty {
      #if DEBUG
      print("Creating project file directory path")
      #endif
      createCustomDirectory()
      print(dirPath)
      if !manager.fileExists(atPath: dirPath) {
        try? manager.createDirectory(atPath: dirPath, withIntermediateDirectories: false, attributes: nil)
        #if DEBUG
        print("Created directory at path: \(dirPath)")
        #endif
      }
    }
    
    let fileRef = storage.reference(withPath: path)
    let localURL = URL(string: dirPath + fileRef.name)!
    
    // Check if file exist
    
    if manager.fileExists(atPath: dirPath + fileRef.name) {
      completion(.failure(.duplicateFileName))
    }
    
    print(dirPath + fileRef.name)
    
    let downloadTask = fileRef.write(toFile: localURL) { url, error in
      
      print("Finished task with error? \(error != nil)")
      
      if let error = error {
        #if DEBUG
        print(error)
        #endif
        
        completion(.failure(.unableToDownload))
      } else {
        // TAG: Print Statement
        print(url?.absoluteString as Any)
        completion(.success(url!))
      }
    }
  }
  
  func deleteFile(atPath path: String) {
    do {
      try manager.removeItem(atPath: path)
    } catch {
      #if DEBUG
      print(FileSystemError.unableToDelete.rawValue + path)
      #endif
      fatalError()
    }
  }
}
