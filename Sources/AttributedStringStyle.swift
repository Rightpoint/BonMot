//
//  AttributedStringStyle.swift
//
//  Created by Brian King on 8/31/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//
// NOTE: Keep attributes in order to help reviewability.

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// This is the primary style container for BonMot. It is responsible for encapsulating
/// any attributes that are intended to be used with NSAttributedString.
public struct AttributedStringStyle {
    public var initialAttributes: StyleAttributes = [:]
    public var font: BONFont? = nil
    public var link: NSURL? = nil
    public var backgroundColor: BONColor? = nil
    public var textColor: BONColor? = nil
    public var underline: (NSUnderlineStyle, BONColor?)? = nil
    public var strikethrough: (NSUnderlineStyle, BONColor?)? = nil
    public var baselineOffset: CGFloat? = nil

    public var lineSpacing: CGFloat? = nil
    public var paragraphSpacingAfter: CGFloat? = nil
    public var alignment: NSTextAlignment? = nil
    public var firstLineHeadIndent: CGFloat? = nil
    public var headIndent: CGFloat? = nil
    public var tailIndent: CGFloat? = nil
    public var lineBreakMode: NSLineBreakMode? = nil
    public var minimumLineHeight: CGFloat? = nil
    public var maximumLineHeight: CGFloat? = nil
    public var baseWritingDirection: NSWritingDirection? = nil
    public var lineHeightMultiple: CGFloat? = nil
    public var paragraphSpacingBefore: CGFloat? = nil
    public var hyphenationFactor: Float? = nil

    #if os(OSX) || os(iOS) || os(tvOS)
    public var fontFeatureProviders: [FontFeatureProvider] = []
    #endif
    #if os(iOS) || os(tvOS)
    public var adaptations: [AdaptiveStyle] = []
    #endif
    public var tracking: Tracking? = nil

    public init() {}

}

extension AttributedStringStyle {

    public var attributes: StyleAttributes {
        var theAttributes = initialAttributes

        theAttributes.update(possibleValue: font, forKey: NSFontAttributeName)
        theAttributes.update(possibleValue: link, forKey: NSLinkAttributeName)
        theAttributes.update(possibleValue: backgroundColor, forKey: NSBackgroundColorAttributeName)
        theAttributes.update(possibleValue: textColor, forKey: NSForegroundColorAttributeName)
        theAttributes.update(possibleValue: underline?.0.rawValue, forKey: NSUnderlineStyleAttributeName)
        theAttributes.update(possibleValue: underline?.1, forKey: NSUnderlineColorAttributeName)
        theAttributes.update(possibleValue: strikethrough?.0.rawValue, forKey: NSStrikethroughStyleAttributeName)
        theAttributes.update(possibleValue: strikethrough?.1, forKey: NSStrikethroughColorAttributeName)
        theAttributes.update(possibleValue: baselineOffset, forKey: NSBaselineOffsetAttributeName)

        let paragraph = AttributedStringStyle.paragraph(from: theAttributes)
        paragraph.lineSpacing = lineSpacing ?? paragraph.lineSpacing
        paragraph.paragraphSpacing = paragraphSpacingAfter ?? paragraph.paragraphSpacing
        paragraph.alignment = alignment ?? paragraph.alignment
        paragraph.firstLineHeadIndent = firstLineHeadIndent ?? paragraph.firstLineHeadIndent
        paragraph.headIndent = headIndent ?? paragraph.headIndent
        paragraph.tailIndent = tailIndent ?? paragraph.tailIndent
        paragraph.lineBreakMode = lineBreakMode ?? paragraph.lineBreakMode
        paragraph.minimumLineHeight = minimumLineHeight ?? paragraph.minimumLineHeight
        paragraph.maximumLineHeight = maximumLineHeight ?? paragraph.maximumLineHeight
        paragraph.baseWritingDirection = baseWritingDirection ?? paragraph.baseWritingDirection
        paragraph.lineHeightMultiple = lineHeightMultiple ?? paragraph.lineHeightMultiple
        paragraph.paragraphSpacingBefore = paragraphSpacingBefore ?? paragraph.paragraphSpacingBefore
        paragraph.hyphenationFactor = hyphenationFactor ?? paragraph.hyphenationFactor

        if paragraph != NSParagraphStyle.bon_default {
            theAttributes.update(possibleValue: paragraph, forKey: NSParagraphStyleAttributeName)
        }

        #if os(iOS) || os(tvOS) || os(OSX)
            // Apply the features to the font present
            let preFeaturedFont = theAttributes[NSFontAttributeName] as? BONFont
            let featuredFont = preFeaturedFont?.font(withFeatures: fontFeatureProviders)
            theAttributes.update(possibleValue: featuredFont, forKey: NSFontAttributeName)
        #endif

        #if os(iOS) || os(tvOS)
            // Apply any adaptations
            for adaptation in adaptations {
                theAttributes = adaptation.embed(in: theAttributes)
            }
        #endif

        // Apply tracking
        if let tracking = tracking {
            let styledFont = theAttributes[NSFontAttributeName] as? BONFont
            theAttributes.update(possibleValue: tracking.kerning(forFont: styledFont), forKey: NSKernAttributeName)
            #if os(iOS) || os(tvOS)
                // Add the tracking as an adaptation
                theAttributes = EmbededTransformationHelpers.embed(transformation: tracking, to: theAttributes)
            #endif
        }

        return theAttributes
    }

}

extension AttributedStringStyle {

    public mutating func update(attributes theAttributes: StyleAttributes) {
        for (key, value) in theAttributes {
            initialAttributes[key] = value
        }
    }

    public mutating func update(attributedStringStyle stringStyle: AttributedStringStyle) {
        update(attributes: stringStyle.initialAttributes)
        font = stringStyle.font ?? font
        link = stringStyle.link ?? link
        backgroundColor = stringStyle.backgroundColor ?? backgroundColor
        textColor = stringStyle.textColor ?? textColor

        underline = stringStyle.underline ?? underline
        strikethrough = stringStyle.strikethrough ?? strikethrough

        baselineOffset = stringStyle.baselineOffset ?? baselineOffset

        lineSpacing = stringStyle.lineSpacing ?? lineSpacing
        paragraphSpacingAfter = stringStyle.paragraphSpacingAfter ?? paragraphSpacingAfter
        alignment = stringStyle.alignment ?? alignment
        firstLineHeadIndent = stringStyle.firstLineHeadIndent ?? firstLineHeadIndent
        headIndent = stringStyle.headIndent ?? headIndent
        tailIndent = stringStyle.tailIndent ?? tailIndent
        lineBreakMode = stringStyle.lineBreakMode ?? lineBreakMode
        minimumLineHeight = stringStyle.minimumLineHeight ?? minimumLineHeight
        maximumLineHeight = stringStyle.maximumLineHeight ?? maximumLineHeight
        baseWritingDirection = stringStyle.baseWritingDirection ?? baseWritingDirection
        lineHeightMultiple = stringStyle.lineHeightMultiple ?? lineHeightMultiple
        paragraphSpacingBefore = stringStyle.paragraphSpacingBefore ?? paragraphSpacingBefore
        hyphenationFactor = stringStyle.hyphenationFactor ?? hyphenationFactor

        #if os(iOS) || os(tvOS) || os(OSX)
            fontFeatureProviders.append(contentsOf: stringStyle.fontFeatureProviders)
        #endif
        #if os(iOS) || os(tvOS)
            adaptations.append(contentsOf: stringStyle.adaptations)
        #endif
        tracking = stringStyle.tracking ?? tracking
    }

    public func derive(configureBlock: (inout AttributedStringStyle) -> Void) -> AttributedStringStyle {
        var style = self
        configureBlock(&style)
        return style
    }

}

/// An extension to provide UIKit interaction helpers to the style object
public extension AttributedStringStyle {

    /// Create an NSMutableAttributedString from the specified string.
    /// - parameter from: The String
    /// - returns: A new NSMutableAttributedString
    public func attributedString(from theString: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: theString, attributes: attributes)
    }

    /// Supply the contained attributes as default values for the passed in StyleAttributes. This will also
    /// perform some merging of values. This includes NSParagraphStyle and the embedded attributes.
    ///
    /// - parameter defaultsFor: The object to over-write the defaults with
    /// - returns: The new attributes
    func supplyDefaults(for attributes: StyleAttributes) -> StyleAttributes {
        var attributes = attributes
        for (key, value) in self.attributes {
            switch (key, value, attributes[key]) {
            case (NSParagraphStyleAttributeName, let paragraph as NSParagraphStyle, let otherParagraph as NSParagraphStyle):
                attributes[NSParagraphStyleAttributeName] = paragraph.supplyDefaults(for: otherParagraph)
            case (BonMotTransformationsAttributeName,
                var transformations as Array<StyleAttributeValue>,
                let otherTransformations as Array<StyleAttributeValue>):
                transformations.append(contentsOf: otherTransformations)
                attributes[BonMotTransformationsAttributeName] = transformations
            case let (key, value, nil):
                attributes.update(possibleValue: value, forKey: key)
            default:
                break
            }
        }
        return attributes
    }

    /// A helper function to coerce an `NSMutableParagraphStyle` from a value in an attributes dictionary.
    /// - parameter from: the attributes dictionary from which to extract the paragraph style
    /// - returns: a mutable copy of an `NSParagraphStyle`, or a new `NSMutableParagraphStyle` if the value is `nil`.
    static func paragraph(from styleAttributes: StyleAttributes) -> NSMutableParagraphStyle {
        let theObject = styleAttributes[NSParagraphStyleAttributeName]
        let result: NSMutableParagraphStyle
        if let paragraphStyle = theObject as? NSMutableParagraphStyle {
            result = paragraphStyle
        }
        else if let paragraphStyle = theObject as? NSParagraphStyle {
            result = paragraphStyle.mutableParagraphStyleCopy()
        }
        else {
            result = NSMutableParagraphStyle()
        }
        return result
    }

 }

extension NSParagraphStyle {

    /// Update the supplied NSParagraphStyle properties with the value in this ParagraphStyle if the supplied
    /// ParagraphStyle property is the default value.
    // swiftlint:disable:next cyclomatic_complexity
    func supplyDefaults(for paragraphStyle: NSParagraphStyle) -> NSMutableParagraphStyle {
        let defaults = NSParagraphStyle.bon_default
        let paragraph = paragraphStyle.mutableParagraphStyleCopy()
        if paragraph.lineSpacing == defaults.lineSpacing { paragraph.lineSpacing = lineSpacing }
        if paragraph.paragraphSpacing == defaults.paragraphSpacing { paragraph.paragraphSpacing = paragraphSpacing }
        if paragraph.alignment == defaults.alignment { paragraph.alignment = alignment }
        if paragraph.firstLineHeadIndent == defaults.firstLineHeadIndent { paragraph.firstLineHeadIndent = firstLineHeadIndent }
        if paragraph.headIndent == defaults.headIndent { paragraph.headIndent = headIndent }
        if paragraph.tailIndent == defaults.tailIndent { paragraph.tailIndent = tailIndent }
        if paragraph.lineBreakMode == defaults.lineBreakMode { paragraph.lineBreakMode = lineBreakMode }
        if paragraph.minimumLineHeight == defaults.minimumLineHeight { paragraph.minimumLineHeight = minimumLineHeight }
        if paragraph.maximumLineHeight == defaults.maximumLineHeight { paragraph.maximumLineHeight = maximumLineHeight }
        if paragraph.baseWritingDirection == defaults.baseWritingDirection { paragraph.baseWritingDirection = baseWritingDirection }
        if paragraph.lineHeightMultiple == defaults.lineHeightMultiple { paragraph.lineHeightMultiple = lineHeightMultiple }
        if paragraph.paragraphSpacingBefore == defaults.paragraphSpacingBefore { paragraph.paragraphSpacingBefore = paragraphSpacingBefore }
        if paragraph.hyphenationFactor == defaults.hyphenationFactor { paragraph.hyphenationFactor = hyphenationFactor }
        if paragraph.tabStops == defaults.tabStops { paragraph.tabStops = tabStops }
        return paragraph
    }

}

extension Dictionary {
    internal mutating func update(possibleValue value: Value?, forKey key: Key) {
        if let value = value {
            self[key] = value
        }
    }
}
