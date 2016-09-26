//
//  NSAttributedStringDebugTests.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

class NSAttributedStringDebugTests: XCTestCase {

    func testDebugRepresentationReplacements() {
        let testCases: [(String, String)] = [
            ("BonMot", "BonMot"),
            ("Bon\tMot", "Bon{tab}Mot"),
            ("Bon\nMot", "Bon{lineFeed}Mot"),
            ("it ignores spaces", "it ignores spaces"),
            ("Pilcrow¶", "Pilcrow¶"),
            ("Floppy💾Disk", "Floppy💾Disk"),
            ("\u{000A1338}A\u{000A1339}", "{unassignedUnicode<A1338>}A{unassignedUnicode<A1339>}"),
            ("neonسلام🚲\u{000A1338}₫\u{000A1339}", "neonسلام🚲{unassignedUnicode<A1338>}₫{unassignedUnicode<A1339>}"),
        ]
        for (index, testCase) in testCases.enumerated() {
            let line = UInt(#line - testCases.count - 2 + index)
            let debugString = NSAttributedString(string: testCase.0).debugRepresentation.string
            XCTAssertEqual(testCase.1, debugString, line: line)
        }
    }

    func testImageRepresentationHasSize() {
        XCTAssertEqual(NSAttributedString(image: imageForTest).debugRepresentation.string, "{image36x36}")
    }

    func testThatNSAttributedStringSpeaksUTF16() {
        // We don't actually need to test this - just demonstrating how it works
        let string = "\u{000A1338}A"
        XCTAssertEqual(string.characters.count, 2)
        XCTAssertEqual(string.utf8.count, 5)
        XCTAssertEqual(string.utf16.count, 3)
        let mutableAttributedString = NSMutableAttributedString(string: string)
        XCTAssertEqual(mutableAttributedString.string, string)
        mutableAttributedString.replaceCharacters(in: NSMakeRange(0, 2), with: "foo")
        XCTAssertEqual(mutableAttributedString.string, "fooA")
    }

}
