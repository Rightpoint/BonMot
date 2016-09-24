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
            XCTAssertNotNil(try? NSAttributedString(fromXML: hugeString, styler: SimpleXMLStyler(tagStyles: styles)))
        }
    }

    /// Test that the ranges of the composed attributed string match what is expected
    func testComposition() {
        let styles = TagStyles()
        styles.registerStyle(forName: "A", style: styleA)
        styles.registerStyle(forName: "B", style: styleB)

        guard let attributedString = try? NSAttributedString(fromXML: "This is <A>A style</A> test for <B>B Style</B>.", styler: SimpleXMLStyler(tagStyles: styles)) else {
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

        XCTAssertNotNil(try? NSAttributedString(fromXML: "This <A>style</A> is valid", styler: SimpleXMLStyler(tagStyles: styles)))
        XCTAssertNil(try? NSAttributedString(fromXML: "This <B>style</B> is not registered and throws an error", styler: SimpleXMLStyler(tagStyles: styles)))
        XCTAssertNotNil(try? NSAttributedString(fromXML: "This <B>style</B> is not registered but is allowed", styler: SimpleXMLStyler(tagStyles: styles), options: [.allowUnregisteredElements]))
    }

    /// Verify that the string is read when fully contained
    func testFullXML() {
        let styles = TagStyles()
        XCTAssertNotNil(try? NSAttributedString(fromXML: "<Top>This is fully contained</Top>", styler: SimpleXMLStyler(tagStyles: styles), options: [.allowUnregisteredElements, .doNotWrapXML]))
    }

    /// Basic test on some HTML-like behavior.
    func testHTMLish() {
        struct HTMLishStyleBuilder: XMLStyler {
            let tagStyles: TagStyles

            func style(forElement name: String, attributes: [String: String]) -> AttributedStringStyle? {
                var namedStyle = tagStyles.style(forName: name) ?? AttributedStringStyle()
                if let htmlClass = attributes["class"] {
                    namedStyle = tagStyles.style(forName: "\(name):\(htmlClass)") ?? namedStyle
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

        let tagStyles = TagStyles(styles: ["a": styleA,
                                           "p": styleA,
                                           "p:foo": styleB,
                                           ])
        let styler = HTMLishStyleBuilder(tagStyles: tagStyles)
        guard let attributedString = try? NSAttributedString(fromXML: "This <a href='http://raizlabs.com/'>Link</a>, <p>paragraph</p>, <p class='foo'>class</p> looks like HTML.", styler: styler) else {
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
