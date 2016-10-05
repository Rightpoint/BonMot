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
        // For some reason, the `AllTheThings` target fails when things are measured. Since this measurement is not of much
        // value, it's disabled until we have enough value in the measurement to fix the build bug.
//        measure() {
            XCTAssertNotNil(try? NSAttributedString.compose(xml: hugeString, rules: [.styles(styles)]))
//        }
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
        XCTAssertNotNil(try? NSAttributedString.compose(xml: "This <B>style</B> is not registered but that's OK", rules: [.styles(styles)]))
    }

    /// Verify that the string is read when fully contained
    func testFullXML() {
        let styles = TagStyles()
        XCTAssertNotNil(try? NSAttributedString.compose(xml: "<Top>This is fully contained</Top>", rules: [.styles(styles)], options: [.doNotWrapXML]))
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
            func prefix(forElement name: String, attributes: [String: String]) -> Composable? { return nil }
            func suffix(forElement name: String) -> Composable? { return nil }
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
    #if os(iOS) || os(tvOS)
    func testDefaultTagStyles() {
        XCTAssertNotNil(TagStyles.shared.style(forName: "body"))
        XCTAssertNotNil(TagStyles.shared.style(forName: "control"))
        XCTAssertNotNil(TagStyles.shared.style(forName: "preferred"))
    }
    #endif

    /// Test the line and column information returned in the error. Note that this is just testing our adapting of the column for the root node insertion.
    func testErrorLocation() {
        func errorLocation(forXML xml: String, _ options: XMLParsingOptions = []) -> (line: Int, column: Int) {
            do {
                let attributedString = try NSAttributedString.compose(xml: xml)
                XCTFail("compose should of thrown, got \(attributedString)")
            }
            catch let error as XMLBuilderError {
                return (error.line, error.column)
            }
            catch {
                XCTFail("Did not get an XMLError")
            }
            return (0, 0)
        }
        XCTAssertEqual(errorLocation(forXML: "Text <a ").line, 1)
        XCTAssertEqual(errorLocation(forXML: "Text <a ").column, 7)
        XCTAssertEqual(errorLocation(forXML: "Text \r\n <a ").line, 2)
        XCTAssertEqual(errorLocation(forXML: "Text \r\n <a ").column, 3)

        XCTAssertEqual(errorLocation(forXML: "<ex> <a ", [.doNotWrapXML]).line, 1)
        XCTAssertEqual(errorLocation(forXML: "<ex> <a ", [.doNotWrapXML]).column, 7)
        XCTAssertEqual(errorLocation(forXML: "<ex> \r\n <a ", [.doNotWrapXML]).line, 2)
        XCTAssertEqual(errorLocation(forXML: "<ex> \r\n <a ", [.doNotWrapXML]).column, 3)
    }

    func testBONXML() {
        for value in Special.all {
            let xmlString = "this<BON:\(value.name)/>should embed a special character"
            let xmlAttributedString = try? NSAttributedString.compose(xml: xmlString)
            XCTAssertEqual(xmlAttributedString?.string, "this\(value)should embed a special character")
        }
    }

}
