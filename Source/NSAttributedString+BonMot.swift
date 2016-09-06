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
    public convenience init(image: UIImage, attributes: StyleAttributes = [:], baselineOffset: CGFloat = 0) {
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
            let lastCharacterRange = NSRange(location: result.length - 1, length: 1)
            result.removeAttribute(NSKernAttributeName, range: lastCharacterRange)
        }
        self.init(attributedString: result)
    }

    /// Adapt a set of attributes to the specified trait collection. This will use the style object defined in the attributes or use the default style object specified.
    ///
    /// - parameter attributes: The attributes to transform
    /// - parameter traitCollection: The trait collection to transform the attributes too
    /// - parameter defaultStyle: The style to apply if there is no style specified in the attributes
    /// - returns: Attributes with fonts updated to the specified content size category.
    public static func adapt(attributes theAttributes: StyleAttributes, toTraitCollection traitCollection: UITraitCollection, defaultStyle: StyleAttributeProvider?) -> StyleAttributes {
        var attributes = theAttributes
        if let styleHolder = attributes[StyleAttributeProviderAttributeName] as? StyleAttributeProviderHolder {
            attributes = styleHolder.style.styleAttributes(attributes: attributes, traitCollection: traitCollection)
        }
        else if let style = defaultStyle {
            attributes = style.styleAttributes(attributes: attributes, traitCollection: traitCollection)
        }

        return attributes
    }

    /// Create a new NSAttributedString adapted to the new trait collection. This will re-apply the embedded style 
    /// objects or apply the defaultStyle object if no styles are present.
    ///
    /// - parameter toTraitCollection: The trait collection containing the attribute string to be transformed.
    /// - parameter defaultStyle: The style to apply if there is no style specified in the attributes
    ///
    /// - returns: A new NSAttributedString with the style updated to the new trait collection.
    public final func adapt(toTraitCollection traitCollection: UITraitCollection, defaultStyle: StyleAttributeProvider?) -> NSMutableAttributedString {
        let wholeRange = NSRange(location: 0, length: length)
        guard let newString = mutableCopy() as? NSMutableAttributedString else {
            fatalError("Force cast of mutable copy failed.")
        }
        // Apply the embedded style
        #if swift(>=3.0)
            let unstyledIndexes = NSMutableIndexSet(indexesIn: wholeRange)
            newString.enumerateAttribute(StyleAttributeProviderAttributeName, in: wholeRange, options: []) { attr, range, stopPtr in
                if let holder = attr as? StyleAttributeProviderHolder {
                    newString.apply(style: holder.style, range: range, traitCollection: traitCollection, embedStyle: true)
                    unstyledIndexes.remove(in: range)
                }
            }
            if let defaultStyle = defaultStyle {
                unstyledIndexes.enumerateRanges(options: []) { range, stop in
                    newString.apply(style: defaultStyle, range: range, traitCollection: traitCollection)
                }
            }
        #else
            let unstyledIndexes = NSMutableIndexSet(indexesInRange: wholeRange)
            newString.enumerateAttribute(StyleAttributeProviderAttributeName, inRange: wholeRange, options: []) { attr, range, stopPtr in
                if let holder = attr as? StyleAttributeProviderHolder {
                    newString.apply(style: holder.style, range: range, traitCollection: traitCollection, embedStyle: true)
                    unstyledIndexes.removeIndexesInRange(range)
                }
            }
            if let defaultStyle = defaultStyle {
                unstyledIndexes.enumerateRangesUsingBlock() { range, stop in
                    newString.apply(style: defaultStyle, range: range, traitCollection: traitCollection)
                }
            }
        #endif
        return newString
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
            #if swift(>=3.0)
                let transformed = original.applyingTransform(StringTransform.toUnicodeName, reverse: false)
            #else
                let transformed = original.stringByApplyingTransform(NSStringTransformToUnicodeName, reverse: false)
            #endif
            if let transformed = transformed {
                if transformed.hasPrefix(unassignedPrefix) && transformed.hasSuffix(">}") {
                    let range = NSRange(location: currentIndex, length: utf16LengthOfCharacter)

                    #if swift(>=3.0)
                        let newString = transformed.replacingOccurrences(of: unassignedPrefix, with: unassignedReplacement)
                    #else
                        let newString = transformed.stringByReplacingOccurrencesOfString(unassignedPrefix, withString: unassignedReplacement)
                    #endif
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
    public final func append(string theString: String, style: StyleAttributeProvider?, traitCollection: UITraitCollection? = nil) -> NSMutableAttributedString {
        append(NSAttributedString(string: theString, attributes: attributesToAppend(withStyle: style, traitCollection: traitCollection)))
        return self
    }

    /// Append the image to the end of the attributed string. Apply the specified style on top of the attributes at
    /// the end of the attributed string if style is specified, otherwise just use the attributes at the end of the
    /// attributed string.
    ///
    /// - parameter image: The image to append.
    /// - parameter style: The style to apply to the string.
    /// - parameter traitCollection: The trait collection to use when applying the style.
    /// - return: The current attributed string
    public final func append(image theImage: UIImage, style: StyleAttributeProvider?, traitCollection: UITraitCollection? = nil) -> NSMutableAttributedString {
        append(NSAttributedString(image: theImage, attributes: attributesToAppend(withStyle: style, traitCollection: traitCollection)))
        return self
    }

    /// Append a tab stop to the attributed string, and configure the tab to end `tabStopWithSpacer` points after the
    /// end of the current attributed string. If the tabStops are the default tab stops, the tab stops will be cleared out
    /// before adding this tab stop.
    ///
    /// - parameter tabStopWithSpacer: Points to add to the end of the current string
    /// - parameter shiftHeadIndent: Shift the head indent to the tab stop so that any word wrapping will be aligned with the tab stop. This defaults to true since it's usually the desired behavior.
    /// - return: The current attributed string
    @objc(bon_appendTabStopWithSpacer:shiftHeadIndent:)
    public func append(tabStopWithSpacer spacer: CGFloat, shiftHeadIndent: Bool = true) -> NSMutableAttributedString {
        #if swift(>=3.0)
            let max = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
            let width = boundingRect(with: max, options: .usesLineFragmentOrigin, context: nil).width
            let alignment: NSTextAlignment = .natural
            let defaults = NSParagraphStyle.default
        #else
            let max = CGSize(width: CGFloat.max, height: .max)
            let width = boundingRectWithSize(max, options: .UsesLineFragmentOrigin, context: nil).width
            let alignment: NSTextAlignment = .Natural
            let defaults = NSParagraphStyle.defaultParagraphStyle()
        #endif

        let tabSize = spacer + ceil(width)
        var effectiveRange: NSRange = NSRange(location: 0, length: length)
        let lastIndex = length - (length > 0 ? 1 : 0)
        var attributes = length > 0 ? self.attributes(at: lastIndex, effectiveRange: &effectiveRange) : [:]
        let paragraph = NSMutableParagraphStyle.from(object: attributes[NSParagraphStyleAttributeName])
        if paragraph.tabStops == defaults.tabStops {
            paragraph.tabStops = []
        }
        paragraph.addTabStop(NSTextTab(textAlignment: alignment, location: tabSize, options: [:]))
        if shiftHeadIndent {
            paragraph.headIndent = tabSize
        }
        addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: effectiveRange)
        attributes[NSParagraphStyleAttributeName] = paragraph
        append(NSAttributedString(string: "\t", attributes: attributes))
        return self
    }

    /// Helper function to determine the attributes to use when appending content.
    internal final func attributesToAppend(withStyle style: StyleAttributeProvider?, traitCollection: UITraitCollection?) -> StyleAttributes {
        let lastIndex = length - (length > 0 ? 1 : 0)
        let finalAttributes = length > 0 ? attributes(at: lastIndex, effectiveRange: nil) : [:]
        return style?.styleAttributes(attributes: finalAttributes, traitCollection: traitCollection) ?? finalAttributes
    }

    /// Helper function to apply a style to a range of a trait collection
    internal final func apply(style theStyle: StyleAttributeProvider, range: NSRange, traitCollection: UITraitCollection?, embedStyle: Bool = false) {
        let attributes = self.attributes(at: range.location, effectiveRange: nil)
        let newAttributes = theStyle.styleAttributes(attributes: attributes, traitCollection: traitCollection)
        setAttributes(newAttributes, range: range)
        if embedStyle {
            addAttribute(StyleAttributeProviderAttributeName, value: StyleAttributeProviderHolder(style: theStyle), range: range)
        }
    }

}

/// Objective-C Compatibility
extension NSAttributedString {

    /// Create a new NSAttributedString adapted to the new trait collection. This will re-apply the embedded style objects in the attributed string and is compatible with Obj-C.
    ///
    /// - parameter toTraitCollection: The trait collection containing the attribute string to be transformed.
    ///
    /// - returns: A new NSAttributedString with the style updated to the new trait collection.
    @objc(bon_adaptToTraitCollection:)
    public final func adapt(toTraitCollection traitCollection: UITraitCollection) -> NSMutableAttributedString {
        return adapt(toTraitCollection: traitCollection, defaultStyle: nil)
    }

    /// Adapt a set of attributes to the specified trait collection. This will use the style object defined in the attributes dictionary and is compatible with Obj-C.
    ///
    /// - parameter attributes: The attributes to transform
    /// - parameter traitCollection: The trait collection to transform the attributes too
    ///
    /// - returns: Attributes with fonts updated to the specified content size category.
    @objc(bon_adaptAttributes:toTraitCollection:)
    public static func adapt(attributes theAttributes: StyleAttributes, toTraitCollection traitCollection: UITraitCollection) -> StyleAttributes {
        return adapt(attributes: theAttributes, toTraitCollection: traitCollection, defaultStyle: nil)
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
    @objc(bon_appendString:styleNamed:traitCollection:)
    public final func append(string theString: String, styleNamed name: String? = nil, traitCollection: UITraitCollection? = nil) -> NSMutableAttributedString {
        let style = TagStyles.shared.style(forName: name)
        append(NSAttributedString(string: theString, attributes: attributesToAppend(withStyle: style, traitCollection: traitCollection)))
        return self
    }

    /// Append the image to the end of the attributed string with the attributes at the end of the attributed string.
    ///
    /// - parameter image: The image to append.
    /// - parameter style: The style to apply to the string.
    /// - parameter traitCollection: The trait collection to use when applying the style.
    /// - return: The current attributed string
    @objc(bon_appendImage:traitCollection:)
    public final func append(image theImage: UIImage, traitCollection: UITraitCollection? = nil) -> NSMutableAttributedString {
        append(NSAttributedString(image: theImage, attributes: attributesToAppend(withStyle: nil, traitCollection: traitCollection)))
        return self
    }

}

