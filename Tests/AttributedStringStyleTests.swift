//
//  StringStyleTests.swift
//  BonMot
//
//  Created by Brian King on 8/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
@testable import BonMot
import CoreText

//swiftlint:disable file_length
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
            guard let font = style.attributes[.font] as? BONFont else {
                fatalError("font was nil or of wrong type.")
            }
            XCTAssertEqual(font.fontName, BONFont.fontA.fontName)
            XCTAssertEqual(font.pointSize, BONFont.fontA.pointSize)
            BONAssert(attributes: style.attributes, key: .foregroundColor, value: BONColor.colorA)
            BONAssert(attributes: style.attributes, key: .backgroundColor, value: BONColor.colorB)
        }
    }

    #if os(iOS) || os(tvOS)
    func testTextStyle() {
        let style = StringStyle(.textStyle(titleTextStyle))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[.font] as? UIFont
            let fontTextStyle = font?.textStyle
            XCTAssertEqual(fontTextStyle, titleTextStyle)
        }
    }
    #endif

    func testURL() {
        let url = URL(string: "http://apple.com/")!
        let style = StringStyle(.link(url))

        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: .link, value: url)
        }
    }

    func testStrikethroughStyle() {
        let style = StringStyle(.strikethrough(.byWord, .colorA))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 2)
            BONAssert(attributes: style.attributes, key: .strikethroughStyle, value: NSUnderlineStyle.byWord.rawValue)
            BONAssert(attributes: style.attributes, key: .strikethroughColor, value: BONColor.colorA)
        }
    }

    func testUnderlineStyle() {
        let style = StringStyle(.underline(.byWord, .colorA))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 2)
            BONAssert(attributes: style.attributes, key: .underlineStyle, value: NSUnderlineStyle.byWord.rawValue)
            BONAssert(attributes: style.attributes, key: .underlineColor, value: BONColor.colorA)
        }
    }

    func testBaselineStyle() {
        let style = StringStyle(.baselineOffset(15))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: .baselineOffset, float: CGFloat(15), accuracy: 0.001)
        }
    }

    func testLigatureStyle() {
        let style = StringStyle(.ligatures(.disabled))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: .ligature, value: 0)
        }
    }

    #if os(iOS) || os(tvOS) || os(watchOS)

    func testSpeaksPronunciationStyle() {
        let style = StringStyle(.speaksPunctuation(true))
        for (style, fullstyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullstyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: NSAttributedStringKey(UIAccessibilitySpeechAttributePunctuation), value: true)
        }
    }

    func testSpeakingLanguageStyle() {
        let style = StringStyle(.speakingLanguage("pt-BR"))
        for (style, fullstyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullstyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: NSAttributedStringKey(UIAccessibilitySpeechAttributeLanguage), value: "pt-BR")
        }
    }

    func testSpeakingPitchStyle() {
        let style = StringStyle(.speakingPitch(1.5))
        for (style, fullstyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullstyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, key: NSAttributedStringKey(UIAccessibilitySpeechAttributePitch), value: 1.5)
        }
    }

    func testPronuciationStyle() {
        if #available(iOS 11, tvOS 11, watchOS 4, *) {
            let style = StringStyle(.speakingPronunciation("ˈɡɪər"))
            for (style, fullstyle) in additiviePermutations(for: style) {
                XCTAssertTrue(fullstyle == true || style.attributes.count == 1)
                BONAssert(attributes: style.attributes, key: NSAttributedStringKey(UIAccessibilitySpeechAttributeIPANotation), value: "ˈɡɪər")
            }
        }
    }

    func testShouldQueueSpeechAnnouncement() {
        if #available(iOS 11, tvOS 11, watchOS 4, *) {
            let style = StringStyle(.shouldQueueSpeechAnnouncement(true))
            for (style, fullstyle) in additiviePermutations(for: style) {
                XCTAssertTrue(fullstyle == true || style.attributes.count == 1)
                BONAssert(attributes: style.attributes, key: NSAttributedStringKey(UIAccessibilitySpeechAttributeQueueAnnouncement), value: true as NSNumber)
            }
        }
    }

    func testHeadingLevel() {
        if #available(iOS 11, tvOS 11, watchOS 4, *) {
            let style = StringStyle(.headingLevel(.four))
            for (style, fullstyle) in additiviePermutations(for: style) {
                XCTAssertTrue(fullstyle == true || style.attributes.count == 1)
                BONAssert(attributes: style.attributes, key: NSAttributedStringKey(UIAccessibilityTextAttributeHeadingLevel), value: 4 as NSNumber)
            }
        }
    }

    #endif

    func testAlignmentStyle() {
        let style = StringStyle(.alignment(.center))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            BONAssert(attributes: style.attributes, query: { $0.alignment }, value: .center)
        }
    }

    func testNoKern() throws {
        let styled = "abcd".styled(with: .color(.red))

        let rangesToValuesLine = #line; let rangesToValues: [(NSRange, KernCheckingType)] = [
            (NSRange(location: 0, length: 4), .none),
            ]

        checkKerningValues(rangesToValues, startingOnLine: rangesToValuesLine, in: styled)
    }

    func testEffectOfAlignmentOnKerningForOneOffStrings() throws {
        let styled = "abcd".styled(with: .tracking(.point(5)))

        let rangesToValuesLine = #line; let rangesToValues: [(NSRange, KernCheckingType)] = [
            (NSRange(location: 0, length: 3), .kern(5)),
            (NSRange(location: 3, length: 1), .kernRemoved(5)),
            ]

        checkKerningValues(rangesToValues, startingOnLine: rangesToValuesLine, in: styled)
    }

    func testEffectOfAlignmentOnKerningForComposedStrings() throws {
        let styled = NSAttributedString.composed(of: [
            "ab".styled(with: .tracking(.point(5))),
            "cd".styled(with: .tracking(.point(10))),
            ])

        let rangesToValuesLine = #line; let rangesToValues: [(NSRange, KernCheckingType)] = [
            (NSRange(location: 0, length: 2), .kern(5)),
            (NSRange(location: 2, length: 1), .kern(10)),
            (NSRange(location: 3, length: 1), .kernRemoved(10)),
            ]

        checkKerningValues(rangesToValues, startingOnLine: rangesToValuesLine, in: styled)
    }

    func testEffectOfAlignmentOnKerningForStringsComposedOfOneOffStrings() throws {
        let abDefault = "ab".styled(with: .tracking(.point(5)))
        let cdDefault = "cd".styled(with: .tracking(.point(10)))
        let styled = NSAttributedString.composed(of: [abDefault, cdDefault])

        let rangesToValuesLine = #line; let rangesToValues: [(NSRange, KernCheckingType)] = [
            (NSRange(location: 0, length: 2), .kern(5)),
            (NSRange(location: 2, length: 1), .kern(10)),
            (NSRange(location: 3, length: 1), .kernRemoved(10)),
            ]

        checkKerningValues(rangesToValues, startingOnLine: rangesToValuesLine, in: styled)

        let abNoStrip = "ab".styled(with: .tracking(.point(5)), stripTrailingKerning: false)
        let cdExplicitStrip = "cd".styled(with: .tracking(.point(10)), stripTrailingKerning: true)
        let customStyled = NSAttributedString.composed(of: [abNoStrip, cdExplicitStrip])

        let customRangesToValuesLine = #line; let customRangesToValues: [(NSRange, KernCheckingType)] = [
            (NSRange(location: 0, length: 2), .kern(5)),
            (NSRange(location: 2, length: 1), .kern(10)),
            (NSRange(location: 3, length: 1), .kernRemoved(10)),
            ]

        checkKerningValues(customRangesToValues, startingOnLine: customRangesToValuesLine, in: customStyled)
    }

    func testNumberSpacingStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .numberSpacing(.monospaced))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
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
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kNumberCaseType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kLowerCaseNumbersSelector)
            }
        }
    }

    func testFractionsStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .fractions(.diagonal))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kFractionsType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kDiagonalFractionsSelector)
            }
        }
    }

    func testSuperscriptStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .superscript(true))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
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
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
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
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
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
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kVerticalPositionType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kScientificInferiorsSelector)
            }
        }
    }

    func testSmallCapsStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .smallCaps(.fromUppercase))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kUpperCaseType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kUpperCaseSmallCapsSelector)
            }
        }
    }

    func testStylisticAlternatesStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .stylisticAlternates(.two(on: true)))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kStylisticAlternativesType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kStylisticAltTwoOnSelector)
            }
        }
    }

    func testContextualAlternatesStyle() {
        let style = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .contextualAlternates(.contextualAlternates(on: false)))
        for (style, fullStyle) in additiviePermutations(for: style) {
            XCTAssertTrue(fullStyle == true || style.attributes.count == 1)
            let font = style.attributes[.font] as? BONFont
            XCTAssertNotNil(font)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute)
            guard let featuresArray = featureAttribute as? [[BONFontDescriptor.FeatureKey: Int]] else {
                XCTFail("Failed to cast \(String(describing: featureAttribute)) as [[BONFontDescriptor.FeatureKey: Int]]")
                return
            }

            if !fullStyle {
                XCTAssertEqual(featuresArray.count, 1)
                XCTAssertEqual(featuresArray[0][BONFontFeatureTypeIdentifierKey], kContextualAlternatesType)
                XCTAssertEqual(featuresArray[0][BONFontFeatureSelectorIdentifierKey], kContextualAlternatesOffSelector)
            }
        }
    }

    func testFontFeatureStyle() {
        let featuresLine: UInt = #line; let features: [FontFeatureProvider] = [
            NumberCase.upper,
            NumberCase.lower,
            NumberSpacing.proportional,
            NumberSpacing.monospaced,
            VerticalPosition.superscript,
            VerticalPosition.`subscript`,
            VerticalPosition.ordinals,
            VerticalPosition.scientificInferiors,
            SmallCaps.fromUppercase,
            SmallCaps.fromLowercase,
            StylisticAlternates.six(on: true),
        ]
        for (index, feature) in features.enumerated() {
            let featureLine = featuresLine + UInt(index) + 1
            let attributes = StringStyle(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .fontFeature(feature)).attributes
            XCTAssertEqual(attributes.count, 1, line: featureLine)
            let font = attributes[.font] as? BONFont
            XCTAssertNotNil(font, line: featureLine)
            let fontAttributes = font?.fontDescriptor.fontAttributes
            XCTAssertNotNil(fontAttributes, line: featureLine)
            let featureAttribute = fontAttributes?[BONFontDescriptorFeatureSettingsAttribute]
            XCTAssertNotNil(featureAttribute, line: featureLine)
        }
    }

    func testAdditiveFontFeatures() {
        let string = "0<one>1<two>2</two></one>"
        let font = BONFont(name: "EBGaramond12-Regular", size: 24)!
        let rules: [XMLStyleRule] = [
            .style("one", StringStyle(.stylisticAlternates(.two(on: true)), .stylisticAlternates(.six(on: true)), .smallCaps(.fromLowercase))),
            .style("two", StringStyle(.stylisticAlternates(.five(on: true)), .stylisticAlternates(.six(on: false)), .smallCaps(.disabled))),
        ]

        let attributed = string.styled(with: .font(font), .xmlRules(rules))
        XCTAssertEqual(attributed.string, "012")

        let attrs0 = attributed.attributes(at: 0, effectiveRange: nil)
        let attrs1 = attributed.attributes(at: 1, effectiveRange: nil)
        let attrs2 = attributed.attributes(at: 2, effectiveRange: nil)

        guard let font0 = attrs0[.font] as? BONFont else { XCTFail("font0 not found"); return }
        guard let font1 = attrs1[.font] as? BONFont else { XCTFail("font1 not found"); return }
        guard let font2 = attrs2[.font] as? BONFont else { XCTFail("font2 not found"); return }

        let descriptor0 = font0.fontDescriptor
        let descriptor1 = font1.fontDescriptor
        let descriptor2 = font2.fontDescriptor

        let descriptorAttrs0 = descriptor0.fontAttributes
        let descriptorAttrs1 = descriptor1.fontAttributes
        let descriptorAttrs2 = descriptor2.fontAttributes

        XCTAssertNil(descriptorAttrs0[BONFontDescriptorFeatureSettingsAttribute])

        guard let featuresArray1 = descriptorAttrs1[BONFontDescriptorFeatureSettingsAttribute] as? [[String: Any]] else {
            XCTFail("Failed to convert to \([[String: Any]].self)")
            return
        }
        guard let featuresArray2 = descriptorAttrs2[BONFontDescriptorFeatureSettingsAttribute] as? [[String: Any]] else {
            XCTFail("Failed to convert to \([[String: Any]].self)")
            return
        }

        XCTAssertEqual(featuresArray1.count, 3)
        XCTAssertEqual(featuresArray2.count, 2)

        let hasAltTwoDict = featuresArray1.contains { dictionary in
            return dictionary[kCTFontFeatureTypeIdentifierKey as String] as? Int == kStylisticAlternativesType
            && dictionary[kCTFontFeatureSelectorIdentifierKey as String] as? Int == kStylisticAltTwoOnSelector
        }
        XCTAssertTrue(hasAltTwoDict)

        let hasAltSixDict = featuresArray1.contains { dictionary in
            return dictionary[kCTFontFeatureTypeIdentifierKey as String] as? Int == kStylisticAlternativesType
                && dictionary[kCTFontFeatureSelectorIdentifierKey as String] as? Int == kStylisticAltSixOnSelector
        }
        XCTAssertTrue(hasAltSixDict)

        let hasSmallCapsFromLowercaseDict = featuresArray1.contains { dictionary in
            return dictionary[kCTFontFeatureTypeIdentifierKey as String] as? Int == kLowerCaseType
                && dictionary[kCTFontFeatureSelectorIdentifierKey as String] as? Int == kLowerCaseSmallCapsSelector
        }
        XCTAssertTrue(hasSmallCapsFromLowercaseDict)

        let array2StillHasAltTwoDict = featuresArray2.contains { dictionary in
            return dictionary[kCTFontFeatureTypeIdentifierKey as String] as? Int == kStylisticAlternativesType
                && dictionary[kCTFontFeatureSelectorIdentifierKey as String] as? Int == kStylisticAltTwoOnSelector
        }
        XCTAssertTrue(array2StillHasAltTwoDict)

        let hasAltFiveDict = featuresArray2.contains { dictionary in
            return dictionary[kCTFontFeatureTypeIdentifierKey as String] as? Int == kStylisticAlternativesType
                && dictionary[kCTFontFeatureSelectorIdentifierKey as String] as? Int == kStylisticAltFiveOnSelector
        }
        XCTAssertTrue(hasAltFiveDict)

        let stillHasAltSixDict = featuresArray2.contains { dictionary in
            return dictionary[kCTFontFeatureTypeIdentifierKey as String] as? Int == kStylisticAlternativesType
                && (dictionary[kCTFontFeatureSelectorIdentifierKey as String] as? Int == kStylisticAltSixOnSelector
                    || dictionary[kCTFontFeatureSelectorIdentifierKey as String] as? Int == kStylisticAltSixOffSelector)
        }
        XCTAssertFalse(stillHasAltSixDict)
    }

    static let floatingPointPropertiesLine = #line
    static let floatingPointProperties: [(NSParagraphStyle) -> CGFloat] = [
        //swiftlint:disable opening_brace
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
        //swiftlint:enable opening_brace
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
                return newStyle.attributes[.kern] as? CGFloat ?? 0
            }
            XCTAssertEqual(testKernAttribute(20), 6, accuracy: 0.0001)
            XCTAssertEqual(testKernAttribute(30), 9, accuracy: 0.0001)
            XCTAssertEqual(testKernAttribute(40), 12, accuracy: 0.0001)
            XCTAssertEqual(testKernAttribute(50), 15, accuracy: 0.0001)
        }
    }

    func testPointTracking() {
        let style = StringStyle(.tracking(.point(10)))
        for (style, _) in additiviePermutations(for: style) {
            let testKernAttribute = { (fontSize: CGFloat) -> CGFloat in
                let font = BONFont(name: "Avenir-Book", size: fontSize)!
                let newStyle = style.byAdding(.font(font))
                return newStyle.attributes[.kern] as? CGFloat ?? 0
            }
            XCTAssertEqual(testKernAttribute(20), 10, accuracy: 0.0001)
            XCTAssertEqual(testKernAttribute(30), 10, accuracy: 0.0001)
            XCTAssertEqual(testKernAttribute(40), 10, accuracy: 0.0001)
            XCTAssertEqual(testKernAttribute(50), 10, accuracy: 0.0001)
        }
    }

    /// Return the result of various addititve operations with the passed style:
    /// - parameter for: the style to check
    /// - returns: The additive style permutations:
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

        let font = style.attributes[.font] as? BONFont
        XCTAssertEqual(font?.fontName, BONFont.fontB.fontName)
        XCTAssertEqual(font?.pointSize, BONFont.fontB.pointSize)
        BONAssert(attributes: style.attributes, key: .foregroundColor, value: BONColor.colorB)
        BONAssert(attributes: style.attributes, key: .backgroundColor, value: BONColor.colorB)
    }

    func testOverridingProperties() {
        // Parent style is white with font A
        let parentStyle = StringStyle(.font(.fontA), .color(.white))
        BONAssertEqualFonts(parentStyle.font!, .fontA)
        XCTAssertEqual(parentStyle.color, .white)

        let parentAttributedString = "foo".styled(with: parentStyle)

        // Child style is black with font A
        let childStyle = parentStyle.byAdding(.color(.black))

        BONAssertEqualFonts(childStyle.font!, .fontA)
        XCTAssertEqual(childStyle.color, .black)

        let childAttributedString = parentAttributedString.styled(with: childStyle)
        let childAttributes = childAttributedString.attributes(at: 0, effectiveRange: nil)
        if let childFont = childAttributes[.font] as? BONFont {
            BONAssertEqualFonts(childFont, .fontA)
        }
        else {
            XCTFail("Font should not be nil")
        }

        // Child attributes should be overridden with black font
        BONAssert(attributes: childAttributes, key: .foregroundColor, value: BONColor.black)
    }

}

private extension StringStyleTests {

    enum KernCheckingType {
        case none
        case kern(Double)
        case kernRemoved(Double)
    }

    func checkKerningValues(_ rangesToValues: [(NSRange, KernCheckingType)], startingOnLine rangesToValuesLine: Int, in string: NSAttributedString) {
        for (index, rangeToValue) in rangesToValues.enumerated() {

            let line = UInt(rangesToValuesLine + index + 1)

            let (controlRange, checkingType) = rangeToValue

            let trackingValue = string.attribute(.kern, at: controlRange.location, effectiveRange: nil)
            let trackingRemovedValue = string.attribute(.bonMotRemovedKernAttribute, at: controlRange.location, effectiveRange: nil)

            switch checkingType {
            case .none:
                XCTAssertNil(trackingValue, line: line)
                XCTAssertNil(trackingRemovedValue, line: line)
            case .kern(let kernValue):
                guard let trackingValueNumber = trackingValue as? NSNumber else {
                    XCTFail("Unable to unwrap tracking value \(String(describing: trackingValue)) as Double", line: line)
                    return
                }
                XCTAssertEqual(kernValue, trackingValueNumber.doubleValue, accuracy: 0.0001, line: line)
                XCTAssertNil(trackingRemovedValue, line: line)
            case .kernRemoved(let kernRemovedValue):
                guard let trackingRemovedValueNumber = trackingRemovedValue as? NSNumber else {
                    XCTFail("Unable to unwrap tracking removed value \(String(describing: trackingValue)) as Double", line: line)
                    return
                }
                XCTAssertEqual(kernRemovedValue, trackingRemovedValueNumber.doubleValue, accuracy: 0.0001, line: line)
                XCTAssertNil(trackingValue, line: line)
            }
        }
    }

}

//swiftlint:enable file_length
