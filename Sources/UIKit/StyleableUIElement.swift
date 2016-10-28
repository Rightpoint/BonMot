//
//  StyleableUIElement.swift
//
//  Created by Brian King on 8/11/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

/// Protocol to assist styling text contained in UI Elements.
public protocol StyleableUIElement: UITraitEnvironment {
    var bonMotStyleName: String? { get set }
    var bonMotStyle: StringStyle? { get set }
    var styledText: String? { get set }
}

extension UILabel: StyleableUIElement {

    /// Configure the view with the specified style based on the currently configured font. The getter will always return nil.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set { bonMotStyle = lookupSharedStyle(for: newValue, font: font) }
    }

    /// Specify the style to use for the UILabel.
    public final var bonMotStyle: StringStyle? {
        get { return getAssociatedStyle() }
        set {
            setAssociatedStyle(bonMotStyle: newValue)
            styledText = text
        }
    }

    /// Create a new NSAttributedString using the specified string and the bonMotStyle property, and assign it to the attributedText property
    @objc(bon_styledText)
    public var styledText: String? {
        get { return attributedText?.string }
        set { attributedText = styledAttributedString(from: newValue) }
    }
}

extension UITextField: StyleableUIElement {

    /// Configure the view with the specified style based on the currently configured font. The getter will always return nil.
    ///
    /// NOTE: he style is applied to both the text and placeholder text. If you plan on styling them differently, use attributed strings.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set {
            guard let font = font else { fatalError("Unable to get the font. This is unexpected, see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = lookupSharedStyle(for: newValue, font: font)
        }
    }

    /// Specify the style to use for text contained inside the view.
    ///
    /// NOTE: This will update the defaultTextAttributes and attributedText. Use attributed strings for more control.
    public final var bonMotStyle: StringStyle? {
        get { return getAssociatedStyle() }
        set {
            setAssociatedStyle(bonMotStyle: newValue)
            styledText = text
            defaultTextAttributes = bonMotStyle?.attributes(adaptedTo: traitCollection) ?? [:]
        }
    }

    /// Create a new NSAttributedString using the specified string and the bonMotStyle property, and assign it to the attributedText property
    @objc(bon_styledText)
    public var styledText: String? {
        get { return attributedText?.string }
        set {
            let styledText = styledAttributedString(from: newValue)
            // Avoid a bug that causes the UITextField to hang
            if let styledText = styledText {
                if styledText.length > 0 {
                    font = styledText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
                }
            }
            attributedText = styledText
        }
    }
}

extension UITextView: StyleableUIElement {

    /// Configure the view with the specified style based on the currently configured font. The getter will always return nil.
    ///
    /// NOTE: This will configure a zero width space in the text property if the font has never been set to obtain the default font behavior. See UIKitTests.testTextFieldPropertyBehavior for more information.
    @IBInspectable
    public var bonMotStyleName: String? {
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

    /// Specify the style to use for text contained inside the view. This will trigger AdaptableTextContainer.adaptText(forTraitCollection:) to
    /// update the current state of the view
    ///
    /// NOTE: This will update the typingAttributes and attributedText. Use attributed strings for more control.
    public final var bonMotStyle: StringStyle? {
        get { return getAssociatedStyle() }
        set {
            setAssociatedStyle(bonMotStyle: newValue)
            typingAttributes = newValue?.attributes(adaptedTo: traitCollection) ?? typingAttributes
            styledText = text
        }
    }

    /// Create a new NSAttributedString using the specified string and the bonMotStyle property, and assign it to the attributedText property
    @objc(bon_styledText)
    public var styledText: String? {
        get { return attributedText?.string }
        set {
            attributedText = styledAttributedString(from: newValue)
        }
    }
}

extension UIButton: StyleableUIElement {

    /// Configure the view with the specified style based on the currently configured font. The getter will always return nil.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set {
            guard let font = titleLabel?.font else { fatalError("Unable to get the font. This is unexpected; see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = lookupSharedStyle(for: newValue, font: font)
        }
    }

    /// Specify the style to use for text contained inside the view.
    public final var bonMotStyle: StringStyle? {
        get { return getAssociatedStyle() }
        set {
            setAssociatedStyle(bonMotStyle: newValue)
            styledText = titleLabel?.text
        }
    }

    /// Create a new NSAttributedString using the specified string and the bonMotStyle property, and set the attributed string for the specified state.
    @objc(bon_styledText)
    public var styledText: String? {
        get { return titleLabel?.text }
        set {
            let styledText = styledAttributedString(from: newValue)
            setAttributedTitle(styledText, for: .normal)
        }
    }

}

/// Helper functionality for the BonMotStyle associated objects.
private var containerHandle: UInt8 = 0
internal extension StyleableUIElement {

    final func getAssociatedStyle() -> StringStyle? {
        let adaptiveFunctionContainer = objc_getAssociatedObject(self, &containerHandle) as? StringStyleHolder
        return adaptiveFunctionContainer?.style
    }

    final func setAssociatedStyle(bonMotStyle style: StringStyle?) {
        var adaptiveFunction: StringStyleHolder? = nil
        if let bonMotStyle = style {
            adaptiveFunction = StringStyleHolder(style: bonMotStyle)
        }
        objc_setAssociatedObject(
            self, &containerHandle,
            adaptiveFunction,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    final func styledAttributedString(from text: String?) -> NSAttributedString? {
        guard let text = text else { return nil }
        let string = (bonMotStyle ?? StringStyle()).attributedString(from: text)
        return string.adapt(to: traitCollection)
    }

    final func lookupSharedStyle(for name: String?, font: UIFont) -> StringStyle? {
        guard let name = name, let style = NamedStyles.shared.style(forName: name) else {
            return nil
        }
        // Create a style with the font and then add the named style.
        // This will provide a font if one is not specified in the style.
        return StringStyle.style(.font(font)).byAdding(stringStyle: style)
    }

}

@objc(BONStringStyleHolder)
internal class StringStyleHolder: NSObject {

    let style: StringStyle
    init(style: StringStyle) {
        self.style = style
    }
}
