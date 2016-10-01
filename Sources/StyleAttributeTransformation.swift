//
//  StyleAttributeTransformation.swift
//
//  Created by Brian King on 8/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// StyleAttributeTransformation declares a transformation of attributes. The trait collection is passed along so values can
/// be customized depending on the trait collection. This is the primary contract provided by BonMot that allows
/// the transformation of attributes along with a traitCollection
public protocol StyleAttributeTransformation {

    func style(attributes theAttributes: StyleAttributes) -> StyleAttributes

}

/// An extension to provide UIKit interaction helpers to the style object
public extension StyleAttributeTransformation {

    public func attributes() -> StyleAttributes {
        return style(attributes: [:])
    }

    public func attributedString(from theString: String) -> NSMutableAttributedString {
        let attributes = style(attributes: [:])
        return NSMutableAttributedString(string: theString, attributes: attributes)
    }

    /// Obtain the StyleAttributes from the transformation and use those values only when the supplied attributes
    /// do not have a value.
    ///
    /// If any of the values support in the StyleAttributes dictionary should be merged that behavior should be
    /// performed here. This includes NSParagraphStyle and the embedded attributes.
    func supply(defaultsFor attributes: StyleAttributes) -> StyleAttributes {
        var attributes = attributes
        for (key, value) in self.attributes() {
            switch (key, value, attributes[key]) {
            case (NSParagraphStyleAttributeName, let paragraph as NSParagraphStyle, let otherParagraph as NSParagraphStyle):
                attributes[NSParagraphStyleAttributeName] = paragraph.supply(defaultsFor: otherParagraph)
            case (BonMotTransformationsAttributeName, var transformations as Array<Any>, let otherTransformations as Array<Any>):
                transformations.insert(contentsOf: otherTransformations, at: 0)
                attributes[BonMotTransformationsAttributeName] = transformations
            case let (key, value, nil):
                attributes.update(possibleValue: value, forKey: key)
            default:
                break
            }
        }
        return attributes
    }
}

extension NSParagraphStyle {

    /// Update the supplied NSParagraphStyle properties with the value in this ParagraphStyle if the supplied
    /// ParagraphStyle property is the default value.
    // swiftlint:disable:next cyclomatic_complexity
    func supply(defaultsFor paragraphStyle: NSParagraphStyle) -> NSMutableParagraphStyle {
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
