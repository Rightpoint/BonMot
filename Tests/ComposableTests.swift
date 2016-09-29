//
//  NSAttributedStringAppendTests.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

let testBundle = Bundle(for: NSAttributedStringAppendTests.self)
#if os(OSX)
let imageForTest = NSImage(named: "robot")!
#else
let imageForTest = UIImage(named: "robot", in: testBundle, compatibleWith: nil)!
#endif

class NSAttributedStringAppendTests: XCTestCase {

    func testImageConstructor() {
        let imageString = imageForTest.attributedString()
        let string = "\(Special.objectReplacementCharacter)"
        XCTAssertEqual(imageString.string, string)
    }

    func testBasicJoin() {
        let string = NSAttributedString.compose(with: ["A", "B", "C"], separator: NSAttributedString(string: "-"))
        XCTAssertEqual("A-B-C", string.string)
    }

    func testAttributesArePassedAlongExtend() {
        let style = BonMot(.initialAttributes(["test": "test"]))

        let chainString = NSAttributedString.compose(with: [imageForTest, "Test", imageForTest], baseStyle: style).attributedString()
        let attributes = chainString.attributes(at: chainString.length - 1, effectiveRange: nil)

        XCTAssertEqual(attributes["test"] as? String, "test")
    }

    func testTabStopsWithSpacer() {
        let stringWidth = CGFloat(115)

        let multiLineWithTabs = NSAttributedString.compose(with: [
            "astringwithsomewidth",
            Tab.spacer(10),
            "astringwithsomewidth",
            Tab.spacer(10),
            "\n",
            Tab.spacer(20),
            "astringwithsomewidth",
            Tab.spacer(20),
            "astringwithsomewidth",
            ]).attributedString()


        let imageTab = NSAttributedString.compose(with: [imageForTest, Tab.headIndent(10)])
        let stringTab = NSAttributedString.compose(with: ["astringwithsomewidth", Tab.headIndent(10)])
        let tabtabtab = NSAttributedString.compose(with: [
            Tab.spacer(10),
            Tab.spacer(10),
            Tab.headIndent(10),
            ])
        let multiTabLine = NSAttributedString.compose(with: [
            "astringwithsomewidth",
            Tab.spacer(10),
            imageForTest,
            Tab.spacer(10),
            "astringwithsomewidth",
            imageForTest,
            ]).attributedString()

        let stringsWithTabStops: [(CGFloat, NSAttributedString)] = [
            (imageForTest.size.width + 10, imageTab),
            (stringWidth + 10, stringTab),
            (30, tabtabtab),
            ((stringWidth + 10 + imageForTest.size.width) * 2, multiTabLine),
            ((stringWidth + 20) * 2, multiLineWithTabs),
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
        let style = BonMot(.initialAttributes([NSParagraphStyleAttributeName: NSParagraphStyle()]))

        let string = NSAttributedString.compose(with: [Tab.headIndent(10), "ParagraphStyle mutable promotion"], baseStyle: style)
        XCTAssertNotNil(string.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle)
    }

    func testCompositionWithChangingParagraphStyles() {
        let string = NSAttributedString.compose(with: [
            " lineSpacing "
                .styled(with: .lineSpacing(1.8)),
            " headIndent "
                .styled(with: .headIndent(10)),
            ], baseStyle: BonMot(.firstLineHeadIndent(5)))
        guard let paragraphStart = string.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil) as? NSParagraphStyle else {
            XCTFail("No paragraph style at start")
            return
        }
        guard let paragraphEnd = string.attribute(NSParagraphStyleAttributeName, at: string.length - 1, effectiveRange: nil) as? NSParagraphStyle else {
            XCTFail("No paragraph style at end")
            return
        }
        let addParagraphMergeSupport = true
        XCTAssertEqual(paragraphStart.lineSpacing, 1.8)
//        XCTAssertEqual(paragraphStart.firstLineHeadIndent, 5)

        XCTAssertEqual(paragraphEnd.headIndent, 10)
//        XCTAssertEqual(paragraphEnd.firstLineHeadIndent, 5)
    }

}
