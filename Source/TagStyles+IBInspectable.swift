//
//  TagStyles+IBInspectable.swift
//
//  Created by Brian King on 8/30/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

extension UILabel {
    /// Configure the view with the specified style based on the currently configured font.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set { bonMotStyle = TagStyles.shared.style(forName:newValue, initialAttributes: [NSFontAttributeName: font]) }
    }
}

extension UITextField {
    /// Configure the view with the specified style based on the currently configured font. Note that the style is applied to both
    /// the text and placeholder text. If you plan on styling them differently, use attributed strings.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set {
            guard let font = font else { fatalError("Unable to get the font. This is unexpected, see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = TagStyles.shared.style(forName:newValue, initialAttributes: [NSFontAttributeName: font])
        }
    }
}

extension UITextView {
    /// Configure the view with the specified style based on the currently configured font.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set {
            // If the text property is not and has not been set, the font property is nil.
            // Configure an empty space if this happens. 
            if font == nil && text.lengthOfBytes(using: String.Encoding.utf8) == 0 {
                text = "\(Special.zeroWidthSpace)"
            }
            guard let font = font else { fatalError("Unable to get the font. This is unexpected, see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = TagStyles.shared.style(forName:newValue, initialAttributes: [NSFontAttributeName: font])
        }
    }
}

extension UIButton {
    /// Configure the view with the specified style based on the currently configured font.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set {
            guard let font = titleLabel?.font else { fatalError("Unable to get the font. This is unexpected, see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = TagStyles.shared.style(forName:newValue, initialAttributes: [NSFontAttributeName: font])
        }
    }
}
