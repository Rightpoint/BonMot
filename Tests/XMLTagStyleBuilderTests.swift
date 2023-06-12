//
//  XMLTagStyleBuilderTests.swift
//  BonMot
//
//  Created by Brian King on 8/29/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

import BonMot
import XCTest

class XMLTagStyleBuilderTests: XCTestCase {

    /// There have been concerns about XMLParser's performance. This is a
    /// baseline test, but doesn't mean much without a comparison.
    func testBasicParserPerformance() {
        let styles = NamedStyles(styles: ["A": styleA, "B": styleB])

        var hugeString = ""
        for _ in 0..<100 {
            hugeString.append("This is <A>A style</A> test for <B>B Style</B>.")
        }
        // For some reason, the `AllTheThings` target fails when things are measured. Since this measurement is not of much
        // value, it's disabled until we have enough value in the measurement to fix the build bug.
//        measure() {
            XCTAssertNotNil(try? NSAttributedString.composed(ofXML: hugeString, rules: [.styles(styles)]))
//        }
    }

    /// Test that the ranges of the composed attributed string match what is expected
    func testComposition() {
        let styles = NamedStyles(styles: ["A": styleA, "B": styleB])

        guard let attributedString = try? NSAttributedString.composed(ofXML: "This is <A>A style</A> test for <B>B Style</B>.", rules: [.styles(styles)]) else {
            XCTFail("No attributed string")
            return
        }
        XCTAssertEqual("This is A style test for B Style.", attributedString.string)
        let fonts: [String: BONFont] = attributedString.rangesFor(attribute: NSAttributedString.Key.font.rawValue)
        BONAssertEqualFonts(BONFont(name: "Avenir-Roman", size: 30)!, fonts["8:7"]!)
        BONAssertEqualFonts(BONFont(name: "Avenir-Roman", size: 20)!, fonts["25:7"]!)
        XCTAssertEqual(fonts.count, 2)
    }

    func testUnicodeInXML() {
        do {
            let attributedString = try NSAttributedString.composed(ofXML: "caf&#233;")
            XCTAssertEqual(attributedString.string, "café")
        }
        catch {
            XCTFail("Failed to create attributed string: \(error)")
        }
    }

    func testCompositionByStyle() {
        let styles = NamedStyles(styles: ["A": styleA, "B": styleB])
        let style = StringStyle(.xmlRules([.styles(styles)]))
        let attributedString = style.attributedString(from: "This is <A>A style</A> test for <B>B Style</B>.")
        XCTAssertEqual("This is A style test for B Style.", attributedString.string)
        let fonts: [String: BONFont] = attributedString.rangesFor(attribute: NSAttributedString.Key.font.rawValue)
        BONAssertEqualFonts(BONFont(name: "Avenir-Roman", size: 30)!, fonts["8:7"]!)
        BONAssertEqualFonts(BONFont(name: "Avenir-Roman", size: 20)!, fonts["25:7"]!)
        XCTAssertEqual(fonts.count, 2)
    }

    /// Verify the behavior when a style is not registered
    func testMissingTags() {
        let styles = NamedStyles()
        styles.registerStyle(forName: "A", style: styleA)

        XCTAssertNotNil(try? NSAttributedString.composed(ofXML: "This <B>style</B> is not registered and that's OK", rules: [.styles(styles)]))
    }

    func testMissingTagsByStyle() {
        let styles = NamedStyles()
        let style = StringStyle(.xmlRules([.styles(styles)]))
        let attributedString = style.attributedString(from: "This <B>style</B> is not registered and that's OK")
        XCTAssertEqual("This style is not registered and that's OK", attributedString.string)
        let fonts: [String: BONFont] = attributedString.rangesFor(attribute: NSAttributedString.Key.font.rawValue)
        XCTAssertEqual(fonts.count, 0)
    }

    func testInvalidXMLByStyle() {
        let styles = NamedStyles()
        let style = StringStyle(.xmlRules([.styles(styles)]))
        let attributedString = style.attributedString(from: "This <B>style has no closing tag and that is :(")
        XCTAssertEqual("This <B>style has no closing tag and that is :(", attributedString.string)
        let fonts: [String: BONFont] = attributedString.rangesFor(attribute: NSAttributedString.Key.font.rawValue)
        XCTAssertEqual(fonts.count, 0)
    }

    /// Verify that the string is read when fully contained
    func testFullXML() {
        let styles = NamedStyles()
        XCTAssertNotNil(try? NSAttributedString.composed(ofXML: "<Top>This is fully contained</Top>", rules: [.styles(styles)], options: [.doNotWrapXML]))
    }

    /// Basic test of some HTML-like behavior.
    func testHTMLish() {
        struct HTMLishStyleBuilder: XMLStyler {
            let namedStyles = [
                "a": styleA,
                "p": styleA,
                "p:foo": styleB,
            ]

            func style(forElement name: String, attributes: [String: String], currentStyle: StringStyle) -> StringStyle? {
                var namedStyle = namedStyles[name] ?? StringStyle()
                if let htmlClass = attributes["class"] {
                    namedStyle = namedStyles["\(name):\(htmlClass)"] ?? namedStyle
                }
                if name.lowercased() == "a" {
                    if let href = attributes["href"], let url = URL(string: href) {
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
        guard let attributedString = try? NSAttributedString.composed(ofXML: "This <a href='http://rightpoint.com/'>Link</a>, <p>paragraph</p>, <p class='foo'>class</p> looks like HTML.", styler: styler) else {
            XCTFail("No attributed string")
            return
        }
        let expectedFonts = [
            "5:4": styleA.font!,
            "11:9": styleA.font!,
            "22:5": styleB.font!,
        ]
        let actualFonts: [String: BONFont] = attributedString.rangesFor(attribute: NSAttributedString.Key.font.rawValue)
        XCTAssertEqual(expectedFonts, actualFonts)
        XCTAssertEqual(["5:4": URL(string: "http://rightpoint.com/")!], attributedString.rangesFor(attribute: NSAttributedString.Key.link.rawValue))
    }

    /// Ensure that the singleton is configured with some adaptive styles for easy Dynamic Type support.
    #if os(iOS) || os(tvOS)
    func testDefaultNamedStyles() {
        XCTAssertNotNil(NamedStyles.shared.style(forName: "body"))
        XCTAssertNotNil(NamedStyles.shared.style(forName: "control"))
        XCTAssertNotNil(NamedStyles.shared.style(forName: "preferred"))
    }
    #endif

    /// Test the line and column information returned in the error. Note that this is just testing our adapting of the column for the root node insertion.
    func testErrorLocation() {
        func errorLocation(forXML xml: String, _ options: XMLParsingOptions = []) -> (line: Int, column: Int) {
            do {
                let attributedString = try NSAttributedString.composed(ofXML: xml)
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
        for value in Special.allCases {
            let xmlString = "this<BON:\(value.name)/>should embed a special character"
            let xmlAttributedString = try? NSAttributedString.composed(ofXML: xmlString)
            XCTAssertEqual(xmlAttributedString?.string, "this\(value)should embed a special character")
        }
    }

}
