//
//  AdaptiveStyleTests.swift
//  FinePrint
//
//  Created by Brian King on 9/2/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

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
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: 25)
        FPAssertFont(testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: 26)
        FPAssertFont(testAttributes(UIContentSizeCategoryMedium), query: { $0.pointSize }, float: 27)
        FPAssertFont(testAttributes(UIContentSizeCategoryLarge), query: { $0.pointSize }, float: 28)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraLarge), query: { $0.pointSize }, float: 30)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraExtraLarge), query: { $0.pointSize }, float: 32)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraExtraExtraLarge), query: { $0.pointSize }, float: 34)

        // Ensure the accessibility ranges are capped at XXXL
        for size in [UIContentSizeCategoryAccessibilityMedium, UIContentSizeCategoryAccessibilityLarge, UIContentSizeCategoryAccessibilityExtraLarge, UIContentSizeCategoryAccessibilityExtraExtraLarge, UIContentSizeCategoryAccessibilityExtraExtraExtraLarge] {
            FPAssertFont(testAttributes(size), query: { $0.pointSize }, float: 34)
        }
    }

    func testFontBodySizeAdaption() {
        let inputFont = UIFont.systemFontOfSize(28)
        let style = BonMot(.font(inputFont), .adapt(.body))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: 25)
        FPAssertFont(testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: 26)
        FPAssertFont(testAttributes(UIContentSizeCategoryMedium), query: { $0.pointSize }, float: 27)
        FPAssertFont(testAttributes(UIContentSizeCategoryLarge), query: { $0.pointSize }, float: 28)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraLarge), query: { $0.pointSize }, float: 30)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraExtraLarge), query: { $0.pointSize }, float: 32)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraExtraExtraLarge), query: { $0.pointSize }, float: 34)

        // Ensure body keeps growing
        FPAssertFont(testAttributes(UIContentSizeCategoryAccessibilityMedium), query: { $0.pointSize }, float: 39)
        FPAssertFont(testAttributes(UIContentSizeCategoryAccessibilityLarge), query: { $0.pointSize }, float: 44)
        FPAssertFont(testAttributes(UIContentSizeCategoryAccessibilityExtraLarge), query: { $0.pointSize }, float: 51)
        FPAssertFont(testAttributes(UIContentSizeCategoryAccessibilityExtraExtraLarge), query: { $0.pointSize }, float: 58)
        FPAssertFont(testAttributes(UIContentSizeCategoryAccessibilityExtraExtraExtraLarge), query: { $0.pointSize }, float: 64)
    }

    func testPreferredFontDoesNotAdapt() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1, compatibleWithTraitCollection: defaultTraitCollection)
        let style = BonMot(.font(font))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: font.pointSize)
        FPAssertFont(testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: font.pointSize)
    }

    func testTextStyleAdapt() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1, compatibleWithTraitCollection: defaultTraitCollection)
        let style = BonMot(.textStyle(UIFontTextStyleTitle1))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: 25)
        FPAssertFont(testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: 26)
        FPAssertFont(testAttributes(UIContentSizeCategoryMedium), query: { $0.pointSize }, float: 27)
        FPAssertFont(testAttributes(UIContentSizeCategoryLarge), query: { $0.pointSize }, float: 28)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraLarge), query: { $0.pointSize }, float: 30)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraExtraLarge), query: { $0.pointSize }, float: 32)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraExtraExtraLarge), query: { $0.pointSize }, float: 34)
    }

    func testPreferredFontWithPreferredAdaptation() {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1, compatibleWithTraitCollection: defaultTraitCollection)
        let style = BonMot(.font(font), .adapt(.preferred))
        func testAttributes(contentSizeCategory: BonMotContentSizeCategory) -> StyleAttributes {
            return style.styleAttributes(traitCollection: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        }
        // Ensure the font doesn't change sizes since it was added to the chain as a font, and `.preferred was not added.
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraSmall), query: { $0.pointSize }, float: 25)
        FPAssertFont(testAttributes(UIContentSizeCategorySmall), query: { $0.pointSize }, float: 26)
        FPAssertFont(testAttributes(UIContentSizeCategoryMedium), query: { $0.pointSize }, float: 27)
        FPAssertFont(testAttributes(UIContentSizeCategoryLarge), query: { $0.pointSize }, float: 28)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraLarge), query: { $0.pointSize }, float: 30)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraExtraLarge), query: { $0.pointSize }, float: 32)
        FPAssertFont(testAttributes(UIContentSizeCategoryExtraExtraExtraLarge), query: { $0.pointSize }, float: 34)
    }

}
