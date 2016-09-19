//
//  NSAttributedStringAppendTests.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

let imageForTest = UIImage(named: "robot",
                           in: Bundle(for: NSAttributedStringAppendTests.self),
                           compatibleWith: nil)!

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

        let attributes = chainString.attributes(at: chainString.length - 1, effectiveRange: nil)

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
        for (index, (expectedWidth, string)) in stringsWithTabStops.enumerated() {
            let line = UInt(#line - 2 - (stringsWithTabStops.count * 2) + (index * 2))
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
        string.append(tabStopWithSpacer: 10)
        string.append(string: "ParagraphStyle mutable promotion")
        XCTAssertNotNil(string.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle)
    }

    /// NSCoding support for StyleAttributeProvider implementations will do nothing, but basic support is present
    /// so NSKeyedArchiver does not throw an exception.
    func testDisappointingNSCodingSupport() {
        let string = styleA
            .append(string: "astringwithsomewidth")
            .append(tabStopWithSpacer: 10)
            .append(image: imageForTest)

        let data = NSKeyedArchiver.archivedData(withRootObject: string)
        var warningTriggerCount = 0
        StyleAttributeProviderHolder.supportWarningClosure = {
            warningTriggerCount += 1
        }
        let unarchivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSAttributedString
        XCTAssertNotNil(unarchivedString)
        let attributes = unarchivedString?.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes)
        let secondUnarchivedString = NSKeyedUnarchiver.unarchiveObject(with: data)
        XCTAssertNotNil(secondUnarchivedString)
        XCTAssertEqual(warningTriggerCount, 1)
    }
}
