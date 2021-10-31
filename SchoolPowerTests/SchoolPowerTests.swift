//
//  SchoolPowerTests.swift
//  SchoolPowerTests
//
//  Created by carbonyl on 2017-06-21.
//  Copyright © 2017 CarbonylGroup.com. All rights reserved.
//

import XCTest
@testable import SchoolPower

class SchoolPowerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSortTerms() {
        let terms = ["L1", "F2", "E1", "F1", "S1", "F3", "E2", "F4", "L2", "X2"]
        XCTAssertEqual(
            Utils.sortTerm(terms: terms),
            ["F4", "F3", "F2", "L2", "E2", "X2", "F1", "L1", "E1", "S1"]
        )
        let sortableTerms: [SortableTerm] = terms.map({ (key) -> SortableTerm in
            SortableTerm(raw: key)
        })
        XCTAssertEqual(
            Utils.sortTermsByLatest(terms: sortableTerms),
            ["F4", "F3", "F2", "F1", "L2", "L1", "E2", "E1", "S1", "X2"]
        )
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
