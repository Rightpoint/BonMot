//
//  OptionalAsArrayTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 11/3/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
@testable import BonMot

class OptionalAsArrayTests: XCTestCase {

    func testOptionalAsArray() {
        let noneThing: Int? = nil
        XCTAssertTrue(noneThing.asArray.isEmpty)

        let someThing: Int? = 1
        XCTAssertEqual(someThing.asArray.count, 1)
        XCTAssertEqual(someThing.asArray[0], 1)
    }

}
