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
  
  enum FileSystemError: String, Error {
    
    case duplicateFileName = "Attempted to download duplicate with duplicate name"
    case unableToDownload = "Unable to download file"
    case unableToDelete = "Unable to delete file at "
  }
  
  func writeSoundFile(forPath path: String, completion: @escaping (Result<URL,FileSystemError>) -> Void) {
    let fileRef = storage.reference(withPath: path)
    let localURL = createLocalURL(name: fileRef.name)
    
    if manager.fileExists(atPath: localURL.path) {
      return completion(.failure(.duplicateFileName))
    }
    
    let downloadTask = fileRef.write(toFile: localURL) { url, error in
      
      print("Finished task with error? \(error != nil)")
      
      if let error = error {
        #if DEBUG
        print(error)
        #endif
        
        completion(.failure(.unableToDownload))
      } else {
        completion(.success(url!))
      }
    }
  }
  
  func deleteFile(withName name: String) throws {
    let localURL = createLocalURL(name: name)
    try manager.removeItem(atPath: localURL.path)
  }
  
  func createLocalURL(name: String) -> URL {
    var localURL = try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    localURL.appendPathComponent("Sounds")
    print(localURL.path)
    localURL.appendPathComponent(name)
    return localURL
  }
}
