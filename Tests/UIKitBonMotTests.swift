//
//  UIKitBonMotTests.swift
//
//  Created by Brian King on 9/3/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

#if swift(>=2.3)

class UIKitBonMotTests: XCTestCase {
    let expectedFont = adaptiveStyle.font!

    override static func setUp() {
        super.setUp()
        TagStyles.shared.registerStyle(forName: "adaptiveStyle", style: adaptiveStyle)
    }
    func testStyleNameGetters() {
        XCTAssertNil(UILabel().styleName)
        XCTAssertNil(UITextField().styleName)
        XCTAssertNil(UITextView().styleName)
        XCTAssertNil(UIButton().styleName)
    }

    func testLabelExtensions() {
        let label = UILabel()
        // Make sure the test is valid and the font is different
        XCTAssertNotEqual(label.font, expectedFont)

        // Assign a style by name and ensure the lookup succeeds
        label.styleName = "adaptiveStyle"
        XCTAssertNotNil(label.bonMotStyle)

        // Assign the styled text and ensure text and the attributedText is updated
        label.styledText = "."
        XCTAssertEqual(label.styledText, label.text)
        XCTAssertEqual(label.attributedText?.attributes(at: 0, effectiveRange: nil)[NSFontAttributeName] as? UIFont, expectedFont)

        // Update the trait collection and ensure the font grows.
        if #available(iOS 10.0, *) {
            label.updateText(forTraitCollection: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory.extraLarge.compatible))
            BONAssert(attributes: label.attributedText?.attributes(at: 0, effectiveRange: nil), query: { $0.pointSize }, float: expectedFont.pointSize + 2)
        }
    }

    func testTextFieldExtensions() {
        let textField = UITextField()
        // Make sure the test is valid and the font is different
        XCTAssertNotEqual(textField.font, expectedFont)

        // Assign a style by name and ensure the lookup succeeds
        textField.styleName = "adaptiveStyle"
        XCTAssertNotNil(textField.bonMotStyle)

        // Assign the styled text and ensure text and the attributedText is updated
        textField.styledText = "."
        XCTAssertEqual(textField.styledText, textField.text)
        XCTAssertEqual(textField.attributedText?.attributes(at: 0, effectiveRange: nil)[NSFontAttributeName] as? UIFont, expectedFont)

        // Update the trait collection and ensure the font grows.
        if #available(iOS 10.0, *) {
            textField.updateText(forTraitCollection: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory.extraLarge.compatible))
            BONAssert(attributes: textField.attributedText?.attributes(at: 0, effectiveRange: nil), query: { $0.pointSize }, float: expectedFont.pointSize + 2)
        }
    }

    func testTextView() {
        let textView = UITextView()
        // Make sure the test is valid and the font is different
        XCTAssertNotEqual(textView.font, expectedFont)

        // Assign a style by name and ensure the lookup succeeds
        textView.styleName = "adaptiveStyle"
        XCTAssertNotNil(textView.bonMotStyle)

        // Assign the styled text and ensure text and the attributedText is updated
        textView.styledText = "."
        XCTAssertEqual(textView.styledText, textView.text)
        XCTAssertEqual(textView.attributedText?.attributes(at: 0, effectiveRange: nil)[NSFontAttributeName] as? UIFont, expectedFont)

        // Update the trait collection and ensure the font grows.
        if #available(iOS 10.0, *) {
            textView.updateText(forTraitCollection: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory.extraLarge.compatible))
            BONAssert(attributes: textView.attributedText?.attributes(at: 0, effectiveRange: nil), query: { $0.pointSize }, float: expectedFont.pointSize + 2)
        }
    }

    func testButton() {
        let button = UIButton()
        // Make sure the test is valid and the font is different
        XCTAssertNotEqual(button.titleLabel?.font, expectedFont)

        // Assign a style by name and ensure the lookup succeeds
        button.styleName = "adaptiveStyle"
        XCTAssertNotNil(button.bonMotStyle)
        // Assign the styled text and ensure text and the attributedText is updated
        button.setStyledText(".", forState: .normal)
        var attributes = button.attributedTitle(for: .normal)?.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes?[NSFontAttributeName] as? UIFont, expectedFont)

        // Update the trait collection and ensure the font grows.
        if #available(iOS 10.0, *) {
            button.updateText(forTraitCollection: UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory.extraLarge.compatible))
            attributes = button.attributedTitle(for: .normal)?.attributes(at: 0, effectiveRange: nil)
            BONAssert(attributes: attributes, query: { $0.pointSize }, float: expectedFont.pointSize + 2)
        }
    }

    func writeTestSegmentedControl() {}
    func writeTestNavigationBar() {}
    func writeTestToolbar() {}
    func writeTestViewController() {}
    func writeTestBarButtonItem() {}

}

#endif
