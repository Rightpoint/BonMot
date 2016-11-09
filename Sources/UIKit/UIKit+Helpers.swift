//
//  UIKit+Helpers.swift
//  BonMot
//
//  Created by Brian King on 9/12/16.
//
//

import UIKit

// UIKit helpers for iOS and tvOS

extension UIFont {

    @nonobjc static func bon_preferredFont(forTextStyle textStyle: BonMotTextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
        if #available(iOS 10.0, tvOS 10.0, *) {
            return preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
        }
        else {
            return preferredFont(forTextStyle: textStyle)
        }
    }

    /// Retrieve the text style, if it exists, from the font descriptor.
    @objc(bon_textStyle)
    public final var textStyle: BonMotTextStyle? {
        guard let textStyle = fontDescriptor.fontAttributes[UIFontDescriptorTextStyleAttribute] as? String else {
            return nil
        }
        #if swift(>=3.0)
            return UIFontTextStyle(rawValue: textStyle)
        #else
            return textStyle
        #endif
    }

}

extension UITraitCollection {

    /// Obtain the `preferredContentSizeCategory` for the trait collection. This
    /// is compatible with iOS 9.x and will use the
    /// `UIApplication.shared.preferredContentSizeCategory` if the trait collection's
    /// `preferredContentSizeCategory` is `UIContentSizeCategory.unspecified`.
    public var bon_preferredContentSizeCategory: BonMotContentSizeCategory {
        #if swift(>=3.0)
            if #available(iOS 10.0, tvOS 10.0, *) {
                if preferredContentSizeCategory != .unspecified {
                    return preferredContentSizeCategory
                }
            }
        #elseif swift(>=2.3)
            if #available(iOS 10.0, tvOS 10.0, *) {
                if preferredContentSizeCategory != UIContentSizeCategoryUnspecified {
                    return preferredContentSizeCategory
                }
            }
        #endif
        // `UIApplication.shared` is not a valid object in unit tests. Fall back
        // to a default value if the delegate is nil.
        if UIApplication.shared.delegate != nil {
            return UIApplication.shared.preferredContentSizeCategory
        }
        else {
            #if swift(>=3.0)
                return UIContentSizeCategory.large
            #else
                return UIContentSizeCategoryLarge
            #endif
        }
    }

}

extension UIFont {

    /// Uses a font descriptor to return a font with the specified name, but
    /// with all other attributes the same as the receiver.
    ///
    /// - Parameter name: The name of the new font. Use the same name as you
    ///                   would pass to UIFont(name:size:).
    /// - Returns: a font with the same attributes as the receiver, but with the
    ///            the specified name.
    final func fontWithSameAttributes(named name: String) -> UIFont {
        let descriptor = fontDescriptor.addingAttributes([
            UIFontDescriptorNameAttribute: name,
            ])
        return UIFont(descriptor: descriptor, size: pointSize)
    }

}
