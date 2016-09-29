//
//  AdaptiveStyleTests.swift
//
//  Created by Brian King on 9/2/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import UIKit
import BonMot

#if swift(>=2.3) && os(iOS)

@available(iOS 10.0, *)
let defaultTraitCollection = UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory.large.compatible)

// These tests rely on iOS 10.0 APIs. Test method needs to be updated to run on iOS 9.0
@available(iOS 10.0, *)
class AdaptiveStyleTests: XCTestCase {

    func testFontControlSizeAdaption() {
        let inputFont = UIFont(name: "Avenir-Book", size: 28)!
        let style = BonMot(.font(inputFont), .adapt(.control))
        print(style.attributes())
        let testAttributes = { (contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes in
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
            return NSAttributedString.adapt(attributes: style.attributes(), to: traitCollection)
        }
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraSmall.compatible), query: { $0.pointSize }, float: 25)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.small.compatible), query: { $0.pointSize }, float: 26)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.medium.compatible), query: { $0.pointSize }, float: 27)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.large.compatible), query: { $0.pointSize }, float: 28)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraLarge.compatible), query: { $0.pointSize }, float: 30)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraExtraLarge.compatible), query: { $0.pointSize }, float: 32)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraExtraExtraLarge.compatible), query: { $0.pointSize }, float: 34)

        // Ensure the accessibility ranges are capped at XXXL
        for size in [UIContentSizeCategory.accessibilityMedium.compatible,
                     UIContentSizeCategory.accessibilityLarge.compatible,
                     UIContentSizeCategory.accessibilityExtraLarge.compatible,
                     UIContentSizeCategory.accessibilityExtraExtraLarge.compatible,
                     UIContentSizeCategory.accessibilityExtraExtraExtraLarge.compatible] {
            BONAssert(attributes: testAttributes(size), query: { $0.pointSize }, float: 34)
        }
    }

    func testFontBodySizeAdaption() {
        let inputFont = UIFont(name: "Avenir-Book", size: 28)!
        let style = BonMot(.font(inputFont), .adapt(.body))
        let testAttributes = { (contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes in
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
            let attributes = style.attributes()
            return NSAttributedString.adapt(attributes: attributes, to: traitCollection)
        }
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraSmall.compatible), query: { $0.pointSize }, float: 25)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.small.compatible), query: { $0.pointSize }, float: 26)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.medium.compatible), query: { $0.pointSize }, float: 27)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.large.compatible), query: { $0.pointSize }, float: 28)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraLarge.compatible), query: { $0.pointSize }, float: 30)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraExtraLarge.compatible), query: { $0.pointSize }, float: 32)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraExtraExtraLarge.compatible), query: { $0.pointSize }, float: 34)

        // Ensure body keeps growing
        BONAssert(attributes: testAttributes(UIContentSizeCategory.accessibilityMedium.compatible), query: { $0.pointSize }, float: 39)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.accessibilityLarge.compatible), query: { $0.pointSize }, float: 44)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.accessibilityExtraLarge.compatible), query: { $0.pointSize }, float: 51)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.accessibilityExtraExtraLarge.compatible), query: { $0.pointSize }, float: 58)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.accessibilityExtraExtraExtraLarge.compatible), query: { $0.pointSize }, float: 64)
    }

    func testPreferredFontDoesNotAdapt() {
        let font = UIFont.preferredFont(forTextStyle: titleTextStyle, compatibleWith: defaultTraitCollection)
        let style = BonMot(.font(font))
        let testAttributes = { (contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes in
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
            return NSAttributedString.adapt(attributes: style.attributes(), to: traitCollection)
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraSmall.compatible), query: { $0.pointSize }, float: font.pointSize)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.small.compatible), query: { $0.pointSize }, float: font.pointSize)
    }

    func testTextStyleAdapt() {
        let style = BonMot(.textStyle(titleTextStyle), .adapt(.preferred))
        let testAttributes = { (contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes in
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
            return NSAttributedString.adapt(attributes: style.attributes(), to: traitCollection)
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraSmall.compatible), query: { $0.pointSize }, float: 25)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.small.compatible), query: { $0.pointSize }, float: 26)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.medium.compatible), query: { $0.pointSize }, float: 27)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.large.compatible), query: { $0.pointSize }, float: 28)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraLarge.compatible), query: { $0.pointSize }, float: 30)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraExtraLarge.compatible), query: { $0.pointSize }, float: 32)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraExtraExtraLarge.compatible), query: { $0.pointSize }, float: 34)
    }

    func testPreferredFontWithPreferredAdaptation() {
        let font = UIFont.preferredFont(forTextStyle: titleTextStyle, compatibleWith: defaultTraitCollection)
        let style = BonMot(.font(font), .adapt(.preferred))
        let testAttributes = { (contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes in
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
            return NSAttributedString.adapt(attributes: style.attributes(), to: traitCollection)
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraSmall.compatible), query: { $0.pointSize }, float: 25)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.small.compatible), query: { $0.pointSize }, float: 26)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.medium.compatible), query: { $0.pointSize }, float: 27)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.large.compatible), query: { $0.pointSize }, float: 28)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraLarge.compatible), query: { $0.pointSize }, float: 30)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraExtraLarge.compatible), query: { $0.pointSize }, float: 32)
        BONAssert(attributes: testAttributes(UIContentSizeCategory.extraExtraExtraLarge.compatible), query: { $0.pointSize }, float: 34)
    }

    func testAdobeAdaptiveTracking() {
        let font = UIFont(name: "Avenir-Book", size: 30)!
        let chain = BonMot(.font(font), .adapt(.control), .tracking(.adobe(300)))
        let attributes = chain.style(attributes: [NSFontAttributeName: font])

        let testKernAdaption = { (contentSizeCategory: BonMotContentSizeCategory) -> CGFloat in
            let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)
            let adaptedAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
            return adaptedAttributes[NSKernAttributeName] as? CGFloat ?? 0
        }

        XCTAssertEqualWithAccuracy(testKernAdaption(UIContentSizeCategory.extraSmall.compatible), 8.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(testKernAdaption(UIContentSizeCategory.large.compatible), 9, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(testKernAdaption(UIContentSizeCategory.extraExtraExtraLarge.compatible), 10.8, accuracy: 0.0001)
    }

    /// Test that font feature settings overrides persist through
    /// Dynamic Type adaptation
    func testFeatureSettingsAdaptation() {
        EBGaramondLoader.loadFontIfNeeded()
        let features: [FontFeatureProvider] = [NumberCase.upper, NumberCase.lower, NumberSpacing.proportional, NumberSpacing.monospaced]
        for feature in features {
            let originalAttributes = BonMot(.font(BONFont(name: "EBGaramond12-Regular", size: 24)!), .fontFeature(feature), .adapt(.control)).attributes()
            let adaptedAttributes = NSAttributedString.adapt(attributes: originalAttributes, to: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory.extraSmall.compatible))

            XCTAssertEqual(originalAttributes.count, 3)
            XCTAssertEqual(adaptedAttributes.count, 3)

            let originalFont = originalAttributes[NSFontAttributeName] as? BONFont
            let adaptedFont = adaptedAttributes[NSFontAttributeName] as? BONFont

            XCTAssertNotNil(originalFont)
            XCTAssertNotNil(adaptedFont)

            let originalDescriptorAttributes = originalFont?.fontDescriptor.fontAttributes
            let adaptedDescriptorAttributes = adaptedFont?.fontDescriptor.fontAttributes

            let originalFeatureAttributeArray = originalDescriptorAttributes?[BONFontDescriptorFeatureSettingsAttribute] as? NSArray
            let adaptedFeatureAttributeArray = adaptedDescriptorAttributes?[BONFontDescriptorFeatureSettingsAttribute] as? NSArray

            XCTAssertNotNil(originalFeatureAttributeArray)
            XCTAssertNotNil(adaptedFeatureAttributeArray)

            XCTAssertEqual(originalFeatureAttributeArray?.count, 1)
            XCTAssertEqual(adaptedFeatureAttributeArray?.count, 1)

            let originalFeatureAttributes = originalFeatureAttributeArray?.firstObject as? [String: Int]
            let adaptedFeatureAttributes = adaptedFeatureAttributeArray?.firstObject as? [String: Int]

            XCTAssertNotNil(originalFeatureAttributes)
            XCTAssertNotNil(adaptedFeatureAttributes)

            XCTAssertEqual(originalFeatureAttributes?[BONFontFeatureTypeIdentifierKey], adaptedFeatureAttributes?[BONFontFeatureTypeIdentifierKey])
            XCTAssertEqual(originalFeatureAttributes?[BONFontFeatureSelectorIdentifierKey], adaptedFeatureAttributes?[BONFontFeatureSelectorIdentifierKey])
        }
    }

    func testTabAdaptation() {
        func firstTabLocation(attributedString string: NSAttributedString) -> CGFloat {
            guard let paragraph = string.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil) as? NSParagraphStyle else {
                XCTFail("Unable to get paragraph")
                return 0
            }
            return paragraph.tabStops[0].location
        }
        EBGaramondLoader.loadFontIfNeeded()
        let style = BonMot(.font(BONFont(name: "EBGaramond12-Regular", size: 20)!), .fontFeature(NumberSpacing.monospaced), .adapt(.control))
        let tabTestL = NSAttributedString.compose(with: ["Q", Tab.headIndent(10)], baseStyle: style)
        XCTAssertEqualWithAccuracy(firstTabLocation(attributedString: tabTestL), 26.12, accuracy: 0.01)
        let tabTestXS = tabTestL.adapt(to: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory.extraSmall.compatible))
        XCTAssertEqualWithAccuracy(firstTabLocation(attributedString: tabTestXS), 23.70, accuracy: 0.01)
        let tabTestXXXL = tabTestL.adapt(to: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory.extraExtraExtraLarge.compatible))
        XCTAssertEqualWithAccuracy(firstTabLocation(attributedString: tabTestXXXL), 30.95, accuracy: 0.01)
    }

}

#endif
