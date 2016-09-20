//
//  AttributedStringStylePart.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

public enum AttributedStringStylePart {
    case initialAttributes(StyleAttributes)
    case font(UIFont)
    case textStyle(BonMotTextStyle)
    case link(NSURL)
    case backgroundColor(UIColor)
    case textColor(UIColor)
    case underline(NSUnderlineStyle, UIColor?)
    case strikethrough(NSUnderlineStyle, UIColor?)
    case baselineOffset(CGFloat)
    case alignment(NSTextAlignment)
    case fontFeature(FontFeatureProvider)
    case adapt(AdaptiveStyle)
    case style(StyleAttributeTransformation)
    case tracking(Tracking)
    case lineSpacing(CGFloat)
    case paragraphSpacingAfter(CGFloat)
    case firstLineHeadIndent(CGFloat)
    case headIndent(CGFloat)
    case tailIndent(CGFloat)
    case lineBreakMode(NSLineBreakMode)
    case minimumLineHeight(CGFloat)
    case maximumLineHeight(CGFloat)
    case baseWritingDirection(NSWritingDirection)
    case lineHeightMultiple(CGFloat)
    case paragraphSpacingBefore(CGFloat)
    case hyphenationFactor(Float)

}

#if swift(>=3.0)
    public func BonMot(_ parts: AttributedStringStylePart...) -> AttributedStringStyle {
        return AttributedStringStyle.from(parts: parts)
    }
#else
    public func BonMot(parts: AttributedStringStylePart...) -> AttributedStringStyle {
        return AttributedStringStyle.from(parts)
    }
#endif

extension AttributedStringStyle {

    public static func from(parts: [AttributedStringStylePart]) -> AttributedStringStyle {
        var style = AttributedStringStyle()
        for part in parts {
            style.update(attributedStringStylePart: part)
        }
        return style
    }

    #if swift(>=3.0)
    public func derive(_ parts: AttributedStringStylePart...) -> AttributedStringStyle {
        var style = self
        for part in parts {
            style.update(attributedStringStylePart: part)
        }
        return style
    }
    #else
    public func derive(parts: AttributedStringStylePart...) -> AttributedStringStyle {
        var style = self
        for part in parts {
            style.update(attributedStringStylePart: part)
        }
        return style
    }
    #endif

}

extension AttributedStringStyle {
    mutating func update(attributedStringStylePart stylePart: AttributedStringStylePart) {
        switch stylePart {
        case let .initialAttributes(attributes):
            self.initialAttributes = attributes
        case let .font(font):
            self.font = font
        case let .textStyle(textStyle):
            self.textStyle = textStyle
        case let .link(link):
            self.link = link
        case let .backgroundColor(backgroundColor):
            self.backgroundColor = backgroundColor
        case let .textColor(textColor):
            self.textColor = textColor
        case let .underline(underline):
            self.underline = underline
        case let .strikethrough(strikethrough):
            self.strikethrough = strikethrough
        case let .baselineOffset(baselineOffset):
            self.baselineOffset = baselineOffset
        case let .alignment(alignment):
            self.alignment = alignment
        case let .fontFeature(featureProvider):
            self.fontFeatureProviders.append(featureProvider)
        case let .adapt(style):
            self.adaptations.append(style)
        case let .style(style):
            self.adaptations.append(style)
        case let .tracking(tracking):
            self.tracking = tracking
        case let .lineSpacing(lineSpacing):
            self.lineSpacing = lineSpacing
        case let .paragraphSpacingAfter(paragraphSpacingAfter):
            self.paragraphSpacingAfter = paragraphSpacingAfter
        case let .firstLineHeadIndent(firstLineHeadIndent):
            self.firstLineHeadIndent = firstLineHeadIndent
        case let .headIndent(headIndent):
            self.headIndent = headIndent
        case let .tailIndent(tailIndent):
            self.tailIndent = tailIndent
        case let .lineBreakMode(lineBreakMode):
            self.lineBreakMode = lineBreakMode
        case let .minimumLineHeight(minimumLineHeight):
            self.minimumLineHeight = minimumLineHeight
        case let .maximumLineHeight(maximumLineHeight):
            self.maximumLineHeight = maximumLineHeight
        case let .baseWritingDirection(baseWritingDirection):
            self.baseWritingDirection = baseWritingDirection
        case let .lineHeightMultiple(lineHeightMultiple):
            self.lineHeightMultiple = lineHeightMultiple
        case let .paragraphSpacingBefore(paragraphSpacingBefore):
            self.paragraphSpacingBefore = paragraphSpacingBefore
        case let .hyphenationFactor(hyphenationFactor):
            self.hyphenationFactor = hyphenationFactor
        }
    }
}
