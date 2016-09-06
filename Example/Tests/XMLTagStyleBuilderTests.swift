//
//  XMLTagStyleBuilderTests.swift
//
//  Created by Brian King on 8/29/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
@testable import FinePrint

class XMLTagStyleBuilderTests: XCTestCase {

    /// There has been concerns about NSXMLParser performance. This is a baseline test,
    /// but doesn't mean much without a comparision
    func testBasicParserPerformance() {
        let styles = TagStyles()
        styles.registerStyle(forName: "A", style: styleA)
        styles.registerStyle(forName: "B", style: styleB)

        var hugeString = ""
        for _ in 0..<100 {
            hugeString.appendContentsOf("This is <A>A style</A> test for <B>B Style</B>.")
        }
        measureBlock() {
            XCTAssertNotNil(try? styles.attributedString(fromXMLFragment: hugeString))
        }
    }

    /// Test that the ranges of the composed attributed string match what is expected
    func testComposition() {
        let styles = TagStyles()
        styles.registerStyle(forName: "A", style: styleA)
        styles.registerStyle(forName: "B", style: styleB)

        guard let attributedString = try? styles.attributedString(fromXMLFragment: "This is <A>A style</A> test for <B>B Style</B>.") else {
            XCTFail("No attributed string")
            return
        }
        XCTAssertEqual("This is A style test for B Style.", attributedString.string)
        var ranges = Array<NSRange>()
        attributedString.enumerateAttribute(
            StyleAttributeProviderAttributeName,
            inRange: NSRange(location: 0, length: attributedString.length),
            options: []) { obj, range, stop in
                ranges.append(range)
        }
        let expected = [
            NSRange(location: 0, length: 8),
            NSRange(location: 8, length: 7),
            NSRange(location: 15, length: 10),
            NSRange(location: 25, length: 7),
            NSRange(location: 32, length: 1),
        ]
        XCTAssertEqual(expected, ranges)

        let fonts: [String: UIFont] = attributedString.attributeValuesByRanges(NSFontAttributeName)
        XCTAssertEqual(UIFont(name: "Avenir-Roman", size: 30)!, fonts["8:7"])
        XCTAssertEqual(UIFont(name: "Avenir-Roman", size: 20)!, fonts["25:7"])
        XCTAssert(fonts.count == 2)
    }

    /// Verify the behavior when a style is not registered
    func testMissingStyle() {
        let styles = TagStyles()
        styles.registerStyle(forName: "A", style: styleA)

        XCTAssertNotNil(try? styles.attributedString(fromXMLFragment: "This <A>style</A> is valid"))
        XCTAssertNil(try? styles.attributedString(fromXMLFragment: "This <B>style</B> is not registered and throws an error"))
        XCTAssertNotNil(try? styles.attributedString(fromXMLFragment: "This <B>style</B> is not registered but is allowed", options: [.allowUnregisteredElements]))
    }

    /// Verify that the string is read when fully contained
    func testFullXML() {
        let styles = TagStyles()
        XCTAssertNotNil(try? styles.attributedString(fromXMLFragment: "<Top>This is fully contained</Top>", options: [.allowUnregisteredElements, .doNotWrapXML]))
    }

    /// Basic test on some HTML-like behavior.
    func testHTMLish() {
        let tagStyles = TagStyles()
        tagStyles.registerStyle(forName: "a", style: styleA)
        tagStyles.registerStyle(forName: "p", style: styleA)
        tagStyles.registerStyle(forName: "p:foo", style: styleB)
        guard let attributedString = try? tagStyles.attributedString(fromXMLFragment: "This <a href='http://raizlabs.com/'>Link</a>, <p>paragraph</p>, <p class='foo'>class</p> looks like HTML.", options: [.HTMLish]) else {
            XCTFail("No attributed string")
            return
        }
        let expectedFonts = [
            "5:4": styleA.font!,
            "11:9": styleA.font!,
            "22:5": styleB.font!,
        ]
        XCTAssertEqual(expectedFonts, attributedString.attributeValuesByRanges(NSFontAttributeName))
        XCTAssertEqual(["5:4": NSURL(string: "http://raizlabs.com/")!], attributedString.attributeValuesByRanges(NSLinkAttributeName))
    }

    /// Ensure that the singleton is configured with some adaptive styles for easy Dynamic Type support.
    func testDefaultTagStyles() {
        XCTAssertNotNil(TagStyles.shared.style(forName: "body"))
        XCTAssertNotNil(TagStyles.shared.style(forName: "control"))
        XCTAssertNotNil(TagStyles.shared.style(forName: "preferred"))
    }
    
}
