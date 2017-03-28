//
//  CamperServiceTests.swift
//  CampgroundManager
//
//  Created by Frank Cipolla on 3/27/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

@testable import CampgroundManager
import XCTest

class CamperServiceTests: XCTestCase {
  
  // MARK: - Properties
  var camperService: CamperService!
  var coreDataStack: CoreDataStack!

		
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        coreDataStack = TestCoreDataStack()
        camperService = CamperService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
      
      camperService = nil
      coreDataStack = nil
    }
    
 
  
  // MARK: - Test methods
  
  func testAddCamper(){
    let camper = camperService.addCamper("Bacon Lover", phoneNumber: "910-543-9000")
    XCTAssertNotNil(camper, "Camper should not be nil")
    XCTAssertTrue(camper?.fullName == "Bacon Lover")
    XCTAssertTrue(camper?.phoneNumber == "910-543-9000")
  }
  
  func testRootContextIsSavedAfterAddingCamper() {
    // 1
    let derivedContext = coreDataStack.newDerivedContext()
    camperService = CamperService (
      managedObjectContext: derivedContext,
      coreDataStack: coreDataStack)
    
    // 2
    expectation(forNotification:
      NSNotification.Name.NSManagedObjectContextDidSave.rawValue,
                object: coreDataStack.mainContext) {
                  notification in
                  return true
    }
    
    // 3
    let camper = camperService.addCamper("Bacon Lover",
                                         phoneNumber: "910-543-9000")
    XCTAssertNotNil(camper)
    
    // 4
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Save did not occur")
    }
  }
}
