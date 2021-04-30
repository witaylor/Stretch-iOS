//
//  DateTests.swift
//  Tests iOS
//
//  Created by Will Taylor on 10/03/2021.
//

import XCTest

class DateTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testGetComponents() throws {
    // Monday, 1st March 2021
    let monday = Date(timeIntervalSince1970: 1614556800)
    
    XCTAssertEqual(monday.get(.day), 1)
    XCTAssertEqual(monday.get(.month), 3)
    XCTAssertEqual(monday.get(.year), 2021)
  }
  
  func testDayOfWeek() throws {
    // Monday, 1st March 2021
    let monday = Date(timeIntervalSince1970: 1614556800)
    
    XCTAssertEqual(monday.dayOfWeek(), "Monday")
  }
  
  func testDayOfWeekInitial() throws {
    // Monday, 1st March 2021
    let monday = Date(timeIntervalSince1970: 1614556800)
    XCTAssertEqual(monday.dayOfWeekInitial(), "M")
  }
  
  func testDateWithOrdinal() throws {
    // Monday, 1st March 2021
    let monday = Date(timeIntervalSince1970: 1614556800)
    
    XCTAssertEqual(monday.dateWithOrdinal(), "Monday, 1st")
  }
  
  func testSubtractDays() throws {
    // Monday, 1st March 2021
    let date1 = Date(timeIntervalSince1970: 1614556800)
    
    let subtracted = date1.subtractDays(1)
    
    XCTAssertEqual(subtracted.get(.day), 28)
    XCTAssertEqual(subtracted.get(.month), 2)
    XCTAssertEqual(subtracted.get(.year), 2021)
    
  }
  
  func testIsSameDate() throws {
    
  }  
}
