//
//  UIKitBonMotTests.swift
//  FinePrint
//
//  Created by Brian King on 9/3/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
@testable import BonMot

class UIKitBonMotTests: XCTestCase {
    let expectedFont = adaptiveStyle.font!

    override static func setUp() {
        super.setUp()
        TagStyles.shared.registerStyle(forName: "adaptiveStyle", style: adaptiveStyle)
    }
    func testStyleNameGetters() {
        XCTAssertNil(UILabel().bonMotStyleName)
        XCTAssertNil(UITextField().bonMotStyleName)
        XCTAssertNil(UITextView().bonMotStyleName)
        XCTAssertNil(UIButton().bonMotStyleName)
    }

    func testLabelExtensions() {
        let label = UILabel()
        // Make sure the test is valid and the font is different
        XCTAssertNotEqual(label.font, expectedFont)

        // Assign a style by name and ensure the lookup succeeds
        label.bonMotStyleName = "adaptiveStyle"
        XCTAssertNotNil(label.bonMotStyle)

        // Assign the styled text and ensure text and the attributedText is updated
        label.styledText = "."
        XCTAssertEqual(label.styledText, label.text)
        XCTAssertEqual(label.attributedText?.attributes(at: 0, effectiveRange: nil)[NSFontAttributeName] as? UIFont, expectedFont)

        // Update the trait collection and ensure the font grows.
        if #available(iOS 10.0, *) {
            label.updateText(forTraitCollection: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategoryExtraLarge))
            FPAssertFont(label.attributedText?.attributes(at: 0, effectiveRange: nil), query: { $0.pointSize }, float: expectedFont.pointSize + 2)
        }
    }

    func testTextFieldExtensions() {
        let textField = UITextField()
        // Make sure the test is valid and the font is different
        XCTAssertNotEqual(textField.font, expectedFont)

        // Assign a style by name and ensure the lookup succeeds
        textField.bonMotStyleName = "adaptiveStyle"
        XCTAssertNotNil(textField.bonMotStyle)

        // Assign the styled text and ensure text and the attributedText is updated
        textField.styledText = "."
        XCTAssertEqual(textField.styledText, textField.text)
        XCTAssertEqual(textField.attributedText?.attributes(at: 0, effectiveRange: nil)[NSFontAttributeName] as? UIFont, expectedFont)

        // Update the trait collection and ensure the font grows.
        if #available(iOS 10.0, *) {
            textField.updateText(forTraitCollection: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategoryExtraLarge))
            FPAssertFont(textField.attributedText?.attributes(at: 0, effectiveRange: nil), query: { $0.pointSize }, float: expectedFont.pointSize + 2)
        }
    }

    func testTextView() {
        let textView = UITextView()
        // Make sure the test is valid and the font is different
        XCTAssertNotEqual(textView.font, expectedFont)

        // Assign a style by name and ensure the lookup succeeds
        textView.bonMotStyleName = "adaptiveStyle"
        XCTAssertNotNil(textView.bonMotStyle)

        // Assign the styled text and ensure text and the attributedText is updated
        textView.styledText = "."
        XCTAssertEqual(textView.styledText, textView.text)
        XCTAssertEqual(textView.attributedText?.attributes(at: 0, effectiveRange: nil)[NSFontAttributeName] as? UIFont, expectedFont)

        // Update the trait collection and ensure the font grows.
        if #available(iOS 10.0, *) {
            textView.updateText(forTraitCollection: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategoryExtraLarge))
            FPAssertFont(textView.attributedText?.attributes(at: 0, effectiveRange: nil), query: { $0.pointSize }, float: expectedFont.pointSize + 2)
        }
    }

    func testButton() {
        let button = UIButton()
        // Make sure the test is valid and the font is different
        XCTAssertNotEqual(button.titleLabel?.font, expectedFont)

        // Assign a style by name and ensure the lookup succeeds
        button.bonMotStyleName = "adaptiveStyle"
        XCTAssertNotNil(button.bonMotStyle)

        // Assign the styled text and ensure text and the attributedText is updated
        button.setStyledText(".", forState: .Normal)
        var attributes = button.attributedTitleForState(.Normal)?.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes?[NSFontAttributeName] as? UIFont, expectedFont)

        // Update the trait collection and ensure the font grows.
        if #available(iOS 10.0, *) {
            button.updateText(forTraitCollection: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategoryExtraLarge))
            attributes = button.attributedTitleForState(.Normal)?.attributes(at: 0, effectiveRange: nil)
            FPAssertFont(attributes, query: { $0.pointSize }, float: expectedFont.pointSize + 2)
        }
    }

    func writeTestSegmentedControl() {}
    func writeTestNavigationBar() {}
    func writeTestToolbar() {}
    func writeTestViewController() {}
    func writeTestBarButtonItem() {}

}
