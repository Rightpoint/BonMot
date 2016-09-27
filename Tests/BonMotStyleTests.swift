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
        let style = BonMot(.font(.fontA), .textColor(.colorA), .backgroundColor(.colorB))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes().count == 3)
            BONAssert(attributes: style.attributes(), key: NSFontAttributeName, value: BONFont.fontA)
            BONAssert(attributes: style.attributes(), key: NSForegroundColorAttributeName, value: BONColor.colorA)
            BONAssert(attributes: style.attributes(), key: NSBackgroundColorAttributeName, value: BONColor.colorB)
        }
    }

    func testTextStyle() {
        let font = UIFont.preferredFont(forTextStyle: titleTextStyle)
        let style = BonMot(.textStyle(titleTextStyle))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes().count == 1)
            BONAssert(attributes: style.attributes(), query: { $0.alignment }, value: .center)

            BONAssert(attributes: style.attributes(), key: NSFontAttributeName, value: font)
        }
    }

    func testURL() {
        let url = NSURL(string: "http://apple.com/")!
        let style = BonMot(.link(url))

        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes().count == 1)
            BONAssert(attributes: style.attributes(), key: NSLinkAttributeName, value: url)
        }
    }

    func testStrikethroughStyle() {
        let style = BonMot(.strikethrough(.byWord, .colorA))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes().count == 2)
            BONAssert(attributes: style.attributes(), key: NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.byWord.rawValue)
            BONAssert(attributes: style.attributes(), key: NSStrikethroughColorAttributeName, value: BONColor.colorA)
        }
    }

    func testUnderlineStyle() {
        let style = BonMot(.underline(.byWord, .colorA))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes().count == 2)
            BONAssert(attributes: style.attributes(), key: NSUnderlineStyleAttributeName, value: NSUnderlineStyle.byWord.rawValue)
            BONAssert(attributes: style.attributes(), key: NSUnderlineColorAttributeName, value: BONColor.colorA)
        }
    }

    func testBaselineStyle() {
        let style = BonMot(.baselineOffset(15))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes().count == 1)
            BONAssert(attributes: style.attributes(), key: NSBaselineOffsetAttributeName, float: CGFloat(15), accuracy: 0.001)
        }
    }

    func testAlignmentStyle() {
        let style = BonMot(.alignment(.center))
        for (style, fullStyle) in checks(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes().count == 1)
            BONAssert(attributes: style.attributes(), query: { $0.alignment }, value: .center)
        }
    }

    func testFontFeatureStyle() {
        EBGaramondLoader.loadFontIfNeeded()
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
        let style = BonMot(
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
        for (index, check) in StyleAttributeTransformationTests.tens.enumerated() {
            let line = UInt(StyleAttributeTransformationTests.tensLine + 2 + index)
            BONAssert(attributes: style.attributes(), query: check, float: 10, accuracy: 0.001, line: line)
        }
        BONAssert(attributes: style.attributes(), query: { $0.alignment }, value: .center)
        BONAssert(attributes: style.attributes(), query: { $0.lineBreakMode }, value: .byClipping)
        BONAssert(attributes: style.attributes(), query: { $0.baseWritingDirection }, value: .leftToRight)
    }

    func testParagraphStyleAdd() {
        var style = BonMot(
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
        style.update(attributedStringStyle: BonMot(
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
        for (index, check) in StyleAttributeTransformationTests.tens.enumerated() {
            let line = UInt(StyleAttributeTransformationTests.tensLine + 2 + index)
            BONAssert(attributes: style.attributes(), query: check, float: 10, accuracy: 0.001, line: line)
        }
        BONAssert(attributes: style.attributes(), query: { $0.alignment }, value: .center)
        BONAssert(attributes: style.attributes(), query: { $0.lineBreakMode }, value: .byClipping)
        BONAssert(attributes: style.attributes(), query: { $0.baseWritingDirection }, value: .leftToRight)
    }

    func testAdobeTracking() {
        let style = BonMot(.tracking(.adobe(300)))
        for (style, fullStyle) in checks(for: style) {
            let testKernAttribute = { (fontSize: CGFloat) -> CGFloat in
                let font = BONFont(name: "Avenir-Book", size: fontSize)!
                let attributes: StyleAttributes
                if fullStyle {
                    var style = style
                    style.font = font
                    attributes = style.attributes()
                } else {
                    attributes = style.style(attributes: [NSFontAttributeName: font])
                }
                return attributes[NSKernAttributeName] as? CGFloat ?? 0
            }
            XCTAssertEqualWithAccuracy(testKernAttribute(20), 6, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(30), 9, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(40), 12, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(50), 15, accuracy: 0.0001)
        }
    }

    func testPointTracking() {
        let style = BonMot(.tracking(.point(10)))
        for (style, _) in checks(for: style) {
            let testKernAttribute = { (fontSize: CGFloat) -> CGFloat in
                let font = BONFont(name: "Avenir-Book", size: fontSize)!
                let attributes = style.style(attributes: [NSFontAttributeName: font])
                return attributes[NSKernAttributeName] as? CGFloat ?? 0
            }
            XCTAssertEqualWithAccuracy(testKernAttribute(20), 10, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(30), 10, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(40), 10, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(testKernAttribute(50), 10, accuracy: 0.0001)
        }
    }

    /// Return all the supported transfromations of the given style. It will return:
    /// - The passed style object
    /// - An empty style object that is updated by the passed style object
    /// - A fully populated style object that is updated by the passed style object
    func checks(for style: AttributedStringStyle) -> [(style: AttributedStringStyle, fullStyle: Bool)] {
        let derived = BonMot().derive { derived in
            // Not sure why but if this line is commented out, the line after is a compilation error.
            // Feels like a swift bug or an Xcode bug that will disappear in a few days. ><
            derived.update(attributes: [:])
            derived.update(attributedStringStyle: style)
        }
        // Bizarre, this works:
        var updated = StyleAttributeTransformationTests.fullStyle
        updated.update(attributedStringStyle: style)

        return [(style: style, fullStyle: false), (style: derived, fullStyle: false), (style: updated, fullStyle: true)]
    }

    // A fully populated style object that is updated to ensure that update over-writes all values correctly.
    // Values in this style object should not be used by any test using checks(for:) to ensure no false-positives.
    static var fullStyle: AttributedStringStyle = {
        let terribleValue = CGFloat(1000000)
        var fullStyle = AttributedStringStyle()
        #if os(iOS) || os(tvOS)
            fullStyle.textStyle = differentTextStyle
        #endif
        fullStyle.font = UIFont.italicSystemFont(ofSize: 88)
        fullStyle.link = NSURL(string: "http://www.raizlabs.com/")
        fullStyle.backgroundColor = .colorC
        fullStyle.textColor = .colorC

        fullStyle.underline = (.byWord, .colorC)
        fullStyle.strikethrough = (.byWord, .colorC)

        fullStyle.baselineOffset = terribleValue

        fullStyle.lineSpacing = terribleValue

        fullStyle.paragraphSpacingAfter = terribleValue
        fullStyle.alignment = .left
        fullStyle.firstLineHeadIndent = terribleValue
        fullStyle.headIndent = terribleValue
        fullStyle.tailIndent = terribleValue
        fullStyle.lineBreakMode = .byTruncatingMiddle
        fullStyle.minimumLineHeight = terribleValue
        fullStyle.maximumLineHeight = terribleValue
        fullStyle.baseWritingDirection = .rightToLeft
        fullStyle.lineHeightMultiple = terribleValue
        fullStyle.paragraphSpacingBefore = terribleValue
        fullStyle.hyphenationFactor = Float(terribleValue)

        #if os(iOS) || os(tvOS) || os(OSX)
            fullStyle.fontFeatureProviders = [NumberCase.upper, NumberCase.upper, NumberCase.upper, NumberCase.upper]
        #endif
        fullStyle.adaptations = [BonMot(), BonMot(), BonMot(), BonMot()]
        fullStyle.tracking = .adobe(terribleValue)
        return fullStyle
    }()

}
