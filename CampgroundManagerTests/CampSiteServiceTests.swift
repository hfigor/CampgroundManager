//
//  CampSiteServiceTests.swift
//  CampgroundManager
//
//  Created by Frank Cipolla on 3/30/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import UIKit
import XCTest
@testable import CampgroundManager
import CoreData



class CampSiteServiceTests: XCTestCase {
  
  // MARK: - Properties
  var campSiteService: CampSiteService!
  var coreDataStack: CoreDataStack!
		
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
   
      coreDataStack = TestCoreDataStack()
      campSiteService = CampSiteService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
      
      campSiteService = nil
      coreDataStack = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
  
  func testAddCampsite() {
    let campSite = campSiteService.addCampSite(
                    1,
                    electricity: true,
                    water: true)
    XCTAssertTrue(campSite.siteNumber == 1,
                  "Site number should be 1")
    XCTAssertTrue(campSite.electricity!.boolValue,
                  "Site should have electricity")
    XCTAssertTrue(campSite.water!.boolValue,
                  "Site should have water")
  }
  
  func testRootContextIsSavedAfterAddingCampsite() {
    let derivedContext = coreDataStack.newDerivedContext()
    
    campSiteService = CampSiteService(
      managedObjectContext: derivedContext,
      coreDataStack: coreDataStack)
    
    expectation(forNotification: NSNotification.Name.NSManagedObjectContextDidSave.rawValue, object: coreDataStack.mainContext) {
      Notification in
      return true
    }
    
    let campSite =
      campSiteService.addCampSite(
        1,
        electricity: true,
        water: true)
    XCTAssertNotNil(campSite)
    
    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Save did not occur")
    }
    
  }
  
}
