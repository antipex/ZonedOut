//
//  ZonedOutTests.swift
//  ZonedOutTests
//
//  Created by Kyle Rohr on 15/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import XCTest
@testable import ZonedOut

class ZonedOutTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFirstCharacter() {
        let testString = "Foo"

        XCTAssertTrue(testString.firstCharacter == "F", "String.firstCharacter should return F.")
    }

    func testUserProperties() {
        let testUser = User(
            userId: 99,
            username: "artvandelay",
            email: "artvandelay@antipex.com",
            firstName: "Art",
            lastName: "Vandelay",
            timeZone: TimeZone(abbreviation: "PST")
        )

        XCTAssertTrue(testUser.fullName == "Art Vandelay", "User.fullName should be Art Vandelay")
        XCTAssertTrue(testUser.initials == "AV", "User.initials should be AV")
    }

    func testTimeZoneExtensions() {
        guard let timeZone = TimeZone(abbreviation: "PST") else {
            XCTFail("Could not create a time zone with abbreviation PST")
            return
        }

        let expectedDisplayName = "America/Los Angeles"

        XCTAssertTrue(timeZone.displayName == expectedDisplayName, "NSTimeZone.displayName should be \(expectedDisplayName)")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
