//
//  AttributedStringStylePart.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public enum AttributedStringStylePart {
    case initialAttributes(StyleAttributes)
    case font(BONFont)
    case link(NSURL)
    case backgroundColor(BONColor)
    case textColor(BONColor)
    case underline(NSUnderlineStyle, BONColor?)
    case strikethrough(NSUnderlineStyle, BONColor?)
    case baselineOffset(CGFloat)
    case alignment(NSTextAlignment)
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
    #if os(iOS) || os(tvOS) || os(OSX)
    case fontFeature(FontFeatureProvider)
    #endif
    #if os(iOS) || os(tvOS)
    case textStyle(BonMotTextStyle)
    #endif
    #if os(iOS) || os(tvOS)
    case adapt(AdaptiveStyle)
    #endif

}

extension AttributedStringStyle {

    #if swift(>=3.0)
    public static func from(_ parts: [AttributedStringStylePart]) -> AttributedStringStyle {
        var style = AttributedStringStyle()
        for part in parts {
            style.update(attributedStringStylePart: part)
        }
        return style
    }

    public func derive(_ parts: AttributedStringStylePart...) -> AttributedStringStyle {
        var style = self
        for part in parts {
            style.update(attributedStringStylePart: part)
        }
        return style
    }
    #else
    public static func from(parts: [AttributedStringStylePart]) -> AttributedStringStyle {
        var style = AttributedStringStyle()
        for part in parts {
            style.update(attributedStringStylePart: part)
        }
        return style
    }

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

    // swiftlint:disable cyclomatic_complexity
    mutating func update(attributedStringStylePart stylePart: AttributedStringStylePart) {
        switch stylePart {
        case let .initialAttributes(attributes):
            self.initialAttributes = attributes
        case let .font(font):
            self.font = font
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
        default:
            // #if and enum's are disapointing. I'm moving one case into the default catch all to remove a warning that default won't be accessed on some platforms.
            if case let .hyphenationFactor(hyphenationFactor) = stylePart {
                self.hyphenationFactor = hyphenationFactor
            }
            #if os(iOS) || os(tvOS)
                if case let .adapt(style) = stylePart {
                    self.adaptations.append(style)
                }
                else if case let .fontFeature(featureProvider) = stylePart {
                    self.fontFeatureProviders.append(featureProvider)
                }
                else if case let .textStyle(textStyle) = stylePart {
                    self.font = UIFont.bon_preferredFont(forTextStyle: textStyle, compatibleWith: nil)
                }
            #endif
        }
        // swiftlint:enable cyclomatic_complexity
    }
}
