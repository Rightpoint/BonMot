//
//  NSAttributedStringAppendTests.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

let testBundle = Bundle(for: NSAttributedStringAppendTests.self)
let imageForTest = UIImage(named: "robot", in: testBundle, compatibleWith: nil)!

class NSAttributedStringAppendTests: XCTestCase {

    func testImageConstructor() {
        let imageString = NSAttributedString(image: imageForTest)
        let string = "\(Special.objectReplacementCharacter)"
        XCTAssertEqual(imageString.string, string)
    }

    func testBasicJoin() {
        let parts = [NSAttributedString(string: "A"), NSAttributedString(string: "B"), NSAttributedString(string: "C")]
        let string = NSAttributedString(attributedStrings: parts, separator: NSAttributedString(string: "-"))
        XCTAssertEqual("A-B-C", string.string)
    }

    func testAttributesArePassedAlongAppend() {
        let chainString = BonMot(.initialAttributes(["test": "test"])).attributedString(from: imageForTest)
        chainString.extend(with: "Test")
        chainString.extend(with: imageForTest)
        chainString.extend(with: "Test")

        let attributes = chainString.attributes(at: chainString.length - 1, effectiveRange: nil)

        XCTAssertEqual(attributes["test"] as? String, "test")
    }

    func testTabStopsWithSpacer() {
        let stringWidth = CGFloat(115)

        let multiTabLine = NSMutableAttributedString()
        multiTabLine.extend(with: "astringwithsomewidth")
        multiTabLine.extend(withTabSpacer: 10)
        multiTabLine.extend(with: imageForTest)
        multiTabLine.extend(withTabSpacer: 10)
        multiTabLine.extend(with: "astringwithsomewidth")
        multiTabLine.extend(with: imageForTest)

        let stringTab = NSMutableAttributedString(string: "astringwithsomewidth")
        stringTab.extend(withTabSpacer: 10)

        let imageTab = NSMutableAttributedString(image: imageForTest)
        imageTab.extend(withTabSpacer: 10)

        let stringsWithTabStops: [(CGFloat, NSAttributedString)] = [
            (imageForTest.size.width + 10, imageTab),
            (stringWidth + 10, stringTab),
            ((stringWidth + 10 + imageForTest.size.width) * 2, multiTabLine)
        ]
        for (index, (expectedWidth, string)) in stringsWithTabStops.enumerated() {
            let line = UInt(#line - 2 - stringsWithTabStops.count + index)
            let width = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude),
                                            options: .usesLineFragmentOrigin,
                                            context: nil
                ).width

            XCTAssertEqualWithAccuracy(expectedWidth, width, accuracy: 1.0, line: line)
        }
    }

    func testInitialParagraphStyle() {
        let string = NSMutableAttributedString(string: "Test", attributes: [NSParagraphStyleAttributeName: NSParagraphStyle()])
        XCTAssertNotNil(string.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil) as? NSParagraphStyle)
        string.extend(withTabSpacer: 10)
        string.extend(with: "ParagraphStyle mutable promotion")
        XCTAssertNotNil(string.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle)
    }
}
