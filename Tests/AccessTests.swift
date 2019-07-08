//
//  AccessTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 10/13/17.
//  Copyright © 2017 Rightpoint. All rights reserved.
//

import BonMot
import XCTest

class AccessTests: XCTestCase {

    override func setUp() {
        super.setUp()
        EBGaramondLoader.loadFontIfNeeded()
    }

    func testThatThingsThatShouldBePublicArePublic() {
        let kernKey = NSAttributedString.Key.bonMotRemovedKernAttribute
        // we care more that it's public than that it's equal to this string,
        // but might as well test it while we're here.
        XCTAssertEqual(kernKey, "com.raizlabs.bonmot.removedKernAttributeRemoved")

        let font = BONFont(name: "EBGaramond12-Regular", size: 24)!
        XCTAssertEqual(Tracking.point(10).kerning(for: nil), 10, accuracy: 0.00001)
        XCTAssertEqual(Tracking.adobe(100).kerning(for: font), 2.4, accuracy: 0.00001)
    }

}
