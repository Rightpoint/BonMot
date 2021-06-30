//
//  AdaptiveStyle.swift
//  BonMot
//
//  Created by Brian King on 8/31/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

/// A few default font scaling behaviors.
public struct AdaptiveStyle {

    public enum Behavior {
        case control
        case body
        case preferred

        case fontMetrics

        case above(size: CGFloat, useFontNamed: String)
        case below(size: CGFloat, useFontNamed: String)
    }

    public let behavior: Behavior

    // These two values are used only in the fontMetrics case. They should be associated enum values, but marking enum
    // cases as @available is not supported: https://github.com/apple/swift/pull/36327
    public let textStyle: BonMotTextStyle?
    public let maxPointSize: CGFloat?

    init(behavior: Behavior, textStyle: BonMotTextStyle? = nil, maxPointSize: CGFloat? = nil) {
        self.behavior = behavior
        self.textStyle = textStyle
        self.maxPointSize = maxPointSize
    }

    /// Scale the font up or down based on the Dynamic Type slider, but do not
    /// grow into the Accessibility ranges.
    public static var control: AdaptiveStyle {
        AdaptiveStyle(behavior: .control)
    }

    /// Scale the font up or down based on the Dynamic Type slider,
    /// including Accessibility sizes.
    public static var body: AdaptiveStyle {
        AdaptiveStyle(behavior: .body)
    }

    /// Enable automatic scaling of fonts obtained using the `preferredFont(…)`
    /// family of methods.
    public static var preferred: AdaptiveStyle {
        AdaptiveStyle(behavior: .preferred)
    }

    /// Enable automatic scaling of fonts obtained using `UIFontMetrics`
    /// available on iOS 11+ based on the provided `textStyle` and optional
    /// `maxPointSize`. If `maxPointSize` is `nil` the font will grow unbounded.
    public static func fontMetrics(textStyle: BonMotTextStyle, maxPointSize: CGFloat?) -> AdaptiveStyle {
        AdaptiveStyle(behavior: .fontMetrics, textStyle: textStyle, maxPointSize: maxPointSize)
    }

    /// If the text is scaled above `size`, substitute the font named
    /// `useFontNamed`, but using all the same attributes as the original font.
    /// This style may be combined with other scaling behaviors such as `control`
    /// and `body`.
    public static func above(size: CGFloat, useFontNamed fontName: String) -> AdaptiveStyle {
        AdaptiveStyle(behavior: .above(size: size, useFontNamed: fontName))
    }

    /// If the text is scaled below `size`, substitute the font named
    /// `useFontNamed`, but using all the same attributes as the original font.
    /// This style may be combined with other scaling behaviors such as `control`
    /// and `body`.
    public static func below(size: CGFloat, useFontNamed fontName: String) -> AdaptiveStyle {
        AdaptiveStyle(behavior: .below(size: size, useFontNamed: fontName))
    }

}

extension AdaptiveStyle: AdaptiveStyleTransformation {

    enum AttributeName {

        static let nonAdaptedFont = NSAttributedString.Key("BonMotNonAdaptedFont")

    }

    func embed(in attributes: StyleAttributes) -> StyleAttributes {
        guard let font = attributes[.font] as? BONFont else {
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
        switch behavior {
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
        case .fontMetrics:
            if #available(iOS 11, tvOS 11, *) {
                let metrics = UIFontMetrics(forTextStyle: textStyle ?? .body)
                if let maxPointSize = maxPointSize {
                    font = metrics.scaledFont(for: font, maximumPointSize: maxPointSize, compatibleWith: traitCollection)
                }
                else {
                    font = metrics.scaledFont(for: font, compatibleWith: traitCollection)
                }
            }
        case .above(let size, let fontName):
            font = pointSize > size ? font.fontWithSameAttributes(named: fontName) : font
        case .below(let size, let family):
            font = pointSize < size ? font.fontWithSameAttributes(named: family) : font
        }
        styleAttributes[.font] = font
        return styleAttributes
    }

}

extension AdaptiveStyle {

    /// The font size adjustment to use for each content size category.
    static var shiftTable: [BonMotContentSizeCategory: CGFloat] {
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
    }

    /// The default scaling function. Grows by 2 points for each
    /// step above Large, and shrinks by 1 point for each step below Large.
    /// This function does not create larger values for content size category
    /// values in the Accessibility range of content size categories.
    ///
    /// - Parameters:
    ///   - size: The size the font was designed for at `UIContentSizeCategory.large`.
    ///   - contentSizeCategory: The content size category to scale to.
    ///   - minimumSize: The smallest size the font can be. Defaults to 11, or
    ///                   `designatedSize` if `designatedSize` is less than 11.
    /// - Returns: The new point size, scaled to the specified content size
    public static func adapt(designatedSize size: CGFloat, for contentSizeCategory: BonMotContentSizeCategory, minimumSize: CGFloat = 11) -> CGFloat {
        let shift = min(shiftTable[contentSizeCategory] ?? 0, CGFloat(6))
        let minSize = min(minimumSize, size)
        return max(size + shift, minSize)
    }

    /// A scaling function for "body" elements. Continues to grow for content
    /// size category values in the Accessibility range.
    ///
    /// - Parameters:
    ///   - size: The size the font was designed for at `UIContentSizeCategory.large`.
    ///   - contentSizeCategory: The content size category to scale to.
    ///   - minimumSize: The smallest size the font can be. Defaults to 11.
    /// - Returns: The new point size, scaled to the specified contentSize.
    public static func adaptBody(designatedSize size: CGFloat, for contentSizeCategory: BonMotContentSizeCategory, minimumSize: CGFloat = 11) -> CGFloat {
        let shift = shiftTable[contentSizeCategory] ?? 0
        let minSize = min(minimumSize, size)
        return max(size + shift, minSize)
    }

}

extension AdaptiveStyle { // Deprecated - search the code and remove other deprecations when you remove this

    /// The default scaling function. Grows by 2 points for each
    /// step above Large, and shrinks by 1 point for each step below Large.
    /// This function does not create larger values for content size category
    /// values in the Accessibility range of content size categories.
    ///
    /// - Parameters:
    ///   - size: The size the font was designed for at `UIContentSizeCategory.large`.
    ///   - contentSizeCategory: The content size category to scale to.
    ///   - minimiumSize: The smallest size the font can be. Defaults to `designatedSize` if `designatedSize` is less
    ///                   than the supplied size.
    /// - Returns: The new point size, scaled to the specified content size
    @available(*, deprecated, renamed: "adapt(designatedSize:for:minimumSize:)")
    public static func adapt(designatedSize size: CGFloat, for contentSizeCategory: BonMotContentSizeCategory, minimiumSize minimumSize: CGFloat) -> CGFloat {
        // removed default value of minimiumSize so that call sites that don't pass anything will use the new implementation
        let shift = min(shiftTable[contentSizeCategory] ?? 0, CGFloat(6))
        let minSize = min(minimumSize, size)
        return max(size + shift, minSize)
    }

    /// A scaling function for "body" elements. Continues to grow for content
    /// size category values in the Accessibility range.
    ///
    /// - Parameters:
    ///   - size: The size the font was designed for at `UIContentSizeCategory.large`.
    ///   - contentSizeCategory: The content size category to scale to.
    ///   - minimiumSize: The smallest size the font can be.
    /// - Returns: The new point size, scaled to the specified contentSize.
    @available(*, deprecated, renamed: "adaptBody(designatedSize:for:minimumSize:)")
    public static func adaptBody(designatedSize size: CGFloat, for contentSizeCategory: BonMotContentSizeCategory, minimiumSize minimumSize: CGFloat) -> CGFloat {
        // removed default value of minimiumSize so that call sites that don't pass anything will use the new implementation
        let shift = shiftTable[contentSizeCategory] ?? 0
        let minSize = min(minimumSize, size)
        return max(size + shift, minSize)
    }
}

extension AdaptiveStyle: EmbeddedTransformation {

    struct Key {

        static let fontName = NSAttributedString.Key("fontName")

    }

    struct Value {

        static let control = "control"
        static let body = "body"
        static let preferred = "preferred"
        static let above = "above"
        static let below = "below"
        static let fontMetrics = "fontMetrics"

    }

    var asDictionary: StyleAttributes {
        switch behavior {
        case let .above(size, family):
            return [
                EmbeddedTransformationHelpers.Key.type: Value.above,
                EmbeddedTransformationHelpers.Key.size: size,
                Key.fontName: family,
            ]
        case let .below(size, family):
            return [
                EmbeddedTransformationHelpers.Key.type: Value.below,
                EmbeddedTransformationHelpers.Key.size: size,
                Key.fontName: family,
            ]
        case .control:
            return [EmbeddedTransformationHelpers.Key.type: Value.control]
        case .body:
            return [EmbeddedTransformationHelpers.Key.type: Value.body]
        case .preferred:
            return [EmbeddedTransformationHelpers.Key.type: Value.preferred]
        case .fontMetrics:
            var attributes: StyleAttributes = [
                EmbeddedTransformationHelpers.Key.type: Value.fontMetrics,
                EmbeddedTransformationHelpers.Key.textStyle: textStyle ?? .body,
            ]
            if let maxPointSize = maxPointSize {
                attributes[EmbeddedTransformationHelpers.Key.maxPointSize] = maxPointSize
            }
            return attributes
        }
    }

    static func from(dictionary dict: StyleAttributes) -> EmbeddedTransformation? {
        switch (dict[EmbeddedTransformationHelpers.Key.type] as? String,
                dict[EmbeddedTransformationHelpers.Key.size] as? CGFloat,
                dict[Key.fontName] as? String,
                dict[EmbeddedTransformationHelpers.Key.textStyle] as? BonMotTextStyle,
                dict[EmbeddedTransformationHelpers.Key.maxPointSize] as? CGFloat) {
        case (Value.control?, nil, nil, nil, nil):
            return AdaptiveStyle.control
        case (Value.body?, nil, nil, nil, nil):
            return AdaptiveStyle.body
        case (Value.preferred?, nil, nil, nil, nil):
            return AdaptiveStyle.preferred
        case let (Value.above?, size?, fontName?, nil, nil):
            return AdaptiveStyle.above(size: size, useFontNamed: fontName)
        case let (Value.below?, size?, fontName?, nil, nil):
            return AdaptiveStyle.below(size: size, useFontNamed: fontName)
        case let (Value.fontMetrics?, nil, nil, textStyle?, maxPointSize):
            if #available(iOS 11, tvOS 11, *) {
                return AdaptiveStyle.fontMetrics(textStyle: textStyle, maxPointSize: maxPointSize)
            }
            else {
                return nil
            }
        default:
            return nil
        }
    }

}
#endif
