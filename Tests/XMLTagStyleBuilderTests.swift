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
        let styles = TagStyles(styles: ["A": styleA, "B": styleB])

        var hugeString = ""
        for _ in 0..<100 {
            hugeString.append("This is <A>A style</A> test for <B>B Style</B>.")
        }
        measure() {
            XCTAssertNotNil(try? NSAttributedString.compose(xml: hugeString, rules: [.styles(styles)]))
        }
    }

    /// Test that the ranges of the composed attributed string match what is expected
    func testComposition() {
        let styles = TagStyles(styles: ["A": styleA, "B": styleB])

        guard let attributedString = try? NSAttributedString.compose(xml: "This is <A>A style</A> test for <B>B Style</B>.", rules: [.styles(styles)]) else {
            XCTFail("No attributed string")
            return
        }
        XCTAssertEqual("This is A style test for B Style.", attributedString.string)
        let fonts: [String: BONFont] = attributedString.rangesFor(attribute: NSFontAttributeName)
        XCTAssertEqual(BONFont(name: "Avenir-Roman", size: 30)!, fonts["8:7"])
        XCTAssertEqual(BONFont(name: "Avenir-Roman", size: 20)!, fonts["25:7"])
        XCTAssert(fonts.count == 2)
    }

    /// Verify the behavior when a style is not registered
    func testMissingStyle() {
        let styles = TagStyles()
        styles.registerStyle(forName: "A", style: styleA)

        XCTAssertNotNil(try? NSAttributedString.compose(xml: "This <A>style</A> is valid", rules: [.styles(styles)]))
        XCTAssertNil(try? NSAttributedString.compose(xml: "This <B>style</B> is not registered and throws an error", rules: [.styles(styles)]))
        XCTAssertNotNil(try? NSAttributedString.compose(xml: "This <B>style</B> is not registered but is allowed", rules: [.styles(styles)], options: [.allowUnregisteredElements]))
    }

    /// Verify that the string is read when fully contained
    func testFullXML() {
        let styles = TagStyles()
        XCTAssertNotNil(try? NSAttributedString.compose(xml: "<Top>This is fully contained</Top>", rules: [.styles(styles)], options: [.allowUnregisteredElements, .doNotWrapXML]))
    }

    /// Basic test on some HTML-like behavior.
    func testHTMLish() {
        struct HTMLishStyleBuilder: XMLStyler {
            let tagStyles = ["a": styleA,
                             "p": styleA,
                             "p:foo": styleB]

            func style(forElement name: String, attributes: [String: String]) -> AttributedStringStyle? {
                var namedStyle = tagStyles[name] ?? AttributedStringStyle()
                if let htmlClass = attributes["class"] {
                    namedStyle = tagStyles["\(name):\(htmlClass)"] ?? namedStyle
                }
                if name.lowercased() == "a" {
                    if let href = attributes["href"], let url = NSURL(string: href) {
                        namedStyle.link = url
                    }
                    else {
                        print("Ignoring invalid <a \(attributes)>")
                    }
                }
                return namedStyle
            }
            func prefix(forElement name: String, attributes: [String: String]) -> NSAttributedString? { return nil }
            func suffix(forElement name: String) -> NSAttributedString? { return nil }
        }

        let styler = HTMLishStyleBuilder()
        guard let attributedString = try? NSAttributedString.compose(xml: "This <a href='http://raizlabs.com/'>Link</a>, <p>paragraph</p>, <p class='foo'>class</p> looks like HTML.", styler: styler) else {
            XCTFail("No attributed string")
            return
        }
        let expectedFonts = [
            "5:4": styleA.font!,
            "11:9": styleA.font!,
            "22:5": styleB.font!,
        ]
        let actualFonts: [String: BONFont] = attributedString.rangesFor(attribute: NSFontAttributeName)
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
