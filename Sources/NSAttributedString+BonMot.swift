//
//  NSAttributedString+BonMot.swift
//
//  Created by Brian King on 7/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

extension NSAttributedString {

    /// Create a new attributed string based on the current string, but replace characters in the Special enumeration,
    /// images, and unassigned unicode characters with a visual string.
    @objc(bon_debugRepresentation)
    public var debugRepresentation: NSAttributedString {
        let debug = self.mutableStringCopy()
        var replacements = Array<(range: NSRange, string: String)>()
        for (index, unicode) in string.unicodeScalars.enumerated() {
            guard let special = Special(rawValue: unicode) else { continue }
            var replacementString = special.name
            switch special {
            case .space:
                continue // substituting {space} for " " makes strings hard to read
            case .objectReplacementCharacter:
                #if os(iOS) || os(tvOS) || os(OSX)
                    if let attribute = self.attribute(NSAttachmentAttributeName, at: index, effectiveRange: nil) as? NSTextAttachment,
                        let image = attribute.image {
                        replacementString = String(format: "image%.3gx%.3g", image.size.width, image.size.height)
                    }
                #else
                    break
                #endif
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
