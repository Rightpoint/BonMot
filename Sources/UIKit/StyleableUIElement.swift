//
//  StyleableUIElement.swift
//  BonMot
//
//  Created by Brian King on 8/11/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UILabel {

    /// The name of a style in the global `NamedStyles` registry. The getter
    /// always returns `nil`, and should not be used.
    @IBInspectable
    public var bonMotStyleName: String? {
        get { return nil }
        set { bonMotStyle = StyleableUIElementHelpers.lookUpSharedStyle(for: newValue, font: font) }
    }

    /// A string style. Stored via associated objects.
    public final var bonMotStyle: StringStyle? {
        get { return StyleableUIElementHelpers.getAssociatedStyle(from: self) }
        set {
            StyleableUIElementHelpers.setAssociatedStyle(on: self, style: newValue)
            styledText = text
        }
    }

    /// Update this property to style the incoming text via the `bonMotStyle`
    /// and set it as the receiver's `attributedText`.
    @objc(bon_styledText)
    public var styledText: String? {
        get { return attributedText?.string }
        set { attributedText = StyleableUIElementHelpers.styledAttributedString(from: newValue, style: bonMotStyle, traitCollection: traitCollection) }
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
            bonMotStyle = StyleableUIElementHelpers.lookUpSharedStyle(for: newValue, font: font)
        }
    }

    /// A string style. Stored via associated objects.
    /// - note: The style is applied to both the `attributedText` and
    /// `attributedPlaceholder`. If you plan on styling them differently, use
    /// attributed strings directly.
    public final var bonMotStyle: StringStyle? {
        get { return StyleableUIElementHelpers.getAssociatedStyle(from: self) }
        set {
            StyleableUIElementHelpers.setAssociatedStyle(on: self, style: newValue)
            styledText = text
            let attributes = (bonMotStyle?.attributes(adaptedTo: traitCollection) ?? [:])
            defaultTextAttributes = attributes
        }
    }

    /// Update this property to style the incoming text via the `bonMotStyle`
    /// and set it as the receiver's `attributedText`.
    @objc(bon_styledText)
    public var styledText: String? {
        get { return attributedText?.string }
        set {
            let styledText = StyleableUIElementHelpers.styledAttributedString(from: newValue, style: bonMotStyle, traitCollection: traitCollection)
            // Set the font first to avoid a bug that causes UITextField to hang
            if let styledText = styledText {
                if styledText.length > 0 {
                    font = styledText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont
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
            bonMotStyle = StyleableUIElementHelpers.lookUpSharedStyle(for: newValue, font: font)
        }
    }

    /// A string style. Stored via associated objects.
    /// - note: The style is applied to both the `attributedText` and
    /// `typingAttributes`. If you plan on styling them differently, use
    /// attributed strings directly.
    public final var bonMotStyle: StringStyle? {
        get { return StyleableUIElementHelpers.getAssociatedStyle(from: self) }
        set {
            StyleableUIElementHelpers.setAssociatedStyle(on: self, style: newValue)
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
            attributedText = StyleableUIElementHelpers.styledAttributedString(from: newValue, style: bonMotStyle, traitCollection: traitCollection)
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
            bonMotStyle = StyleableUIElementHelpers.lookUpSharedStyle(for: newValue, font: font)
        }
    }

    /// A string style. Stored via associated objects.
    public final var bonMotStyle: StringStyle? {
        get { return StyleableUIElementHelpers.getAssociatedStyle(from: self) }
        set {
            StyleableUIElementHelpers.setAssociatedStyle(on: self, style: newValue)
            styledText = titleLabel?.text
        }
    }

    /// Update this property to style the incoming text via the `bonMotStyle`
    /// and set it as the receiver's attributed text for the "normal" state.
    @objc(bon_styledText)
    public var styledText: String? {
        get { return titleLabel?.text }
        set {
            let styledText = StyleableUIElementHelpers.styledAttributedString(from: newValue, style: bonMotStyle, traitCollection: traitCollection)
            setAttributedTitle(styledText, for: .normal)
        }
    }

}

/// Helper for the bonMotStyle associated objects.
private var containerHandle: UInt8 = 0
private enum StyleableUIElementHelpers {

    static func getAssociatedStyle(from object: AnyObject) -> StringStyle? {
        let adaptiveFunctionContainer = objc_getAssociatedObject(object, &containerHandle) as? StringStyleHolder
        return adaptiveFunctionContainer?.style
    }

    static func setAssociatedStyle(on object: AnyObject, style: StringStyle?) {
        var adaptiveFunction: StringStyleHolder?
        if let bonMotStyle = style {
            adaptiveFunction = StringStyleHolder(style: bonMotStyle)
        }
        objc_setAssociatedObject(
            object, &containerHandle,
            adaptiveFunction,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    static func styledAttributedString(from string: String?, style: StringStyle?, traitCollection: UITraitCollection) -> NSAttributedString? {
        guard let string = string else { return nil }
        let attributedString = (style ?? StringStyle()).attributedString(from: string)
        return attributedString.adapted(to: traitCollection)
    }

    static func lookUpSharedStyle(for name: String?, font: UIFont) -> StringStyle? {
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

extension Dictionary where Key: RawRepresentable, Key.RawValue == String {

    var withStringKeys: [String: Value] {
        var newDict: [String: Value] = [:]
        for (key, value) in self {
            newDict[key.rawValue] = value
        }

        return newDict
    }

}

extension Dictionary where Key == String {

    func withTypedKeys<KeyType>() -> [KeyType: Value] where KeyType: RawRepresentable, KeyType.RawValue == String {
        var newDict: [KeyType: Value] = [:]
        for (key, value) in self {
            if let newKey = KeyType(rawValue: key) {
                newDict[newKey] = value
            }
        }

        return newDict
    }

}
#endif
