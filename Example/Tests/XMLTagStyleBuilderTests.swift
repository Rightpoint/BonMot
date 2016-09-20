//
//  XMLTagStyleBuilderTests.swift
//
//  Created by Brian King on 8/29/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

class XMLTagStyleBuilderTests: XCTestCase {

    /// There has been concerns about NSXMLParser performance. This is a baseline test,
    /// but doesn't mean much without a comparision
    func testBasicParserPerformance() {
        let styles = TagStyles()
        styles.registerStyle(forName: "A", style: styleA)
        styles.registerStyle(forName: "B", style: styleB)

        var hugeString = ""
        for _ in 0..<100 {
            hugeString.append("This is <A>A style</A> test for <B>B Style</B>.")
        }
        measure() {
            XCTAssertNotNil(try? NSAttributedString(fromXML: hugeString, styles: styles))
        }
    }

    /// Test that the ranges of the composed attributed string match what is expected
    func testComposition() {
        let styles = TagStyles()
        styles.registerStyle(forName: "A", style: styleA)
        styles.registerStyle(forName: "B", style: styleB)

        guard let attributedString = try? NSAttributedString(fromXML: "This is <A>A style</A> test for <B>B Style</B>.", styles: styles) else {
            XCTFail("No attributed string")
            return
        }
        XCTAssertEqual("This is A style test for B Style.", attributedString.string)
        let fonts: [String: UIFont] = attributedString.rangesFor(attribute: NSFontAttributeName)
        XCTAssertEqual(UIFont(name: "Avenir-Roman", size: 30)!, fonts["8:7"])
        XCTAssertEqual(UIFont(name: "Avenir-Roman", size: 20)!, fonts["25:7"])
        XCTAssert(fonts.count == 2)
    }

    /// Verify the behavior when a style is not registered
    func testMissingStyle() {
        let styles = TagStyles()
        styles.registerStyle(forName: "A", style: styleA)

        XCTAssertNotNil(try? NSAttributedString(fromXML: "This <A>style</A> is valid", styles: styles))
        XCTAssertNil(try? NSAttributedString(fromXML: "This <B>style</B> is not registered and throws an error", styles: styles))
        XCTAssertNotNil(try? NSAttributedString(fromXML: "This <B>style</B> is not registered but is allowed", styles: styles, options: [.allowUnregisteredElements]))
    }

    /// Verify that the string is read when fully contained
    func testFullXML() {
        let styles = TagStyles()
        XCTAssertNotNil(try? NSAttributedString(fromXML: "<Top>This is fully contained</Top>", styles: styles, options: [.allowUnregisteredElements, .doNotWrapXML]))
    }

    /// Basic test on some HTML-like behavior.
    func testHTMLish() {
        let tagStyles = TagStyles()
        tagStyles.registerStyle(forName: "a", style: styleA)
        tagStyles.registerStyle(forName: "p", style: styleA)
        tagStyles.registerStyle(forName: "p:foo", style: styleB)
        guard let attributedString = try? NSAttributedString(fromXML: "This <a href='http://raizlabs.com/'>Link</a>, <p>paragraph</p>, <p class='foo'>class</p> looks like HTML.", styles: tagStyles, options: [.HTMLish]) else {
            XCTFail("No attributed string")
            return
        }
        let expectedFonts = [
            "5:4": styleA.font!,
            "11:9": styleA.font!,
            "22:5": styleB.font!,
        ]
        let actualFonts: [String: UIFont] = attributedString.rangesFor(attribute: NSFontAttributeName)
        XCTAssertEqual(expectedFonts, actualFonts)
        XCTAssertEqual(["5:4": NSURL(string: "http://raizlabs.com/")!], attributedString.rangesFor(attribute: NSLinkAttributeName))
    }

    /// Ensure that the singleton is configured with some adaptive styles for easy Dynamic Type support.
    func testDefaultTagStyles() {
        XCTAssertNotNil(TagStyles.shared.style(forName: "body"))
        XCTAssertNotNil(TagStyles.shared.style(forName: "control"))
        XCTAssertNotNil(TagStyles.shared.style(forName: "preferred"))
    }
    
}
