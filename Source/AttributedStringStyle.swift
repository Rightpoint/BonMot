//
//  AttributedStringStyle.swift
//
//  Created by Brian King on 8/31/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//
// NOTE: Keep attributes in order to help reviewability.

#if swift(>=3.0)
    public func BonMotC(_ configure: (inout AttributedStringStyle) -> Void) -> AttributedStringStyle {
        var style = AttributedStringStyle()
        configure(&style)
        return style
    }
#else
    public func BonMotC(configure: (inout AttributedStringStyle) -> Void) -> AttributedStringStyle {
        var style = AttributedStringStyle()
        configure(&style)
        return style
    }
#endif

public typealias BonMotI = AttributedStringStyle

public struct AttributedStringStyle {
    public var initialAttributes: StyleAttributes
    public var font: UIFont?
    public var textStyle: BonMotTextStyle?
    public var link: NSURL?
    public var backgroundColor: UIColor?
    public var textColor: UIColor?
    public var underline: (NSUnderlineStyle, UIColor?)?
    public var strikethrough: (NSUnderlineStyle, UIColor?)?
    public var baselineOffset: CGFloat?
    public var fontFeatureProviders: [FontFeatureProvider]
    public var adaptations: [StyleAttributeTransformation]
    public var tracking: Tracking?

    public var lineSpacing: CGFloat?
    public var paragraphSpacingAfter: CGFloat?
    public var alignment: NSTextAlignment?
    public var firstLineHeadIndent: CGFloat?
    public var headIndent: CGFloat?
    public var tailIndent: CGFloat?
    public var lineBreakMode: NSLineBreakMode?
    public var minimumLineHeight: CGFloat?
    public var maximumLineHeight: CGFloat?
    public var baseWritingDirection: NSWritingDirection?
    public var lineHeightMultiple: CGFloat?
    public var paragraphSpacingBefore: CGFloat?
    public var hyphenationFactor: Float?

    public init(initialAttributes: StyleAttributes = [:],
                font: UIFont? = nil,
                link: NSURL? = nil,
                backgroundColor: UIColor? = nil,
                textColor: UIColor? = nil,
                underline: (NSUnderlineStyle, UIColor?)? = nil,
                strikethrough: (NSUnderlineStyle, UIColor?)? = nil,
                baselineOffset: CGFloat? = nil,
                fontFeatureProviders: [FontFeatureProvider] = [],
                adaptations: [StyleAttributeTransformation] = [],
                tracking: Tracking? = nil,
                lineSpacing: CGFloat? = nil,
                paragraphSpacingAfter: CGFloat? = nil,
                alignment: NSTextAlignment? = nil,
                firstLineHeadIndent: CGFloat? = nil,
                headIndent: CGFloat? = nil,
                tailIndent: CGFloat? = nil,
                lineBreakMode: NSLineBreakMode? = nil,
                minimumLineHeight: CGFloat? = nil,
                maximumLineHeight: CGFloat? = nil,
                baseWritingDirection: NSWritingDirection? = nil,
                lineHeightMultiple: CGFloat? = nil,
                paragraphSpacingBefore: CGFloat? = nil,
                hyphenationFactor: Float? = nil) {

        self.initialAttributes = initialAttributes
        self.font = font
        self.link = link
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.underline = underline
        self.strikethrough = strikethrough
        self.baselineOffset = baselineOffset
        self.fontFeatureProviders = fontFeatureProviders
        self.adaptations = adaptations
        self.tracking = tracking
        self.lineSpacing = lineSpacing
        self.paragraphSpacingAfter = paragraphSpacingAfter
        self.alignment = alignment
        self.firstLineHeadIndent = firstLineHeadIndent
        self.headIndent = headIndent
        self.tailIndent = tailIndent
        self.lineBreakMode = lineBreakMode
        self.minimumLineHeight = minimumLineHeight
        self.maximumLineHeight = maximumLineHeight
        self.baseWritingDirection = baseWritingDirection
        self.lineHeightMultiple = lineHeightMultiple
        self.paragraphSpacingBefore = paragraphSpacingBefore
        self.hyphenationFactor = hyphenationFactor
    }

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
        var font = self.font
        if let textStyle = textStyle {
            if font == nil {
                font = UIFont.preferredFont(forTextStyle: textStyle)
            }
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

        // Apply the features to the font present
        let preFeaturedFont = theAttributes[NSFontAttributeName] as? UIFont
        let featuredFont = preFeaturedFont?.font(withFeatures: fontFeatureProviders)
        theAttributes.update(possibleValue: featuredFont, forKey: NSFontAttributeName)

        // Apply any adaptations
        for adaptation in adaptations {
            theAttributes = adaptation.style(attributes: theAttributes)
        }

        // Apply tracking once the final font is known
        let styledFont = theAttributes[NSFontAttributeName] as? UIFont
        theAttributes.update(possibleValue: tracking?.kerning(forFont: styledFont), forKey: NSKernAttributeName)

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

        fontFeatureProviders.append(contentsOf: stringStyle.fontFeatureProviders)
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
