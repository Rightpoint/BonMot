//
//  StyleAttributeProviderTests.swift
//
//  Created by Brian King on 8/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

class StyleAttributeProviderTests: XCTestCase {

    func testBasicAssertionUtilities() {
        let attributes = BonMot(.font(.fontA), .textColor(.colorA), .backgroundColor(.colorB)).styleAttributes()
        XCTAssertEqual(attributes.count, 4)
        FPAssertKey(attributes, key: NSFontAttributeName, value: UIFont.fontA)
        FPAssertKey(attributes, key: NSForegroundColorAttributeName, value: UIColor.colorA)
        FPAssertKey(attributes, key: NSBackgroundColorAttributeName, value: UIColor.colorB)
        XCTAssertNotNil(StyleAttributeProviderAttributeName)
    }

    func testURL() {
        let url = NSURL(string: "http://apple.com/")!
        let attributes = BonMot(.link(url)).styleAttributes()
        XCTAssertEqual(attributes.count, 2)
        FPAssertKey(attributes, key: NSLinkAttributeName, value: url)
        XCTAssertNotNil(StyleAttributeProviderAttributeName)
    }

    func testStrikethroughStyle() {
        let attributes = BonMot(.strikethrough(.ByWord, .colorA)).styleAttributes()

        XCTAssertEqual(attributes.count, 3)
        FPAssertKey(attributes, key: NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.ByWord.rawValue)
        FPAssertKey(attributes, key: NSStrikethroughColorAttributeName, value: UIColor.colorA)
        XCTAssertNotNil(StyleAttributeProviderAttributeName)
    }

    func testUnderlineStyle() {
        let attributes = BonMot(.underline(.ByWord, .colorA)).styleAttributes()
        XCTAssertEqual(attributes.count, 3)
        FPAssertKey(attributes, key: NSUnderlineStyleAttributeName, value: NSUnderlineStyle.ByWord.rawValue)
        FPAssertKey(attributes, key: NSUnderlineColorAttributeName, value: UIColor.colorA)
        XCTAssertNotNil(StyleAttributeProviderAttributeName)
    }

    func testBaselineStyle() {
        let attributes = BonMot(.baselineOffset(15)).styleAttributes()
        XCTAssertEqual(attributes.count, 2)
        FPAssertKey(attributes, key: NSBaselineOffsetAttributeName, value: 15)
        XCTAssertNotNil(StyleAttributeProviderAttributeName)
    }

    func testAlignmentStyle() {
        let attributes = BonMot(.alignment(.Center)).styleAttributes()
        XCTAssertEqual(attributes.count, 2)
        FPAssertParagraphStyle(attributes, query: { $0.alignment }, value: .Center)
        XCTAssertNotNil(StyleAttributeProviderAttributeName)
    }

    func testFontFeatureStyle() {
        EBGarandLoader.loadFontIfNeeded()
        let features: [FontFeatureProvider] = [NumberCase.upper, NumberCase.lower, NumberSpacing.proportional, NumberSpacing.monospaced]
        for feature in features {
            let attributes = BonMot(.font(UIFont(name: "EBGaramond12-Regular", size: 24)!), .fontFeature(feature)).styleAttributes()
            XCTAssertEqual(attributes.count, 2)
            let font = attributes[NSFontAttributeName] as? UIFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor().fontAttributes()
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[UIFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            // Not sure what to check here.
            XCTAssertNotNil(StyleAttributeProviderAttributeName)
        }
    }

    func testFontAdaptStyle() {
        guard #available(iOS 10.0, *) else {
            print("Can not test adaptive style pre iOS 10.0. Update this test.")
            return
        }
        let inputFont = UIFont.systemFontOfSize(30)
        let style = BonMot(.font(inputFont), .adapt(.control))
        let attributes = style.styleAttributes()
        XCTAssertEqual(attributes.count, 2)
        FPAssertKey(attributes, key: NSFontAttributeName, value: inputFont)
        XCTAssertNotNil(StyleAttributeProviderAttributeName)
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
            alignment: .Center,
            headIndent: 10,
            tailIndent: 10,
            firstLineHeadIndent: 10,
            minimumLineHeight: 10,
            maximumLineHeight: 10,
            lineBreakMode: .ByClipping,
            baseWritingDirection: .LeftToRight,
            lineHeightMultiple: 10,
            paragraphSpacingBefore: 10,
            hyphenationFactor: 10
            ).styleAttributes()
        for (index, check) in StyleAttributeProviderTests.tens.enumerate() {
            let line = UInt(StyleAttributeProviderTests.tensLine + 2 + index)
            FPAssertParagraphStyle(attributes, query: check, float: 10, accuracy: 0.001, line: line)
        }
        FPAssertParagraphStyle(attributes, query: { $0.alignment }, value: .Center)
        FPAssertParagraphStyle(attributes, query: { $0.lineBreakMode }, value: .ByClipping)
        FPAssertParagraphStyle(attributes, query: { $0.baseWritingDirection }, value: .LeftToRight)
    }

    func testParagraphStyleAdd() {
        var chain = BonMotI(
            lineSpacing: 1,
            paragraphSpacingAfter: 1,
            alignment: .Left,
            headIndent: 1,
            tailIndent: 1,
            firstLineHeadIndent: 1,
            minimumLineHeight: 1,
            maximumLineHeight: 1,
            lineBreakMode: .ByWordWrapping,
            baseWritingDirection: .Natural,
            lineHeightMultiple: 1,
            paragraphSpacingBefore: 1,
            hyphenationFactor: 1
            )
        chain.add(attributedStringStyle: BonMotI(
            lineSpacing: 10,
            paragraphSpacingAfter: 10,
            alignment: .Center,
            headIndent: 10,
            tailIndent: 10,
            firstLineHeadIndent: 10,
            minimumLineHeight: 10,
            maximumLineHeight: 10,
            lineBreakMode: .ByClipping,
            baseWritingDirection: .LeftToRight,
            lineHeightMultiple: 10,
            paragraphSpacingBefore: 10,
            hyphenationFactor: 10
            ))
        let attributes = chain.styleAttributes()
        for (index, check) in StyleAttributeProviderTests.tens.enumerate() {
            let line = UInt(StyleAttributeProviderTests.tensLine + 2 + index)
            FPAssertParagraphStyle(attributes, query: check, float: 10, accuracy: 0.001, line: line)
        }
        FPAssertParagraphStyle(attributes, query: { $0.alignment }, value: .Center)
        FPAssertParagraphStyle(attributes, query: { $0.lineBreakMode }, value: .ByClipping)
        FPAssertParagraphStyle(attributes, query: { $0.baseWritingDirection }, value: .LeftToRight)
    }

    func testAdobeTracking() {
        var chain = BonMotI(tracking: Tracking.adobe(300))
        func testKernAttribute(fontSize: CGFloat) -> CGFloat {
            let font = UIFont(name: "Avenir-Book", size: fontSize)!
            let attributes = chain.styleAttributes(attributes: [NSFontAttributeName: font], traitCollection: nil)
            return attributes[NSKernAttributeName] as? CGFloat ?? 0
        }
        XCTAssertEqual(testKernAttribute(20), 6)
        XCTAssertEqual(testKernAttribute(30), 9)
        XCTAssertEqual(testKernAttribute(40), 12)
        XCTAssertEqual(testKernAttribute(50), 15)
    }

    func testPointTracking() {
        var chain = BonMotI(tracking: Tracking.point(10))
        func testKernAttribute(fontSize: CGFloat) -> CGFloat {
            let font = UIFont(name: "Avenir-Book", size: fontSize)!
            let attributes = chain.styleAttributes(attributes: [NSFontAttributeName: font], traitCollection: nil)
            return attributes[NSKernAttributeName] as? CGFloat ?? 0
        }
        XCTAssertEqual(testKernAttribute(20), 10)
        XCTAssertEqual(testKernAttribute(30), 10)
        XCTAssertEqual(testKernAttribute(40), 10)
        XCTAssertEqual(testKernAttribute(50), 10)
    }

}
