//
//  StyleAttributeTransformationTests.swift
//
//  Created by Brian King on 8/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

class StyleAttributeTransformationTests: XCTestCase {

    func testBasicAssertionUtilities() {
        let attributes = BonMot(.font(.fontA), .textColor(.colorA), .backgroundColor(.colorB)).attributes()
        XCTAssertEqual(attributes.count, 3)
        BONAssert(attributes: attributes, key: NSFontAttributeName, value: BONFont.fontA)
        BONAssert(attributes: attributes, key: NSForegroundColorAttributeName, value: BONColor.colorA)
        BONAssert(attributes: attributes, key: NSBackgroundColorAttributeName, value: BONColor.colorB)
    }

    func testURL() {
        let url = NSURL(string: "http://apple.com/")!
        let attributes = BonMot(.link(url)).attributes()
        XCTAssertEqual(attributes.count, 1)
        BONAssert(attributes: attributes, key: NSLinkAttributeName, value: url)
    }

    func testStrikethroughStyle() {
        let attributes = BonMot(.strikethrough(.byWord, .colorA)).attributes()

        XCTAssertEqual(attributes.count, 2)
        BONAssert(attributes: attributes, key: NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.byWord.rawValue)
        BONAssert(attributes: attributes, key: NSStrikethroughColorAttributeName, value: BONColor.colorA)
    }

    func testUnderlineStyle() {
        let attributes = BonMot(.underline(.byWord, .colorA)).attributes()
        XCTAssertEqual(attributes.count, 2)
        BONAssert(attributes: attributes, key: NSUnderlineStyleAttributeName, value: NSUnderlineStyle.byWord.rawValue)
        BONAssert(attributes: attributes, key: NSUnderlineColorAttributeName, value: BONColor.colorA)
    }

    func testBaselineStyle() {
        let attributes = BonMot(.baselineOffset(15)).attributes()
        XCTAssertEqual(attributes.count, 1)
        BONAssert(attributes: attributes, key: NSBaselineOffsetAttributeName, float: CGFloat(15), accuracy: 0.001)
    }

    func testAlignmentStyle() {
        let attributes = BonMot(.alignment(.center)).attributes()
        XCTAssertEqual(attributes.count, 1)
        BONAssert(attributes: attributes, query: { $0.alignment }, value: .center)
    }

    func testFontFeatureStyle() {
        EBGarandLoader.loadFontIfNeeded()
        let features: [FontFeatureProvider] = [NumberCase.upper, NumberCase.lower, NumberSpacing.proportional, NumberSpacing.monospaced]
        for feature in features {
            let attributes = BonMot(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .fontFeature(feature)).attributes()
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
    ]

    func testParagraphStyles() {
        let attributes = BonMotI(
            lineSpacing: 10,
            paragraphSpacingAfter: 10,
            alignment: .center,
            firstLineHeadIndent: 10,
            headIndent: 10,
            tailIndent: 10,
            lineBreakMode: .byClipping,
            minimumLineHeight: 10,
            maximumLineHeight: 10,
            baseWritingDirection: .leftToRight,
            lineHeightMultiple: 10,
            paragraphSpacingBefore: 10,
            hyphenationFactor: 10
            ).attributes()
        for (index, check) in StyleAttributeTransformationTests.tens.enumerated() {
            let line = UInt(StyleAttributeTransformationTests.tensLine + 2 + index)
            BONAssert(attributes: attributes, query: check, float: 10, accuracy: 0.001, line: line)
        }
        BONAssert(attributes: attributes, query: { $0.alignment }, value: .center)
        BONAssert(attributes: attributes, query: { $0.lineBreakMode }, value: .byClipping)
        BONAssert(attributes: attributes, query: { $0.baseWritingDirection }, value: .leftToRight)
    }

    func testParagraphStyleAdd() {
        var chain = BonMotI(
            lineSpacing: 1,
            paragraphSpacingAfter: 1,
            alignment: .left,
            firstLineHeadIndent: 1,
            headIndent: 1,
            tailIndent: 1,
            lineBreakMode: .byWordWrapping,
            minimumLineHeight: 1,
            maximumLineHeight: 1,
            baseWritingDirection: .natural,
            lineHeightMultiple: 1,
            paragraphSpacingBefore: 1,
            hyphenationFactor: 1
            )
        chain.update(attributedStringStyle: BonMotI(
            lineSpacing: 10,
            paragraphSpacingAfter: 10,
            alignment: .center,
            firstLineHeadIndent: 10,
            headIndent: 10,
            tailIndent: 10,
            lineBreakMode: .byClipping,
            minimumLineHeight: 10,
            maximumLineHeight: 10,
            baseWritingDirection: .leftToRight,
            lineHeightMultiple: 10,
            paragraphSpacingBefore: 10,
            hyphenationFactor: 10
            ))
        let attributes = chain.attributes()
        for (index, check) in StyleAttributeTransformationTests.tens.enumerated() {
            let line = UInt(StyleAttributeTransformationTests.tensLine + 2 + index)
            BONAssert(attributes: attributes, query: check, float: 10, accuracy: 0.001, line: line)
        }
        BONAssert(attributes: attributes, query: { $0.alignment }, value: .center)
        BONAssert(attributes: attributes, query: { $0.lineBreakMode }, value: .byClipping)
        BONAssert(attributes: attributes, query: { $0.baseWritingDirection }, value: .leftToRight)
    }

    func testAdobeTracking() {
        let chain = BonMotI(tracking: Tracking.adobe(300))
        let testKernAttribute = { (fontSize: CGFloat) -> CGFloat in
            let font = BONFont(name: "Avenir-Book", size: fontSize)!
            let attributes = chain.style(attributes: [NSFontAttributeName: font])
            return attributes[NSKernAttributeName] as? CGFloat ?? 0
        }
        XCTAssertEqualWithAccuracy(testKernAttribute(20), 6, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(testKernAttribute(30), 9, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(testKernAttribute(40), 12, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(testKernAttribute(50), 15, accuracy: 0.0001)
    }

    func testPointTracking() {
        let chain = BonMotI(tracking: Tracking.point(10))
        let testKernAttribute = { (fontSize: CGFloat) -> CGFloat in
            let font = BONFont(name: "Avenir-Book", size: fontSize)!
            let attributes = chain.style(attributes: [NSFontAttributeName: font])
            return attributes[NSKernAttributeName] as? CGFloat ?? 0
        }
        XCTAssertEqualWithAccuracy(testKernAttribute(20), 10, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(testKernAttribute(30), 10, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(testKernAttribute(40), 10, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(testKernAttribute(50), 10, accuracy: 0.0001)
    }

}
