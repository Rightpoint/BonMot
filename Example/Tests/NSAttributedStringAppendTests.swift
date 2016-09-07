//
//  NSAttributedStringAppendTests.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

let imageForTest = UIImage(named: "robot",
                        inBundle: NSBundle(forClass: NSAttributedStringAppendTests.self),
                        compatibleWithTraitCollection: nil)!

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

    func testAttributesArePassedAlongChain() {
        let chainString = BonMot(.initialAttributes(["test": "test"]))
            .append(image: imageForTest)
            .append(string: "Test")
            .append(image: imageForTest)
            .append(string: "Test")

        let attributes = chainString.attributesAtIndex(chainString.length - 1, effectiveRange: nil)

        XCTAssertEqual(attributes["test"] as? String, "test")
    }

    func testTabStopsWithSpacer() {
        let stringWidth = CGFloat(115)

        let multiTabLine = BonMot()
            .append(string: "astringwithsomewidth")
            .append(tabStopWithSpacer: 10)
            .append(image: imageForTest)
            .append(tabStopWithSpacer: 10)
            .append(string: "astringwithsomewidth")
            .append(image: imageForTest)

        let stringsWithTabStops: [(CGFloat, NSAttributedString)] = [
            (imageForTest.size.width + 10,
                BonMot().append(image: imageForTest).append(tabStopWithSpacer: 10)),
            (stringWidth + 10,
                BonMot().append(string: "astringwithsomewidth").append(tabStopWithSpacer: 10)),
            ((stringWidth + 10 + imageForTest.size.width) * 2,
                multiTabLine)
        ]
        for (index, (expectedWidth, string)) in stringsWithTabStops.enumerate() {
            let line = UInt(#line - 2 - (stringsWithTabStops.count * 2) + (index * 2))
            let width = string.boundingRectWithSize(CGSize(width: CGFloat.max, height: .max),
                                                    options: .UsesLineFragmentOrigin,
                                                    context: nil
                ).width

            XCTAssertEqualWithAccuracy(expectedWidth, width, accuracy: 1.0, line: line)
        }
    }

    func testInitialParagraphStyle() {
        let string = NSMutableAttributedString(string: "Test", attributes: [NSParagraphStyleAttributeName: NSParagraphStyle()])
        XCTAssertNotNil(string.attribute(NSParagraphStyleAttributeName, atIndex: 0, effectiveRange: nil) as? NSParagraphStyle)
        string.append(tabStopWithSpacer: 10)
        string.append(string: "ParagraphStyle mutable promotion")
        XCTAssertNotNil(string.attribute(NSParagraphStyleAttributeName, atIndex: 0, effectiveRange: nil) as? NSMutableParagraphStyle)
    }
}
