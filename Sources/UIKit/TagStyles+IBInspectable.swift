//
//  TagStyles+IBInspectable.swift
//
//  Created by Brian King on 8/30/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

func lookupSharedStyle(for name: String?, font: UIFont) -> AttributedStringStyle? {
    guard let name = name, let style = TagStyles.shared.style(forName: name) else {
        return nil
    }
    // Create a style with the font and then add the named style. 
    // This will provide a font if one is not specified in the style.
    return AttributedStringStyle.style(.font(font)).derive(attributedStringStyle: style)
}

extension UILabel {
    /// Configure the view with the specified style based on the currently configured font. The getter will always return nil.
    @IBInspectable @objc(bon_styleName)
    public var styleName: String? {
        get { return nil }
        set { bonMotStyle = lookupSharedStyle(for: newValue, font: font) }
    }
}

extension UITextField {
    /// Configure the view with the specified style based on the currently configured font. The getter will always return nil.
    ///
    /// NOTE: he style is applied to both the text and placeholder text. If you plan on styling them differently, use attributed strings.
    @IBInspectable @objc(bon_styleName)
    public var styleName: String? {
        get { return nil }
        set {
            guard let font = font else { fatalError("Unable to get the font. This is unexpected, see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = lookupSharedStyle(for: newValue, font: font)
        }
    }
}

extension UITextView {
    /// Configure the view with the specified style based on the currently configured font. The getter will always return nil.
    ///
    /// NOTE: This will configure a zero width space in the text property if the font has never been set to obtain the default font behavior. See UIKitTests.testTextFieldPropertyBehavior for more information.
    @IBInspectable @objc(bon_styleName)
    public var styleName: String? {
        get { return nil }
        set {
            let font: UIFont
            if let configuredFont = self.font {
                font = configuredFont
            }
            else {
                // If the text property is not and has not been set, the font property is nil. Use the platform specific default values here
                // See UIKitTests.testTextFieldPropertyBehavior
                #if os(iOS)
                    font = UIFont.systemFont(ofSize: 12)
                #elseif os(tvOS)
                    font = UIFont.systemFont(ofSize: 38)
                #else
                    fatalError("Unsupported Mystery Platform")
                #endif
            }
            bonMotStyle = lookupSharedStyle(for: newValue, font: font)
        }
    }
}

extension UIButton {
    /// Configure the view with the specified style based on the currently configured font. The getter will always return nil.
    @IBInspectable @objc(bon_styleName)
    public var styleName: String? {
        get { return nil }
        set {
            guard let font = titleLabel?.font else { fatalError("Unable to get the font. This is unexpected, see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = lookupSharedStyle(for: newValue, font: font)
        }
    }
}
