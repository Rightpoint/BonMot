//
//  UIKitBehaviorTests.swift
//
//  Created by Brian King on 8/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest

class UIKitBehaviorTests: XCTestCase {

    func testLabelPropertyBehavior() {
        let largeFont = UIFont(name: "Avenir-Roman", size: 20)
        let smallFont = UIFont(name: "Avenir-Roman", size: 10)
        let label = UILabel()
        label.font = largeFont
        label.text = "Testing"

        // Ensure font information is mirrored in attributed string
        let attributedText = label.attributedText!
        let attributeFont = attributedText.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as? UIFont
        XCTAssertEqual(attributeFont, largeFont)

        // Change the font in the attributed string
        var attributes = attributedText.attributesAtIndex(0, effectiveRange: nil)
        attributes[NSFontAttributeName] = smallFont
        label.attributedText = NSAttributedString(string: "Testing", attributes: attributes)
        // Note that the font property is updated.
        XCTAssertEqual(label.font, smallFont)

        // Change the text of the label
        label.text = "Testing"
        // Note that this reverts to the original font.
        XCTAssertEqual(label.font, largeFont)
        // When text changes, it updates the font to the last font set to self.font
        // The getter for self.font returns the visible font.
    }

    func testTextFieldFontPropertyBehavior() {
        let largeFont = UIFont(name: "Avenir-Roman", size: 20)
        let textField = UITextField()
        // Note that the font is not nil before the text property is set.
        XCTAssertNotNil(textField.font)
        textField.text = "Testing"
        // By default the font is not nil, size 17 (Not 12 as stated in header)
        XCTAssertNotNil(textField.font)
        XCTAssertEqual(textField.font?.pointSize, 17)

        textField.font = largeFont
        XCTAssertEqual(textField.font?.pointSize, 20)

        textField.font = nil
        // Note that font has a default value even though it's optional.
        XCTAssertNotNil(textField.font)
        XCTAssertEqual(textField.font?.pointSize, 17)
    }
    
    func testTextViewFontPropertyBehavior() {
        let largeFont = UIFont(name: "Avenir-Roman", size: 20)
        let textField = UITextView()
        // Note that the font *is* nil before the text property is set.
        XCTAssertNil(textField.font)
        textField.text = "Testing"
        // By default the font is nil
        XCTAssertNotNil(textField.font)
        XCTAssertEqual(textField.font?.pointSize, 12)

        textField.font = largeFont
        XCTAssertEqual(textField.font?.pointSize, 20)

        textField.font = nil
        // Note that font is not re-set like TextField()
        XCTAssertNil(textField.font)
    }
    
    func testButtonFontPropertyBehavior() {
        let button = UIButton()

        XCTAssertNotNil(button.titleLabel)
        XCTAssertNotNil(button.titleLabel?.font)
        XCTAssertNil(button.titleLabel?.attributedText)
    }

    // Check to see if arbitrary text survives re-configuration (Spoiler: It doesn't)
    func testLabelAttributedStringAttributePreservationBehavior() {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "", attributes: ["TestAttribute": true])
        label.text = "New Text"
        label.font = UIFont(name: "Avenir-Roman", size: 10)
        let attributes = label.attributedText?.attributesAtIndex(0, effectiveRange: nil)
        XCTAssertNotNil(attributes)
        XCTAssertNil(attributes?["TestAttribute"])
    }
}
