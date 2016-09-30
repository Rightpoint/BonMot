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
    public var adaptations: [StyleAttributeTransformation] = []
    public var tracking: Tracking? = nil

    public init() {}
    public func derive(configureBlock: (inout AttributedStringStyle) -> Void) -> AttributedStringStyle {
        var style = self
        configureBlock(&style)
        return style
    }

}

extension AttributedStringStyle: StyleAttributeTransformation {

    public func style(attributes theAttributes: StyleAttributes) -> StyleAttributes {
        // Apply all of the style properties to the StyleAttributes
        var theAttributes = theAttributes
        for (key, value) in initialAttributes {
            theAttributes[key] = value
        }
        theAttributes.update(possibleValue: font, forKey: NSFontAttributeName)
        theAttributes.update(possibleValue: link, forKey: NSLinkAttributeName)
        theAttributes.update(possibleValue: backgroundColor, forKey: NSBackgroundColorAttributeName)
        theAttributes.update(possibleValue: textColor, forKey: NSForegroundColorAttributeName)
        theAttributes.update(possibleValue: underline?.0.rawValue, forKey: NSUnderlineStyleAttributeName)
        theAttributes.update(possibleValue: underline?.1, forKey: NSUnderlineColorAttributeName)
        theAttributes.update(possibleValue: strikethrough?.0.rawValue, forKey: NSStrikethroughStyleAttributeName)
        theAttributes.update(possibleValue: strikethrough?.1, forKey: NSStrikethroughColorAttributeName)
        theAttributes.update(possibleValue: baselineOffset, forKey: NSBaselineOffsetAttributeName)

        let paragraph = StyleAttributeHelpers.paragraph(from: theAttributes)
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

        let defaults = NSParagraphStyle.bon_default

        if paragraph != defaults {
            theAttributes.update(possibleValue: paragraph, forKey: NSParagraphStyleAttributeName)
        }

        #if os(iOS) || os(tvOS) || os(OSX)
            // Apply the features to the font present
            let preFeaturedFont = theAttributes[NSFontAttributeName] as? BONFont
            let featuredFont = preFeaturedFont?.font(withFeatures: fontFeatureProviders)
            theAttributes.update(possibleValue: featuredFont, forKey: NSFontAttributeName)
        #endif

        // Apply any adaptations
        for adaptation in adaptations {
            theAttributes = adaptation.style(attributes: theAttributes)
        }

        if let tracking = tracking {
            // Apply tracking
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
        adaptations.append(contentsOf: stringStyle.adaptations)
        tracking = stringStyle.tracking ?? tracking
    }

}

extension Dictionary {
    internal mutating func update(possibleValue value: Value?, forKey key: Key) {
        if let value = value {
            self[key] = value
        }
    }
}
