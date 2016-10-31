//
//  StringStyleTests.swift
//
//  Created by Brian King on 8/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot
import CoreText

//swiftlint:disable:next type_body_length
class StringStyleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        EBGaramondLoader.loadFontIfNeeded()
    }

    func testBasicAssertionUtilities() {
        let style = StringStyle(.font(.fontA), .color(.colorA), .backgroundColor(.colorB))
        for (style, fullStyle) in additiviePermutations(for: style) {
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
        let style = StringStyle(.textStyle(titleTextStyle))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[NSFontAttributeName] as? UIFont
            let fontTextStyle = font?.textStyle
            XCTAssertEqual(fontTextStyle, titleTextStyle)
        }
    }
    #endif

    func testURL() {
        let url = NSURL(string: "http://apple.com/")!
        let style = StringStyle(.link(url))

        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: NSLinkAttributeName, value: url)
        }
    }

    func testStrikethroughStyle() {
        let style = StringStyle(.strikethrough(.byWord, .colorA))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 2)
            BONAssert(attributes: style.attributes, key: NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.byWord.rawValue)
            BONAssert(attributes: style.attributes, key: NSStrikethroughColorAttributeName, value: BONColor.colorA)
        }
    }

    func testUnderlineStyle() {
        let style = StringStyle(.underline(.byWord, .colorA))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 2)
            BONAssert(attributes: style.attributes, key: NSUnderlineStyleAttributeName, value: NSUnderlineStyle.byWord.rawValue)
            BONAssert(attributes: style.attributes, key: NSUnderlineColorAttributeName, value: BONColor.colorA)
        }
    }

    func testBaselineStyle() {
        let style = StringStyle(.baselineOffset(15))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: NSBaselineOffsetAttributeName, float: CGFloat(15), accuracy: 0.001)
        }
    }

    func testAlignmentStyle() {
        let style = StringStyle(.alignment(.center))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, query: { $0.alignment }, value: .center)
        }
    }

    func testNumberSpacingStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .numberSpacing(.monospaced))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[NSFontAttributeName] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[String: Int]] else {
                XCTFail("Failed to cast \(featureAttribute) as [[String: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kNumberSpacingType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kMonospacedNumbersSelector)
            }
        }
    }

    func testNumberCaseStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .numberCase(.lower))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[NSFontAttributeName] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[String: Int]] else {
                XCTFail("Failed to cast \(featureAttribute) as [[String: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kNumberCaseType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kLowerCaseNumbersSelector)
            }
        }
    }

    func testSuperscriptStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .superscript(true))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[NSFontAttributeName] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[String: Int]] else {
                XCTFail("Failed to cast \(featureAttribute) as [[String: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kVerticalPositionType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kSuperiorsSelector)
            }
        }
    }

    func testSubscriptStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .`subscript`(true))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[NSFontAttributeName] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[String: Int]] else {
                XCTFail("Failed to cast \(featureAttribute) as [[String: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kVerticalPositionType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kInferiorsSelector)
            }
        }
    }

    func testOrdinalsStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .ordinals(true))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[NSFontAttributeName] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[String: Int]] else {
                XCTFail("Failed to cast \(featureAttribute) as [[String: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kVerticalPositionType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kOrdinalsSelector)
            }
        }
    }

    func testScientificInferiorsStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .scientificInferiors(true))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[NSFontAttributeName] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[String: Int]] else {
                XCTFail("Failed to cast \(featureAttribute) as [[String: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kVerticalPositionType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kScientificInferiorsSelector)
            }
        }
    }

    func testFontFeatureStyle() {
        let features: [FontFeatureProvider] = [
            NumberCase.upper,
            NumberCase.lower,
            NumberSpacing.proportional,
            NumberSpacing.monospaced,
            VerticalPosition.superscript,
            VerticalPosition.subscript,
            VerticalPosition.ordinals,
            VerticalPosition.scientificInferiors,
        ]
        for feature in features {
            let attributes = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .fontFeature(feature)).attributes
            XCTAssertEqual(attributes.count, 1)
            let font = attributes[NSFontAttributeName] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
        }
    }

    static let floatingPointPropertiesLine = #line
    static let floatingPointProperties: [(NSParagraphStyle) -> CGFloat] = [
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
        let style = StringStyle(
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
        for (index, check) in StringStyleTests.floatingPointProperties.enumerated() {
            let line = UInt(StringStyleTests.floatingPointPropertiesLine + 2 + index)
            BONAssert(attributes: style.attributes, query: check, float: 10, accuracy: 0.001, line: line)
        }
        BONAssert(attributes: style.attributes, query: { $0.alignment }, value: .center)
        BONAssert(attributes: style.attributes, query: { $0.lineBreakMode }, value: .byClipping)
        BONAssert(attributes: style.attributes, query: { $0.baseWritingDirection }, value: .leftToRight)
    }

    func testParagraphStyleAdd() {
        var style = StringStyle(
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
        style.add(stringStyle: StringStyle(
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
        for (index, check) in StringStyleTests.floatingPointProperties.enumerated() {
            let line = UInt(StringStyleTests.floatingPointPropertiesLine + 2 + index)
            BONAssert(attributes: style.attributes, query: check, float: 10, accuracy: 0.001, line: line)
        }
        BONAssert(attributes: style.attributes, query: { $0.alignment }, value: .center)
        BONAssert(attributes: style.attributes, query: { $0.lineBreakMode }, value: .byClipping)
        BONAssert(attributes: style.attributes, query: { $0.baseWritingDirection }, value: .leftToRight)
    }

    func testAdobeTracking() {
        let style = StringStyle(.tracking(.adobe(300)))
        for (style, _) in additiviePermutations(for: style) {
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
        let style = StringStyle(.tracking(.point(10)))
        for (style, _) in additiviePermutations(for: style) {
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

    /// Return the result of various addititve operations with the passed style:
    /// - parameter for: the style to check
    /// - return: The additive style permutations.
    ///   - the passed style
    ///   - an empty style that is updated by the passed style object
    ///   - a fully populated style object that is updated by the passed style object
    func additiviePermutations(for style: StringStyle) -> [(style: StringStyle, fullStyle: Bool)] {
        var emptyStyle = StringStyle()
        emptyStyle.add(stringStyle: style)
        var updated = fullStyle
        updated.add(stringStyle: style)

        return [(style: style, fullStyle: false), (style: emptyStyle, fullStyle: false), (style: updated, fullStyle: true)]
    }

    func testStyleStylePart() {
        let baseStyle = StringStyle(.font(.fontA), .color(.colorA), .backgroundColor(.colorB))
        let style = StringStyle(.style(baseStyle), .font(.fontB), .color(.colorB))

        let font = style.attributes[NSFontAttributeName] as? BONFont
        XCTAssertEqual(font?.fontName, BONFont.fontB.fontName)
        XCTAssertEqual(font?.pointSize, BONFont.fontB.pointSize)
        BONAssert(attributes: style.attributes, key: NSForegroundColorAttributeName, value: BONColor.colorB)
        BONAssert(attributes: style.attributes, key: NSBackgroundColorAttributeName, value: BONColor.colorB)
    }

}
