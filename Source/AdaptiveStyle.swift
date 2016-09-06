//
//  AdaptiveStyle.swift
//
//  Created by Brian King on 8/31/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

public enum AdaptiveStyle {
    case control
    case body
    case preferred
    case above(size: CGFloat, family: String)
    case below(size: CGFloat, family: String)
}

extension AdaptiveStyle {
    /// An internal lookup table defining the font shift to use for each content size category
    static var shiftTable: [BonMotContentSizeCategory: CGFloat] {
        #if swift(>=3.0)
            return [
                .extraSmall: -3,
                .small: -2,
                .medium: -1,
                .large: 0,
                .extraLarge: 2,
                .extraExtraLarge: 4,
                .extraExtraExtraLarge: 6,
                .accessibilityMedium: 11,
                .accessibilityLarge: 16,
                .accessibilityExtraLarge: 23,
                .accessibilityExtraExtraLarge: 30,
                .accessibilityExtraExtraExtraLarge: 36,
            ]
        #else
            return [
                UIContentSizeCategoryExtraSmall: -3,
                UIContentSizeCategorySmall: -2,
                UIContentSizeCategoryMedium: -1,
                UIContentSizeCategoryLarge: 0,
                UIContentSizeCategoryExtraLarge: 2,
                UIContentSizeCategoryExtraExtraLarge: 4,
                UIContentSizeCategoryExtraExtraExtraLarge: 6,
                UIContentSizeCategoryAccessibilityMedium: 11,
                UIContentSizeCategoryAccessibilityLarge: 16,
                UIContentSizeCategoryAccessibilityExtraLarge: 23,
                UIContentSizeCategoryAccessibilityExtraExtraLarge: 30,
                UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 36,
            ]
        #endif
    }

    /// This is the default scaling function. This scaling function will continue to grow by
    /// 2 points for each step above large, and shrink by 1 point for each step below large.
    /// This function will not create larger values for content size category values in 'Accessibility Content Size Category Constants'.
    ///
    /// - parameter contentSizeCategory: The contentSizeCategory to scale to
    /// - parameter sizeAtLarge: The size the font was designed for at UIContentSizeCategoryLarge
    /// - parameter minimiumSize: The smallest size the font can be. Defaults to 11 or sizeAtLarge if it is under 11.
    /// - returns: The new pointSize scaled to the specified contentSize
    public static func adapt(sizeAtLarge size: CGFloat, forContentSizeCategory contentSizeCategory: BonMotContentSizeCategory, minimiumSize: CGFloat = 11) -> CGFloat {
        let shift = min(shiftTable[contentSizeCategory] ?? 0, CGFloat(6))
        let minSize = min(minimiumSize, size)
        return max(size + shift, minSize)
    }

    /// This is a scaling function for "body" elements. This scaling function will continue to grow
    /// for content size category values in 'Accessibility Content Size Category Constants'
    ///
    /// - parameter contentSizeCategory: The contentSizeCategory to scale to
    /// - parameter sizeAtLarge: The size the font was designed for at UIContentSizeCategoryLarge
    /// - parameter minimiumSize: The smallest size the font can be. Defaults to 11.
    /// - returns: The new pointSize scaled to the specified contentSize
    public static func adaptBody(sizeAtLarge size: CGFloat, forContentSizeCategory contentSizeCategory: BonMotContentSizeCategory, minimiumSize: CGFloat = 11) -> CGFloat {
        let shift = shiftTable[contentSizeCategory] ?? 0
        let minSize = min(minimiumSize, size)
        return max(size + shift, minSize)
    }

}

extension AdaptiveStyle: StyleAttributeProvider {

    public func style(attributes theAttributes: StyleAttributes, traitCollection: UITraitCollection?) -> StyleAttributes {
        guard var font = theAttributes[NSFontAttributeName] as? UIFont else {
            print("No font to adapt, ignoring adaptive style")
            return theAttributes
        }
        let contentSizeCategory = traitCollection?.bon_preferredContentSizeCategory
            ?? UIApplication.shared.preferredContentSizeCategory

        switch self {
        case .control:
            let adaptedSize = AdaptiveStyle.adapt(sizeAtLarge: font.pointSize, forContentSizeCategory: contentSizeCategory)
            font = font.withSize(adaptedSize)
        case .body:
            let adaptedSize = AdaptiveStyle.adaptBody(sizeAtLarge: font.pointSize, forContentSizeCategory: contentSizeCategory)
            font = font.withSize(adaptedSize)
        case .preferred:
            if let textStyle = font.bon_textStyle {
                font = UIFont.bon_preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
            }
            else {
                print("No text style in the font, can not adapt")
            }
        case .above(let size, let family):
            font = font.pointSize > size ? font.font(familyName: family) : font
        case .below(let size, let family):
            font = font.pointSize < size ? font.font(familyName: family) : font
        }
        var attributes = theAttributes
        attributes[NSFontAttributeName] = font
        return attributes
    }
    
}
