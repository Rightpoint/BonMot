//
//  StyleableUIElement.swift
//  BonMot
//
//  Created by Brian King on 8/11/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

extension UILabel {

    /// The name of a style in the global `NamedStyles` registry. The getter
    /// always returns `nil`, and should not be used.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set { bonMotStyle = lookUpSharedStyle(for: newValue, font: font) }
    }

    /// A string style. Stored via associated objects.
    public final var bonMotStyle: StringStyle? {
        get { return getAssociatedStyle() }
        set {
            setAssociatedStyle(bonMotStyle: newValue)
            styledText = text
        }
    }

    /// Update this property to style the incoming text via the `bonMotStyle`
    /// and set it as the receiver's `attributedText`.
    @objc(bon_styledText)
    public var styledText: String? {
        get { return attributedText?.string }
        set { attributedText = styledAttributedString(from: newValue, bonMotStyle: bonMotStyle) }
    }

}

extension UITextField {

    /// The name of a style in the global `NamedStyles` registry. The getter
    /// always returns `nil`, and should not be used.
    ///
    /// - note: The style is applied to both the `attributedText` and
    /// `defaultTextAttributes`. If you plan on styling them differently, use
    /// attributed strings directly.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set {
            guard let font = font else { fatalError("Unable to get the font. This is unexpected, see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = lookUpSharedStyle(for: newValue, font: font)
        }
    }

    /// A string style. Stored via associated objects.
    /// - note: The style is applied to both the `attributedText` and
    /// `attributedPlaceholder`. If you plan on styling them differently, use
    /// attributed strings directly.
    public final var bonMotStyle: StringStyle? {
        get { return getAssociatedStyle() }
        set {
            setAssociatedStyle(bonMotStyle: newValue)
            styledText = text
            defaultTextAttributes = bonMotStyle?.attributes(adaptedTo: traitCollection) ?? [:]
        }
    }

    /// Update this property to style the incoming text via the `bonMotStyle`
    /// and set it as the receiver's `attributedText`.
    @objc(bon_styledText)
    public var styledText: String? {
        get { return attributedText?.string }
        set {
            let styledText = styledAttributedString(from: newValue, bonMotStyle: bonMotStyle)
            // Set the font first to avoid a bug that causes UITextField to hang
            if let styledText = styledText {
                if styledText.length > 0 {
                    font = styledText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
                }
            }
            attributedText = styledText
        }
    }

}

extension UITextView {

    /// The name of a style in the global `NamedStyles` registry. The getter
    /// always returns `nil`, and should not be used.
    ///
    /// - note: The style is applied to both the `attributedText` and
    /// `typingAttributes`. If you plan on styling them differently, use
    /// attributed strings directly.
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
            bonMotStyle = lookUpSharedStyle(for: newValue, font: font)
        }
    }

    /// A string style. Stored via associated objects.
    /// - note: The style is applied to both the `attributedText` and
    /// `typingAtributes`. If you plan on styling them differently, use
    /// attributed strings directly.
    public final var bonMotStyle: StringStyle? {
        get { return getAssociatedStyle() }
        set {
            setAssociatedStyle(bonMotStyle: newValue)
            typingAttributes = newValue?.attributes(adaptedTo: traitCollection) ?? typingAttributes
            styledText = text
        }
    }

    /// Update this property to style the incoming text via the `bonMotStyle`
    /// and set it as the receiver's `attributedText`.
    @objc(bon_styledText)
    public var styledText: String? {
        get { return attributedText?.string }
        set {
            attributedText = styledAttributedString(from: newValue, bonMotStyle: bonMotStyle)
        }
    }

}

extension UIButton {

    /// The name of a style in the global `NamedStyles` registry. The getter
    /// always returns `nil`, and should not be used.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set {
            guard let font = titleLabel?.font else { fatalError("Unable to get the font. This is unexpected; see UIKitTests.testTextFieldPropertyBehavior") }
            bonMotStyle = lookUpSharedStyle(for: newValue, font: font)
        }
    }

    /// A string style. Stored via associated objects.
    public final var bonMotStyle: StringStyle? {
        get { return getAssociatedStyle() }
        set {
            setAssociatedStyle(bonMotStyle: newValue)
            styledText = titleLabel?.text
        }
    }

    /// Update this property to style the incoming text via the `bonMotStyle`
    /// and set it as the receiver's attributed text for the "normal" state.
    @objc(bon_styledText)
    public var styledText: String? {
        get { return titleLabel?.text }
        set {
            let styledText = styledAttributedString(from: newValue, bonMotStyle: bonMotStyle)
            setAttributedTitle(styledText, for: .normal)
        }
    }

}

/// Internal protocol to organize helper code for UI Elements.
protocol StyleableUIElement: UITraitEnvironment {}
extension UILabel: StyleableUIElement {}
extension UITextField: StyleableUIElement {}
extension UIButton: StyleableUIElement {}
extension UITextView: StyleableUIElement {}

/// Helper for the bonMotStyle associated objects.
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

    final func styledAttributedString(from text: String?, bonMotStyle: StringStyle?) -> NSAttributedString? {
        guard let text = text else { return nil }
        let string = (bonMotStyle ?? StringStyle()).attributedString(from: text)
        return string.adapted(to: traitCollection)
    }

    final func lookUpSharedStyle(for name: String?, font: UIFont) -> StringStyle? {
        guard let name = name, let style = NamedStyles.shared.style(forName: name) else {
            return nil
        }
        // Create a style with the font and then add the named style.
        // This will provide a font if one is not specified in the style.
        return StringStyle(.font(font)).byAdding(stringStyle: style)
    }

}

@objc(BONStringStyleHolder)
internal class StringStyleHolder: NSObject {

    let style: StringStyle
    init(style: StringStyle) {
        self.style = style
    }

}
