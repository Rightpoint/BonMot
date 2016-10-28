//
//  Composable.swift
//  BonMot
//
//  Created by Brian King on 9/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// The protocol that drives the string composition API. The protocol will request that the object
/// append rather than fetching an attributed string to append. This allows more
/// complex operations (like tab calculations)
public protocol Composable {
    func append(to attributedString: NSMutableAttributedString, baseStyle: StringStyle)
}

public extension Composable {

    /// Create an attributed string with only this composable content, and no base style.
    ///
    /// - returns: a new NSAttributedString
    public func attributedString() -> NSAttributedString {
        return .composed(of: [self])
    }

    /// Create a new NSAttributedString with the base style specified.
    ///
    /// - parameter style: The style to decorate with
    /// - returns: A new NSAttributedString
    public func styled(with style: StringStyle) -> NSAttributedString {
        let string = NSMutableAttributedString()
        self.append(to: string, baseStyle: style)
        return string
    }

    /// Create a new NSAttributedString with the style parts specified
    ///
    /// - parameter parts: The style parts to decorate with
    /// - returns: A new NSAttributedString
    public func styled(with parts: StringStylePart...) -> NSAttributedString {
        var style = StringStyle()
        for part in parts {
            style.update(stringStylePart: part)
        }
        return styled(with: style)
    }

}

public extension NSAttributedString {

    /// Compose an NSAttributedString with by appending every item in `composables` with the `baseStyle` applied. The `separator` will be
    /// appended after every item. `baseStyle` will act as the default style, and will only apply to the Composable item if the Composable
    /// does not have a style value configured.
    ///
    /// - parameter composables: An array of Composable to create an NSAttributedString from.
    /// - parameter baseStyle: The baseStyle to apply to every Composable. If no baseStyle is supplied, no additional styling will be added.
    /// - parameter separator: The separator to join `composables` with.
    /// - returns: A new NSAttributedString
    @nonobjc public static func composed(of composables: [Composable], baseStyle: StringStyle = StringStyle(), separator: Composable? = nil) -> NSAttributedString {
        let string = NSMutableAttributedString()
        string.beginEditing()
        for (index, composable) in composables.enumerated() {
            composable.append(to: string, baseStyle: baseStyle)
            if let separator = separator {
                if index != composables.indices.last {
                    separator.append(to: string, baseStyle: baseStyle)
                }
            }
        }
        string.endEditing()
        return string
    }

    /// Return a Composable that will add only the attributed string, and will ignore the containing baseStyle.
    ///
    /// - parameter attributedString: The attributed string to compose without the baseStyle.
    /// - returns: A Composable that returns the attributedString without the baseStyle.
    public static func only(attributedString string: NSAttributedString) -> Composable {
        struct AttributedStringIgnoringStyle: Composable {
            let string: NSAttributedString

            func append(to attributedString: NSMutableAttributedString, baseStyle: StringStyle) {
                attributedString.append(string)
            }
        }

        return AttributedStringIgnoringStyle(string: string)
    }

}

extension NSAttributedString: Composable {

    /// Append this NSAttributedString to `attributedString`, with `baseStyle` applied as default values. This method will
    /// enumerate all attribute ranges in this attributed string and use `baseStyle` to supply defaults for the attributes. This
    /// will effectively merge baseStyle and the embedded attributes, with preference going to the embedded attributes.
    /// See baseStyle.supplyDefaults(for:) for more details.
    ///
    /// - parameter to: The attributed string to append to
    /// - parameter baseStyle: The baseStyle that is over-ridden by this string.
    @nonobjc public final func append(to attributedString: NSMutableAttributedString, baseStyle: StringStyle) {
        let range = NSRange(location: 0, length: length)
        enumerateAttributes(in: range, options: []) { (attributes, range, _) in
            let substring = self.attributedSubstring(from: range)
            // Add the string with the defaults supplied by the style
            let newString = baseStyle.attributedString(from: substring.string, existingAttributes: attributes)
            attributedString.append(newString)
        }
    }

}

extension String: Composable {

    /// Append this String to `attributedString`, with `baseStyle` applied. Since String has no style, baseStyle is the style.
    ///
    /// - parameter to: The attributed string to append to.
    /// - parameter baseStyle: The style to use for this string.
    public func append(to attributedString: NSMutableAttributedString, baseStyle: StringStyle) {
        attributedString.append(baseStyle.attributedString(from: self))
    }

}

#if os(iOS) || os(tvOS) || os(OSX)
extension BONImage: Composable {

    /// Append this Image to `attributedString`, with `baseStyle` applied. Only a few properties in baseStyle are relevant when appending
    /// images. These include baselineOffset, and color for template images. All attributes are stored in the range of the image for consistency
    /// inside the attributed string.
    ///
    /// NOTE: the NSBaselineOffsetAttributeName value is used as the `y` value for the text attachment and is removed from the attributes dictionary to fix an issue with UIKit.
    /// NOTE: NSTextAttachment is not available on watchOS.
    ///
    /// - parameter to: The attributed string to append to.
    /// - parameter baseStyle: The style to use.
    @nonobjc public final func append(to attributedString: NSMutableAttributedString, baseStyle: StringStyle) {
        let baselinesOffsetForAttachment = baseStyle.baselineOffset ?? 0
        let attachment = NSTextAttachment()

        #if os(OSX)
            let imageIsTemplate = isTemplate
        #else
            let imageIsTemplate = (renderingMode != UIImageRenderingMode.alwaysOriginal)
        #endif

        var imageToUse = self
        if let color = baseStyle.color {
            if imageIsTemplate {
                imageToUse = tintedImage(color: color)
            }
        }
        attachment.image = imageToUse

        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: baselinesOffsetForAttachment), size: size)

        let attachmentString = NSAttributedString(attachment: attachment).mutableStringCopy()
        // Remove the baseline offset from the attributes so it isn't applied twice
        var attributes = baseStyle.attributes
        attributes[NSBaselineOffsetAttributeName] = nil
        attachmentString.addAttributes(attributes, range: NSRange(location: 0, length: attachmentString.length))

        attributedString.append(attachmentString)
    }

}
#endif

extension Special: Composable {

    /// Relay this call to the description property and use the String behavior on unicode value.
    ///
    /// - parameter to: The attributed string to append to.
    /// - parameter baseStyle: The style to use.
    public func append(to attributedString: NSMutableAttributedString, baseStyle: StringStyle) {
        description.append(to: attributedString, baseStyle: baseStyle)
    }

}
