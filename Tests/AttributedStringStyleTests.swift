//
//  AttributedStringStyleTests.swift
//
//  Created by Brian King on 8/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

class AttributedStringStyleTests: XCTestCase {

    func testBasicAssertionUtilities() {
        let style = AttributedStringStyle.style(.font(.fontA), .color(.colorA), .backgroundColor(.colorB))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 3)
            // We're only checking the font name and point size, since the full style could have font
            // features that cause equality checks to fail. Font Feature support is tested in testFontFeatureStyle.
            let font = style.attributes[NSFontAttributeName] as? BONFont
            XCTAssertEqual(font?.fontName, BONFont.fontA.fontName)
            XCTAssertEqual(font?.pointSize, BONFont.fontA.pointSize)
            BONAssert(attributes: style.attributes, key: NSForegroundColorAttributeName, value: BONColor.colorA)
            BONAssert(attributes: style.attributes, key: NSBackgroundColorAttributeName, value: BONColor.colorB)
        }
    }

    #if os(iOS) || os(tvOS)
    func testTextStyle() {
        let style = AttributedStringStyle.style(.textStyle(titleTextStyle))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[NSFontAttributeName] as? UIFont
            let fontTextStyle = font?.textStyle
            XCTAssertEqual(fontTextStyle, titleTextStyle)
            print(fontTextStyle, titleTextStyle)
        }
    }
    #endif

    func testURL() {
        let url = NSURL(string: "http://apple.com/")!
        let style = AttributedStringStyle.style(.link(url))

        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: NSLinkAttributeName, value: url)
        }
    }

    func testStrikethroughStyle() {
        let style = AttributedStringStyle.style(.strikethrough(.byWord, .colorA))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 2)
            BONAssert(attributes: style.attributes, key: NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.byWord.rawValue)
            BONAssert(attributes: style.attributes, key: NSStrikethroughColorAttributeName, value: BONColor.colorA)
        }
    }

    func testUnderlineStyle() {
        let style = AttributedStringStyle.style(.underline(.byWord, .colorA))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 2)
            BONAssert(attributes: style.attributes, key: NSUnderlineStyleAttributeName, value: NSUnderlineStyle.byWord.rawValue)
            BONAssert(attributes: style.attributes, key: NSUnderlineColorAttributeName, value: BONColor.colorA)
        }
    }

    func testBaselineStyle() {
        let style = AttributedStringStyle.style(.baselineOffset(15))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: NSBaselineOffsetAttributeName, float: CGFloat(15), accuracy: 0.001)
        }
    }

    func testAlignmentStyle() {
        let style = AttributedStringStyle.style(.alignment(.center))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, query: { $0.alignment }, value: .center)
        }
    }

    func testFontFeatureStyle() {
        EBGaramondLoader.loadFontIfNeeded()
        let features: [FontFeatureProvider] = [NumberCase.upper, NumberCase.lower, NumberSpacing.proportional, NumberSpacing.monospaced]
        for feature in features {
            let attributes = AttributedStringStyle.style(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .fontFeature(feature)).attributes
            XCTAssertEqual(attributes.count, 1)
            let font = attributes[NSFontAttributeName] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
        }
    }

    static let tensLine = #line
    static let tens: [(NSParagraphStyle) -> CGFloat] = [
        // swiftlint:disable opening_brace
        { $0.lineSpacing },
        { $0.paragraphSpacing },
        { $0.headIndent },
        { $0.tailIndent },
        { $0.firstLineHeadIndent },
        { $0.minimumLineHeight },
        { $0.maximumLineHeight },
        { $0.lineHeightMultiple },
        { $0.paragraphSpacingBefore },
        { CGFloat($0.hyphenationFactor) },
        // swiftlint:enable opening_brace
    ]

    func testParagraphStyles() {
        let style = AttributedStringStyle.style(
            .lineSpacing(10),
            .paragraphSpacingAfter(10),
            .alignment(.center),
            .firstLineHeadIndent(10),
            .headIndent(10),
            .tailIndent(10),
            .lineBreakMode(.byClipping),
            .minimumLineHeight(10),
            .maximumLineHeight(10),
            .baseWritingDirection(.leftToRight),
            .lineHeightMultiple(10),
            .paragraphSpacingBefore(10),
            .hyphenationFactor(10)
            )
        for (index, check) in AttributedStringStyleTests.tens.enumerated() {
            let line = UInt(AttributedStringStyleTests.tensLine + 2 + index)
            BONAssert(attributes: style.attributes, query: check, float: 10, accuracy: 0.001, line: line)
        }
        BONAssert(attributes: style.attributes, query: { $0.alignment }, value: .center)
        BONAssert(attributes: style.attributes, query: { $0.lineBreakMode }, value: .byClipping)
        BONAssert(attributes: style.attributes, query: { $0.baseWritingDirection }, value: .leftToRight)
    }

    func testParagraphStyleAdd() {
        var style = AttributedStringStyle.style(
            .lineSpacing(1),
            .paragraphSpacingAfter(1),
            .alignment(.left),
            .firstLineHeadIndent(1),
            .headIndent(1),
            .tailIndent(1),
            .lineBreakMode(.byWordWrapping),
            .minimumLineHeight(1),
            .maximumLineHeight(1),
            .baseWritingDirection(.natural),
            .lineHeightMultiple(1),
            .paragraphSpacingBefore(1),
            .hyphenationFactor(1)
            )
        style.add(attributedStringStyle: AttributedStringStyle.style(
            .lineSpacing(10),
            .paragraphSpacingAfter(10),
            .alignment(.center),
            .firstLineHeadIndent(10),
            .headIndent(10),
            .tailIndent(10),
            .lineBreakMode(.byClipping),
            .minimumLineHeight(10),
            .maximumLineHeight(10),
            .baseWritingDirection(.leftToRight),
            .lineHeightMultiple(10),
            .paragraphSpacingBefore(10),
            .hyphenationFactor(10)
            ))
        for (index, check) in AttributedStringStyleTests.tens.enumerated() {
            let line = UInt(AttributedStringStyleTests.tensLine + 2 + index)
            BONAssert(attributes: style.attributes, query: check, float: 10, accuracy: 0.001, line: line)
        }
        BONAssert(attributes: style.attributes, query: { $0.alignment }, value: .center)
        BONAssert(attributes: style.attributes, query: { $0.lineBreakMode }, value: .byClipping)
        BONAssert(attributes: style.attributes, query: { $0.baseWritingDirection }, value: .leftToRight)
    }

    func testAdobeTracking() {
        let style = AttributedStringStyle.style(.tracking(.adobe(300)))
        for (style, _) in checks(for: style) {
            let testKernAttribute = { (fontSize: CGFloat) -> CGFloat in
                let font = BONFont(name: "Avenir-Book", size: fontSize)!
                let newStyle = style.byAdding(.font(font))
                return newStyle.attributes[NSKernAttributeName] as? CGFloat ?? 0
            }
            XCTAssertEqualWithAccuracy(testKernAttribute(20), 6, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(30), 9, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(40), 12, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(50), 15, accuracy: 0.0001)
        }
    }

    func testPointTracking() {
        let style = AttributedStringStyle.style(.tracking(.point(10)))
        for (style, _) in checks(for: style) {
            let testKernAttribute = { (fontSize: CGFloat) -> CGFloat in
                let font = BONFont(name: "Avenir-Book", size: fontSize)!
                let newStyle = style.byAdding(.font(font))
                return newStyle.attributes[NSKernAttributeName] as? CGFloat ?? 0
            }
            XCTAssertEqualWithAccuracy(testKernAttribute(20), 10, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(30), 10, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(40), 10, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(50), 10, accuracy: 0.0001)
        }
    }

    // Note: avoiding triple-slash comment because SwiftLint doesn't like the formatting of this method for some reason.
    // Return all the supported transfromations of the given style.
    // - parameter for: the style to check
    // - returns: One of the following
    //   - the passed style object
    //   - an empty style object that is updated by the passed style object
    //   - a fully populated style object that is updated by the passed style object
    func checks(for style: AttributedStringStyle) -> [(style: AttributedStringStyle, fullStyle: Bool)] {
        let derivedStyle = AttributedStringStyle.style().byAdding { derivedStyle in
            // Not sure why but if this line is commented out, the line after is a compilation error.
            // Feels like a swift bug or an Xcode bug that will disappear in a few days. ><
            derivedStyle.add(initialAttributes: [:])
            derivedStyle.add(attributedStringStyle: style)
        }
        // Bizarre, this works:
        var updated = fullStyle
        updated.add(attributedStringStyle: style)

        return [(style: style, fullStyle: false), (style: derivedStyle, fullStyle: false), (style: updated, fullStyle: true)]
    }

    // A fully populated style object that is updated to ensure that update over-writes all values correctly.
    // Values in this style object should not be used by any test using checks(for:) to ensure no false-positives.

}
