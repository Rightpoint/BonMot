//
//  StringStyle.swift
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

/// The primary style container for BonMot responsible for encapsulating any attributes that are intended
/// to be used with NSAttributedString.
///
/// NOTE: This was originally envisioned with a more functional closure implementation. However, the order of application
///  is very important, and the API was confusing with a priority integer, and forcing the user to use the right order wasn't
///  acceptable.
public struct StringStyle {
    public var initialAttributes: StyleAttributes = [:]
    public var font: BONFont? = nil
    public var link: NSURL? = nil
    public var backgroundColor: BONColor? = nil
    public var color: BONColor? = nil
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
    public var numberCase: NumberCase? = nil
    public var numberSpacing: NumberSpacing? = nil
    #endif
    #if os(iOS) || os(tvOS)
    public var adaptations: [AdaptiveStyle] = []
    #endif
    public var tracking: Tracking? = nil
    public var xmlStyler: XMLStyler? = nil

    public init() {}

}

extension StringStyle {

    /// Obtain a StyleAttributes representing the current style
    public var attributes: StyleAttributes {
        var theAttributes = initialAttributes

        theAttributes.update(possibleValue: font, forKey: NSFontAttributeName)
        theAttributes.update(possibleValue: link, forKey: NSLinkAttributeName)
        theAttributes.update(possibleValue: backgroundColor, forKey: NSBackgroundColorAttributeName)
        theAttributes.update(possibleValue: color, forKey: NSForegroundColorAttributeName)
        theAttributes.update(possibleValue: underline?.0.rawValue, forKey: NSUnderlineStyleAttributeName)
        theAttributes.update(possibleValue: underline?.1, forKey: NSUnderlineColorAttributeName)
        theAttributes.update(possibleValue: strikethrough?.0.rawValue, forKey: NSStrikethroughStyleAttributeName)
        theAttributes.update(possibleValue: strikethrough?.1, forKey: NSStrikethroughColorAttributeName)
        theAttributes.update(possibleValue: baselineOffset, forKey: NSBaselineOffsetAttributeName)

        let paragraph = StringStyle.paragraph(from: theAttributes)
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
                theAttributes = EmbeddedTransformationHelpers.embed(transformation: tracking, to: theAttributes)
            #endif
        }

        return theAttributes
    }

    /// Create an NSMutableAttributedString from the specified string.
    /// - parameter from: The String
    /// - parameter existingAttributes: The existing attributes, if any, to use as default values for the style.
    ///
    /// - returns: A new NSMutableAttributedString
    public func attributedString(from theString: String, existingAttributes: StyleAttributes? = nil) -> NSAttributedString {
        if let xmlStyler = xmlStyler {
            let builder = XMLBuilder(
                string: theString,
                styler: xmlStyler,
                options: [],
                baseStyle: self
            )
            if let attributedString = try? builder.parseAttributedString() {
                return attributedString
            }
        }
        return NSAttributedString(string: theString, attributes: supplyDefaults(for: existingAttributes))
    }

}

extension StringStyle {

    /// Update the initialAttributes in the style object. This is used to provide the default
    /// values configured in UI elements, which the style can override.
    ///
    /// - parameter initialAttributes: The attributes to add to the style before applying the other properties.
    public mutating func add(initialAttributes attributes: StyleAttributes) {
        for (key, value) in attributes {
            initialAttributes[key] = value
        }
    }

    /// Update the style with values specified in `stringStyle`. Any value configured in `stringStyle`
    /// will over-write the values specified in this `stringStyle`.
    ///
    /// - parameter stringStyle: The style to update this style with.
    public mutating func add(stringStyle theStringStyle: StringStyle) {
        add(initialAttributes: theStringStyle.initialAttributes)
        font = theStringStyle.font ?? font
        link = theStringStyle.link ?? link
        backgroundColor = theStringStyle.backgroundColor ?? backgroundColor
        color = theStringStyle.color ?? color
        underline = theStringStyle.underline ?? underline
        strikethrough = theStringStyle.strikethrough ?? strikethrough
        baselineOffset = theStringStyle.baselineOffset ?? baselineOffset

        lineSpacing = theStringStyle.lineSpacing ?? lineSpacing
        paragraphSpacingAfter = theStringStyle.paragraphSpacingAfter ?? paragraphSpacingAfter
        alignment = theStringStyle.alignment ?? alignment
        firstLineHeadIndent = theStringStyle.firstLineHeadIndent ?? firstLineHeadIndent
        headIndent = theStringStyle.headIndent ?? headIndent
        tailIndent = theStringStyle.tailIndent ?? tailIndent
        lineBreakMode = theStringStyle.lineBreakMode ?? lineBreakMode
        minimumLineHeight = theStringStyle.minimumLineHeight ?? minimumLineHeight
        maximumLineHeight = theStringStyle.maximumLineHeight ?? maximumLineHeight
        baseWritingDirection = theStringStyle.baseWritingDirection ?? baseWritingDirection
        lineHeightMultiple = theStringStyle.lineHeightMultiple ?? lineHeightMultiple
        paragraphSpacingBefore = theStringStyle.paragraphSpacingBefore ?? paragraphSpacingBefore
        hyphenationFactor = theStringStyle.hyphenationFactor ?? hyphenationFactor

        #if os(iOS) || os(tvOS) || os(OSX)
            fontFeatureProviders.append(contentsOf: theStringStyle.fontFeatureProviders)
            numberCase = theStringStyle.numberCase ?? numberCase
            numberSpacing = theStringStyle.numberSpacing ?? numberSpacing
        #endif
        #if os(iOS) || os(tvOS)
            adaptations.append(contentsOf: theStringStyle.adaptations)
        #endif
        tracking = theStringStyle.tracking ?? tracking
        xmlStyler = theStringStyle.xmlStyler ?? xmlStyler
    }

    public func byAdding(stringStyle style: StringStyle) -> StringStyle {
        var newStyle = self
        newStyle.add(stringStyle: style)
        return newStyle
    }

}

/// An extension to provide UIKit interaction helpers to the style object
public extension StringStyle {

    /// Supply the contained attributes as default values for the passed in StyleAttributes. This will also
    /// perform some merging of values. This includes NSParagraphStyle and the embedded attributes.
    ///
    /// - parameter for: The object to over-write the defaults with
    /// - returns: The new attributes
    func supplyDefaults(for attributes: StyleAttributes?) -> StyleAttributes {
        guard var attributes = attributes else {
            return self.attributes
        }
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
