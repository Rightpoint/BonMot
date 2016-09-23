//
//  NSAttributedString+BonMot.swift
//
//  Created by Brian King on 7/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

extension NSAttributedString {

    /// Convenience initializer to embed an image in an attributed string. The passed in attributes will be added
    /// to the attributedString so the style can pass through, even if the attributes do not effect the image.
    ///
    /// - parameter image: The Image name to use
    /// - parameter attributes: The Attributes to embed in the image.
    /// - parameter baselineOffset: Convenience property to embed NSBaselineOffsetAttributeName in the attributes
    @objc(initBonMotWithImage:attributes:baselineOffset:)
    public convenience init(image: BONImage, attributes: StyleAttributes = [:], baselineOffset: CGFloat = 0) {
        // The baseline attachment key doesn't always work for text attachments. Shift the y of the bounds of the attachment instead.
        let baselinesOffsetForAttachment = attributes[NSBaselineOffsetAttributeName] as? CGFloat ?? baselineOffset
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: baselinesOffsetForAttachment), size: image.size)
        let string = NSAttributedString(attachment: attachment).mutableCopy() as! NSMutableAttributedString
        var attributes = attributes
        // Remove the baseline offset from the attributes so it isn't applied twice
        attributes[NSBaselineOffsetAttributeName] = nil
        string.addAttributes(attributes, range: NSRange(location: 0, length: string.length))
        self.init(attributedString: string)
    }

    /// Convenience initializer to join a collection of attributed strings with a separator attributed string.
    ///
    /// - parameter attributedStrings: A collection of attributed strings to join
    /// - parameter separator: The attributed string to use as a separator.
    /// - parameter removeTrailingKerning: A flag to remove the NSKernAttributeName property from the last character of the result.
    @objc(initBonMotWithAttributedStrings:separator:removeTrailingKerning:)
    public convenience init(attributedStrings: [NSAttributedString], separator: NSAttributedString? = nil, removeTrailingKerning: Bool = true) {

        let result = NSMutableAttributedString()
        for (index, attributedString) in attributedStrings.enumerated() {
            result.append(attributedString)
            if let separator = separator {
                if index != attributedStrings.indices.last {
                    result.append(separator)
                }
            }
        }
        if removeTrailingKerning {
            result.trimTrailingKernAttribute()
        }
        self.init(attributedString: result)
    }

    /// Create a new attributed string based on the current string, but replace characters in the Special enumeration,
    /// images, and unassigned unicode characters with a visual string.
    @objc(bon_debugRepresentation)
    public var debugRepresentation: NSAttributedString {
        guard let debug = self.mutableCopy() as? NSMutableAttributedString else {
            fatalError("Bad copy")
        }
        var replacements = Array<(range: NSRange, string: String)>()
        for (index, unicode) in string.unicodeScalars.enumerated() {
            guard let special = Special(rawValue: unicode) else { continue }
            var replacementString = special.name
            switch special {
            case .space:
                continue // substituting {space} for " " makes strings hard to read
            case .objectReplacementCharacter:
                if let attribute = self.attribute(NSAttachmentAttributeName, at: index, effectiveRange: nil) as? NSTextAttachment,
                    let image = attribute.image {
                    replacementString = String(format: "image%.3gx%.3g", image.size.width, image.size.height)
                }
            default:
                break
            }
            replacements.append((NSRange(location: index, length: 1), replacementString))
        }

        for replacement in replacements.reversed() {
            debug.replaceCharacters(in: replacement.range, with: "{\(replacement.string)}")
        }
        replacements = []

        let unassignedPrefix = "\\N{<unassigned-"
        let unassignedReplacement = "{unassignedUnicode<"
        var currentIndex: Int = 0
        for character in debug.string.characters {
            let utf16LengthOfCharacter = String(character).utf16.count
            let original = String(character) as NSString
            let transformed = original.applyingTransform(StringTransform.toUnicodeName, reverse: false)
            if let transformed = transformed {
                if transformed.hasPrefix(unassignedPrefix) && transformed.hasSuffix(">}") {
                    let range = NSRange(location: currentIndex, length: utf16LengthOfCharacter)
                    let newString = transformed.replacingOccurrences(of: unassignedPrefix, with: unassignedReplacement)
                    replacements.append((range, newString))
                }
            }
            currentIndex += utf16LengthOfCharacter
        }

        for replacement in replacements.reversed() {
            debug.replaceCharacters(in: replacement.range, with: replacement.string)
        }

        return debug
    }

}

extension NSMutableAttributedString {

    /// Append the string to the end of the attributed string. Apply the specified style on top of the attributes at
    /// the end of the attributed string if style is specified, otherwise just use the attributes at the end of the
    /// attributed string.
    ///
    /// - parameter string: The string to append.
    /// - parameter style: The style to apply to the string.
    /// - parameter traitCollection: The trait collection to use when applying the style.
    /// - return: The current attributed string
    public final func extend(with string: String, style: StyleAttributeTransformation?) {
        append(NSAttributedString(string: string, attributes: extendingAttributes(with: style)))
    }

    public final func extend(with attributedString: NSAttributedString, style: StyleAttributeTransformation?) {
        // Grab the last attributes in the string to extend into the specified attributed string
        let lastIndex = length - (length > 0 ? 1 : 0)
        let extendingAttributes = length > 0 ? attributes(at: lastIndex, effectiveRange: nil) : [:]
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.enumerateAttributes(in: range, options: []) { (attributes, range, stop) in
            let substring = attributedString.attributedSubstring(from: range)
            // Update the attributes to extend with the attributes in the current range
            var extendingAttributes = extendingAttributes
            attributes.forEach() { extendingAttributes.updateValue($1, forKey: $0) }
            // Apply the style to the attributes to extend
            let newStyle = style?.style(attributes: extendingAttributes) ?? extendingAttributes
            // Add the string with the extended attributes
            self.append(NSAttributedString(string: substring.string, attributes: newStyle))
        }
    }

    /// Append the image to the end of the attributed string. Apply the specified style on top of the attributes at
    /// the end of the attributed string if style is specified, otherwise just use the attributes at the end of the
    /// attributed string.
    ///
    /// - parameter image: The image to append.
    /// - parameter style: The style to apply to the string.
    /// - parameter traitCollection: The trait collection to use when applying the style.
    /// - return: The current attributed string
    public final func extend(with image: BONImage, style: StyleAttributeTransformation?) {
        append(NSAttributedString(image: image, attributes: extendingAttributes(with: style)))
    }

    /// Append a tab stop to the attributed string, and configure the tab to end `tabStopWithSpacer` points after the
    /// end of the current attributed string. If the tabStops are the default tab stops, the tab stops will be cleared out
    /// before adding this tab stop.
    ///
    /// - parameter tabStopWithSpacer: Points to add to the end of the current string
    /// - parameter shiftHeadIndent: Shift the head indent to the tab stop so that any word wrapping will be aligned with the tab stop. This defaults to true since it's usually the desired behavior.
    /// - return: The current attributed string
    @objc(bon_extendWithTabSpacer:shiftHeadIndent:)
    public func extend(withTabSpacer spacer: CGFloat, shiftHeadIndent: Bool = true) {
        let max = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        let width = boundingRect(with: max, options: .usesLineFragmentOrigin, context: nil).width
        let tabSize = spacer + ceil(width)
        let lastIndex = length - (length > 0 ? 1 : 0)
        var effectiveRange = NSRange(location: 0, length: length)
        var attributes = length > 0 ? self.attributes(at: lastIndex, effectiveRange: &effectiveRange) : [:]
        let paragraph = StyleAttributeHelpers.paragraph(from: attributes)
        if paragraph.tabStops == NSParagraphStyle.bon_default.tabStops {
            paragraph.tabStops = []
        }
        paragraph.addTabStop(NSTextTab(textAlignment: .natural, location: tabSize, options: [:]))
        if shiftHeadIndent {
            paragraph.headIndent = tabSize
        }
        addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: effectiveRange)
        attributes[NSParagraphStyleAttributeName] = paragraph
        append(NSAttributedString(string: "\t", attributes: attributes))
    }

    /// If you are centering text and the NSKernAttributeName attribute is specified, UIKit will incorrectly
    /// pad the string.
    @objc(bon_trimTrailingKernAttribute)
    public func trimTrailingKernAttribute() {
        if length > 0 {
            let lastCharacterRange = NSRange(location: length - 1, length: 1)
            removeAttribute(NSKernAttributeName, range: lastCharacterRange)
        }
    }

    /// Helper function to determine the attributes to use when appending content.
    internal final func extendingAttributes(with style: StyleAttributeTransformation?) -> StyleAttributes {
        let lastIndex = length - (length > 0 ? 1 : 0)
        let finalAttributes = length > 0 ? attributes(at: lastIndex, effectiveRange: nil) : [:]
        return style?.style(attributes: finalAttributes) ?? finalAttributes
    }

    /// Helper function to apply a style to a range of a trait collection
    internal final func apply(style theStyle: StyleAttributeTransformation, range: NSRange) {
        let attributes = self.attributes(at: range.location, effectiveRange: nil)
        let newAttributes = theStyle.style(attributes: attributes)
        setAttributes(newAttributes, range: range)
    }

}

extension NSMutableAttributedString {

    /// Append the string to the end of the attributed string. Apply the style specified on top of the attributes at
    /// the end of the attributed string if styleName is specified, otherwise just use the attributes at the end of the
    /// attributed string.
    ///
    /// - parameter string: The string to append.
    /// - parameter styleNamed: The style name registered in the shared TagStyle object to apply to the string.
    /// - parameter traitCollection: The trait collection to use when applying the style.
    /// - return: The current attributed string
    @objc(bon_extendWithString:styleNamed:)
    public final func extend(with string: String, styleNamed name: String? = nil) {
        let style = TagStyles.shared.style(forName: name)
        append(NSAttributedString(string: string, attributes: extendingAttributes(with: style)))
    }

    /// Append the image to the end of the attributed string with the attributes at the end of the attributed string.
    ///
    /// - parameter image: The image to append.
    /// - parameter style: The style to apply to the string.
    /// - parameter traitCollection: The trait collection to use when applying the style.
    /// - return: The current attributed string
    @objc(bon_extendWithImage:)
    public final func extend(with image: BONImage) {
        append(NSAttributedString(image: image, attributes: extendingAttributes(with: nil)))
    }

}

