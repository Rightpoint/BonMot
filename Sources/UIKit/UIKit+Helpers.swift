//
//  UIKit+Helpers.swift
//  BonMot
//
//  Created by Brian King on 9/12/16.
//
//

#if canImport(UIKit) && !os(watchOS)
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
        guard let textStyle = fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName.textStyle] as? String else {
            return nil
        }
        return UIFont.TextStyle(rawValue: textStyle)
    }

}

extension UITraitCollection {

    /// Obtain the `preferredContentSizeCategory` for the trait collection. This
    /// is compatible with iOS 9.x and will use the
    /// `UIApplication.shared.preferredContentSizeCategory` if the trait collection's
    /// `preferredContentSizeCategory` is `UIContentSizeCategory.unspecified`.
    public var bon_preferredContentSizeCategory: BonMotContentSizeCategory {
        if preferredContentSizeCategory != .unspecified {
            return preferredContentSizeCategory
        }
        return UIScreen.main.traitCollection.preferredContentSizeCategory
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
            UIFontDescriptor.AttributeName.name: name,
            ])
        return UIFont(descriptor: descriptor, size: pointSize)
    }

}
#endif
