//
//  AdaptiveStyle.swift
//
//  Created by Brian King on 8/31/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

/// AdaptiveStyle defines a few default scaling behaviors and allows the font to be scaled.
public enum AdaptiveStyle {
    /// Scale the font up and down based on the Dynamic Type slider, but do not grow in the Accessibility ranges.
    case control
    /// Scale the font up and down based on the Dynamic Type slider, including Accessibility sizes.
    case body
    /// Enable automatic scaling of preferred fonts
    case preferred

    case above(size: CGFloat, family: String)
    case below(size: CGFloat, family: String)
}

extension AdaptiveStyle: AdaptiveStyleTransformation {
    enum AttributeName {
        static let nonAdaptedFont = "BonMotNonAdaptedFont"
    }

    func embed(in attributes: StyleAttributes) -> StyleAttributes {
        guard let font = attributes[NSFontAttributeName] as? BONFont else {
            print("No font to adapt, ignoring adaptive style")
            return attributes
        }
        var attributes = attributes
        attributes[AttributeName.nonAdaptedFont] = font
        attributes = EmbeddedTransformationHelpers.embed(transformation: self, to: attributes)
        return attributes
    }

    func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes? {
        guard var font = theAttributes[AttributeName.nonAdaptedFont] as? BONFont else {
            fatalError("The designated font is set when the adaptive style is added")
        }
        let pointSize = font.pointSize
        let contentSizeCategory = traitCollection.bon_preferredContentSizeCategory
        var styleAttributes = theAttributes
        switch self {
        case .control:
            font = UIFont(descriptor: font.fontDescriptor, size: AdaptiveStyle.adapt(designatedSize: pointSize, for: contentSizeCategory))
        case .body:
            font = UIFont(descriptor: font.fontDescriptor, size: AdaptiveStyle.adaptBody(designatedSize: pointSize, for: contentSizeCategory))
        case .preferred:
            if let textStyle = font.textStyle {
                font = UIFont.bon_preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
            }
            else {
                print("No text style in the font, can not adapt")
            }
        case .above(let size, let family):
            font = pointSize > size ? font.font(familyName: family) : font
        case .below(let size, let family):
            font = pointSize < size ? font.font(familyName: family) : font
        }
        styleAttributes[NSFontAttributeName] = font
        return styleAttributes
    }

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
    /// - parameter designatedSize: The size the font was designed for at UIContentSizeCategoryLarge
    /// - parameter for: The contentSizeCategory to scale to
    /// - parameter minimiumSize: The smallest size the font can be. Defaults to 11 or designatedSize if it is under 11.
    /// - returns: The new pointSize scaled to the specified contentSize
    public static func adapt(designatedSize size: CGFloat, for contentSizeCategory: BonMotContentSizeCategory, minimiumSize: CGFloat = 11) -> CGFloat {
        let shift = min(shiftTable[contentSizeCategory] ?? 0, CGFloat(6))
        let minSize = min(minimiumSize, size)
        return max(size + shift, minSize)
    }

    /// This is a scaling function for "body" elements. This scaling function will continue to grow
    /// for content size category values in 'Accessibility Content Size Category Constants'
    ///
    /// - parameter designatedSize: The size the font was designed for at UIContentSizeCategoryLarge
    /// - parameter for: The contentSizeCategory to scale to
    /// - parameter minimiumSize: The smallest size the font can be. Defaults to 11.
    /// - returns: The new pointSize scaled to the specified contentSize
    public static func adaptBody(designatedSize size: CGFloat, for contentSizeCategory: BonMotContentSizeCategory, minimiumSize: CGFloat = 11) -> CGFloat {
        let shift = shiftTable[contentSizeCategory] ?? 0
        let minSize = min(minimiumSize, size)
        return max(size + shift, minSize)
    }

}

extension AdaptiveStyle: EmbeddedTransformation {

    struct Key {
        static let family = "family"
    }

    struct Value {
        static let control = "control"
        static let body = "body"
        static let preferred = "preferred"
        static let above = "above"
        static let below = "below"
    }

    var representation: StyleAttributes {
        switch self {
        case let .above(size, family):
            return [
                EmbeddedTransformationHelpers.Key.type: Value.above,
                EmbeddedTransformationHelpers.Key.size: size,
                Key.family: family,
            ]
        case let .below(size, family):
            return [
                EmbeddedTransformationHelpers.Key.type: Value.below,
                EmbeddedTransformationHelpers.Key.size: size,
                Key.family: family,
            ]
        case .control:
            return [EmbeddedTransformationHelpers.Key.type: Value.control]
        case .body:
            return [EmbeddedTransformationHelpers.Key.type: Value.body]
        case .preferred:
            return [EmbeddedTransformationHelpers.Key.type: Value.preferred]
        }
    }

    static func from(representation dictionary: [String: StyleAttributeValue]) -> EmbeddedTransformation? {
        switch (dictionary[EmbeddedTransformationHelpers.Key.type] as? String,
                dictionary[EmbeddedTransformationHelpers.Key.size] as? CGFloat,
                dictionary[Key.family] as? String) {
        case (Value.control?, nil, nil):
            return AdaptiveStyle.control
        case (Value.body?, nil, nil):
            return AdaptiveStyle.body
        case (Value.preferred?, nil, nil):
            return AdaptiveStyle.preferred
        case let (Value.above?, size?, family?):
            return AdaptiveStyle.above(size: size, family: family)
        case let (Value.below?, size?, family?):
            return AdaptiveStyle.below(size: size, family: family)
        default:
            return nil
        }
    }

}
