//
//  AccessTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 10/13/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import BonMot
import XCTest

class AccessTests: XCTestCase {

    func testThatThingsThatShouldBePublicArePublic() {
        let kernKey = NSAttributedStringKey.bonMotRemovedKernAttribute
        // we care more that it's public than that it's equal to this string,
        // but might as well test it while we're here.
        XCTAssertEqual(kernKey, "com.raizlabs.bonmot.removedKernAttributeRemoved")
    }

}
