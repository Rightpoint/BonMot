//
//  StylePart.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// StylePart encapsulates one setting in StringStyle. It is used
/// as a DSL for building StringStyle across BonMot, but it is just syntactic sugar.
public enum StylePart {
    case initialAttributes(StyleAttributes)
    case font(BONFont)
    case link(NSURL)
    case backgroundColor(BONColor)
    case color(BONColor)
    case underline(NSUnderlineStyle, BONColor?)
    case strikethrough(NSUnderlineStyle, BONColor?)
    case baselineOffset(CGFloat)

    case ligatures(Ligatures)

    case alignment(NSTextAlignment)
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

    case xml
    case xmlRules([XMLStyleRule])
    case xmlStyler(XMLStyler)
    #if os(iOS) || os(tvOS) || os(OSX)
    case fontFeature(FontFeatureProvider)

    case numberSpacing(NumberSpacing)
    case numberCase(NumberCase)

    case superscript(Bool)
    case `subscript`(Bool)
    case ordinals(Bool)
    case scientificInferiors(Bool)

    case smallCaps(SmallCaps)
    #endif
    #if os(iOS) || os(tvOS)
    case textStyle(BonMotTextStyle)
    #endif
    #if os(iOS) || os(tvOS)
    case adapt(AdaptiveStyle)
    #endif

    // An advanced part that allows combining multiple parts as a single part
    case style(StringStyle)
}

extension StringStyle {

    /// Create a `StringStyle` from an array of parts
    ///
    /// - Parameter parts: An array of `StylePart`s
    public init(_ parts: StylePart...) {
        self.init(parts)
    }

    /// Create a `StringStyle` from an array of parts
    ///
    /// - Parameter parts: An array of `StylePart`s
    public init(_ parts: [StylePart]) {
        self.init()
        for part in parts {
            self.update(part: part)
        }
    }

    #if swift(>=3.0)
    #else
    /// Create a `StringStyle` from a part. This is needed for Swift 2.3 determine argument type.
    ///
    /// - Parameter part: a `StylePart`
    public init(_ part: StylePart) {
        self.init()
        self.update(part: part)
    }
    #endif

    #if swift(>=3.0)
    /// Derive a new `StringStyle` based on this style, updated with an array of `StylePart`s.
    ///
    /// - Parameter parts: An array of `StylePart`s
    /// - Returns: A newly configured `StringStyle`
    public func byAdding(_ parts: StylePart...) -> StringStyle {
        var style = self
        for part in parts {
            style.update(part: part)
        }
        return style
    }
    #else
    /// Derive a new `StringStyle` based on this style, updated with an array of `StylePart`s.
    ///
    /// - Parameter parts: An array of `StylePart`s
    /// - Returns: A newly configured `StringStyle`
    public func byAdding(parts: StylePart...) -> StringStyle {
        var style = self
        for part in parts {
            style.update(part: part)
        }
        return style
    }
    #endif

}

extension StringStyle {

    /// Update the style with the specified style part.
    ///
    // swiftlint:disable function_body_length
    // swiftlint:disable:next cyclomatic_complexity
    mutating func update(part stylePart: StylePart) {
        switch stylePart {
        case let .initialAttributes(attributes):
            self.initialAttributes = attributes
        case let .font(font):
            self.font = font
        case let .link(link):
            self.link = link
        case let .backgroundColor(backgroundColor):
            self.backgroundColor = backgroundColor
        case let .color(color):
            self.color = color
        case let .underline(underline):
            self.underline = underline
        case let .strikethrough(strikethrough):
            self.strikethrough = strikethrough
        case let .baselineOffset(baselineOffset):
            self.baselineOffset = baselineOffset
        case let .ligatures(ligatures):
            self.ligatures = ligatures
        case let .alignment(alignment):
            self.alignment = alignment
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
        case .xml:
            self.xmlStyler = NSAttributedString.defaultXMLStyler
        case var .xmlRules(rules):
            rules.append(contentsOf: Special.insertionRules)
            self.xmlStyler = XMLRuleStyler(rules: rules)
        case let .xmlStyler(xmlStyler):
            self.xmlStyler = xmlStyler
        case let .style(style):
            self.add(stringStyle: style)
        default:
            // #if and enum's are disapointing. This case is in default: to remove a warning that default won't be accessed on some platforms.
            if case let .hyphenationFactor(hyphenationFactor) = stylePart {
                self.hyphenationFactor = hyphenationFactor
            }
            #if os(OSX) || os(iOS) || os(tvOS)
                if case let .numberCase(numberCase) = stylePart {
                    self.fontFeatureProviders += [numberCase as FontFeatureProvider]
                    return
                }
                else if case let .numberSpacing(numberSpacing) = stylePart {
                    self.fontFeatureProviders += [numberSpacing as FontFeatureProvider]
                    return
                }
                else if case let .superscript(superscript) = stylePart {
                    self.fontFeatureProviders += [superscript ? VerticalPosition.superscript : VerticalPosition.normal as FontFeatureProvider]
                    return
                }
                else if case let .`subscript`(`subscript`) = stylePart {
                    self.fontFeatureProviders += [`subscript` ? VerticalPosition.`subscript` : VerticalPosition.normal as FontFeatureProvider]
                    return
                }
                else if case let .ordinals(ordinals) = stylePart {
                    self.fontFeatureProviders += [ordinals ? VerticalPosition.ordinals : VerticalPosition.normal as FontFeatureProvider]
                    return
                }
                else if case let .scientificInferiors(scientificInferiors) = stylePart {
                    self.fontFeatureProviders += [scientificInferiors ? VerticalPosition.scientificInferiors : VerticalPosition.normal as FontFeatureProvider]
                    return
                }
                else if case let .smallCaps(smallCaps) = stylePart {
                    self.fontFeatureProviders += [smallCaps as FontFeatureProvider]
                    return
                }
                else if case let .fontFeature(featureProvider) = stylePart {
                    self.fontFeatureProviders.append(featureProvider)
                }
            #endif
            #if os(iOS) || os(tvOS)
                if case let .adapt(style) = stylePart {
                    self.adaptations.append(style)
                }
                else if case let .textStyle(textStyle) = stylePart {
                    self.font = UIFont.bon_preferredFont(forTextStyle: textStyle, compatibleWith: nil)
                }
            #endif
        }
    }
    //swiftlint:enable function_body_length
}
