//
//  MCDLoggerTests.swift
//  MCDLoggerTests
//
//  Created by mconintet on 5/18/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import XCTest
@testable import MCDLogger

class MCDLoggerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        MCDLogger.log(.Info, 1, 2)
        INFO(1, 2)
        DEBUG(3, 4)

        MCDLogger.includeCaller = true

        MCDLogger.log(.Info, 1, 2)
        INFO(1, 2)
        DEBUG(3, 4)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
}
