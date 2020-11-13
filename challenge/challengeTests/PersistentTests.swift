//
//  PersistentTests.swift
//  challengeTests
//
//  Created by Jackson Ho on 11/10/20.
//

import XCTest
import CoreData
@testable import challenge

class PersistentTests: XCTestCase {
  // TODO:
  // Test FileSystemManger
  // Add the core data persistence container
  // Test adding sound file
  // Test for fetching sound file
  // Test for deleting sound file
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    
  }
  
  func testDirCreation() {
    // TODO:
    // Create a mock to test the logic
//    let tempDir = NSSearchPathForDirectoriesInDomains(.itemReplacementDirectory, .userDomainMask, true).first ?? ""
//    let constantDirPath = tempDir + "/Sounds"
//
//    let manager = FileSystemManager.shared
//
//    XCTAssertTrue(manager.dirPath.isEmpty)
//
//    manager.createCustomDirectory()
//
//    XCTAssertTrue(manager.dirPath == constantDirPath)
//
//    XCTAssertTrue(FileManager.default.fileExists(atPath: constantDirPath))
  }
  
  
  func testAddSoundFile() throws {
    // Given a sound file that converted into NSData
    // Save it into the File system
    // And create the core data entity
    // Save it into Core Data
    // Check to make sure attributes are correct
    // Check check to make sure storagePath and filePath exist
  }
  
  func testFetchSoundFile() throws {
    // Given a sound file that exist in Core Data
    // Fetch it
    // Check to make sure attributes are correct
    // Check check to make sure storagePath and filePath exist
  }
  
  func testDeleteSoundFile() throws {
    // Given a sound file that exist in Core Data and the file system
    // delete the sound file and the corresponding entity
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
