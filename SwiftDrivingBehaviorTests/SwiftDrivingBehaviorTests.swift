//
//  SwiftDrivingBehaviorTests.swift
//  SwiftDrivingBehaviorTests
//
//  Created by Preuttipan Janpen on 6/12/2562 BE.
//  Copyright © 2562 preuttipan. All rights reserved.
//

import XCTest
@testable import SwiftDrivingBehavior

class SwiftDrivingBehaviorTests: XCTestCase {

    var testCalculation: Calculation!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.testCalculation = Calculation()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasicMethod1() {
        let result = self.testCalculation.plus(a: 1, b: 2)
        XCTAssertTrue(result == 3)
    }
    
    func testBasicMethod2() {
        let result = self.testCalculation.plus(a: 1, b: 2)
        XCTAssertTrue(result == 3)
    }
    
    func testBasicMethod3() {
        let result = self.testCalculation.plus(a: 1, b: 2)
        XCTAssertTrue(result == 3)
    }

}
