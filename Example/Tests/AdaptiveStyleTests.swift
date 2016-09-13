//
//  AdaptiveStyleTests.swift
//
//  Created by Brian King on 9/2/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

#if swift(>=2.3)
@available(iOS 10.0, *)
let defaultTraitCollection = UITraitCollection(preferredContentSizeCategory: UIContentSizeCategoryLarge)

// These tests rely on iOS 10.0 APIs. Test method needs to be updated to run on iOS 9.0

@available(iOS 10.0, *)
class AdaptiveStyleTests: XCTestCase {

    func testFontControlSizeAdaption() {
        let inputFont = UIFont.systemFontOfSize(28)
        let style = BonMot(.font(inputFont), .adapt(.control))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: 25)
        BONAssert(attributes: testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: 26)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryMedium), query: { $0.pointSize }, float: 27)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryLarge), query: { $0.pointSize }, float: 28)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraLarge), query: { $0.pointSize }, float: 30)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraExtraLarge), query: { $0.pointSize }, float: 32)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraExtraExtraLarge), query: { $0.pointSize }, float: 34)

        // Ensure the accessibility ranges are capped at XXXL
        for size in [UIContentSizeCategoryAccessibilityMedium, UIContentSizeCategoryAccessibilityLarge, UIContentSizeCategoryAccessibilityExtraLarge, UIContentSizeCategoryAccessibilityExtraExtraLarge, UIContentSizeCategoryAccessibilityExtraExtraExtraLarge] {
            BONAssert(attributes: testAttributes(size), query: { $0.pointSize }, float: 34)
        }
    }

    func testFontBodySizeAdaption() {
        let inputFont = UIFont.systemFontOfSize(28)
        let style = BonMot(.font(inputFont), .adapt(.body))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: 25)
        BONAssert(attributes: testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: 26)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryMedium), query: { $0.pointSize }, float: 27)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryLarge), query: { $0.pointSize }, float: 28)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraLarge), query: { $0.pointSize }, float: 30)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraExtraLarge), query: { $0.pointSize }, float: 32)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraExtraExtraLarge), query: { $0.pointSize }, float: 34)

        // Ensure body keeps growing
        BONAssert(attributes: testAttributes(UIContentSizeCategoryAccessibilityMedium), query: { $0.pointSize }, float: 39)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryAccessibilityLarge), query: { $0.pointSize }, float: 44)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryAccessibilityExtraLarge), query: { $0.pointSize }, float: 51)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryAccessibilityExtraExtraLarge), query: { $0.pointSize }, float: 58)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryAccessibilityExtraExtraExtraLarge), query: { $0.pointSize }, float: 64)
    }

    func testPreferredFontDoesNotAdapt() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1, compatibleWithTraitCollection: defaultTraitCollection)
        let style = BonMot(.font(font))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: font.pointSize)
        BONAssert(attributes: testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: font.pointSize)
    }

    func testTextStyleAdapt() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1, compatibleWithTraitCollection: defaultTraitCollection)
        let style = BonMot(.textStyle(UIFontTextStyleTitle1))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: 25)
        BONAssert(attributes: testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: 26)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryMedium), query: { $0.pointSize }, float: 27)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryLarge), query: { $0.pointSize }, float: 28)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraLarge), query: { $0.pointSize }, float: 30)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraExtraLarge), query: { $0.pointSize }, float: 32)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraExtraExtraLarge), query: { $0.pointSize }, float: 34)
    }

    func testPreferredFontWithPreferredAdaptation() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1, compatibleWithTraitCollection: defaultTraitCollection)
        let style = BonMot(.font(font), .adapt(.preferred))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: 25)
        BONAssert(attributes: testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: 26)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryMedium), query: { $0.pointSize }, float: 27)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryLarge), query: { $0.pointSize }, float: 28)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraLarge), query: { $0.pointSize }, float: 30)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraExtraLarge), query: { $0.pointSize }, float: 32)
        BONAssert(attributes: testAttributes(UIContentSizeCategoryExtraExtraExtraLarge), query: { $0.pointSize }, float: 34)
    }

}

#endif
