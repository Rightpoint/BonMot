//
//  UIKit+Helpers.swift
//
//  Created by Brian King on 9/12/16.
//
//

import UIKit

extension UIFont {

    @nonobjc static func bon_preferredFont(forTextStyle textStyle: BonMotTextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
        if #available(iOS 10.0, tvOS 10.0, *) {
            return preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
        }
        else {
            return preferredFont(forTextStyle: textStyle)
        }
    }

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

    /// Obtain the `preferredContentSizeCategory` for the trait collection. This is compatible with iOS 9.x
    /// and will use the `UIApplication` `preferredContentSizeCategory` if the trait collection's
    /// `preferredContentSizeCategory` is `UIContentSizeCategoryUnspecified`.
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
        // UIApplication is not a valid object in the unit tests. Fallback to a default value if the delegate is nil
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

    /// - parameter familyName: the family name to use in place of the receiver's family name
    /// - returns: a font with the same attributes as the current font, but change the `familyName`
    final func font(familyName theFamilyName: String) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        attributes[UIFontDescriptorFamilyAttribute] = fontName
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        return UIFont(descriptor: descriptor, size: pointSize)
    }

}
