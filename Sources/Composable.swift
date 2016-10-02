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

/// This protocol drives the string composition API. A key factor is asking objects
/// to append rather than fetching an attributed string to append. This is required for more
/// complex operations (like tab calculations)
public protocol Composable {
    func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle)
}

public extension Composable {

    /// Create an attributed string with only this composable content, and no base style.
    ///
    /// - returns: a new NSAttributedString
    public func attributedString() -> NSAttributedString {
        return .compose(with: [self])
    }

    /// Create a new NSAttributedString with the base style specified.
    ///
    /// - parameter style: The style to decorate with
    /// - returns: A new NSAttributedString
    public func styled(with style: AttributedStringStyle) -> NSAttributedString {
        let string = NSMutableAttributedString()
        self.append(to: string, baseStyle: style)
        return string
    }

    /// Create a new NSAttributedString with the style parts specified
    ///
    /// - parameter parts: The style parts to decorate with
    /// - returns: A new NSAttributedString
    public func styled(with parts: AttributedStringStylePart...) -> NSAttributedString {
        return styled(with: AttributedStringStyle.from(parts))
    }

}

public extension NSAttributedString {

    @nonobjc public static func compose(with composables: [Composable], baseStyle: AttributedStringStyle = AttributedStringStyle(), separator: Composable? = nil) -> NSAttributedString {
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

    /// Return a Composable that will add only the attributed string, and will ignore the containing style
    /// - parameter attributedString: The attributed string to compose without the baseStyle.
    /// - returns: A Composable that returns the attributedString without the baseStyle.
    public static func only(attributedString string: NSAttributedString) -> Composable {
        struct AttributedStringIgnoringStyle: Composable {
            let string: NSAttributedString

            func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle) {
                attributedString.append(string)
            }
        }

        return AttributedStringIgnoringStyle(string: string)
    }

}

extension NSAttributedString: Composable {

    @nonobjc public final func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle) {
        attributedString.append(attributedString: self, withBaseStyle: baseStyle)
    }

}

extension String: Composable {

    public func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle) {
        attributedString.append(baseStyle.attributedString(from: self))
    }

}

#if os(iOS) || os(tvOS) || os(OSX)
extension BONImage: Composable {

    @nonobjc public final func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle) {
        var attributes = baseStyle.attributes
        let baselinesOffsetForAttachment = attributes[NSBaselineOffsetAttributeName] as? CGFloat ?? 0
        let attachment = NSTextAttachment()
        attachment.image = self
        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: baselinesOffsetForAttachment), size: size)

        let attachmentString = NSAttributedString(attachment: attachment).mutableStringCopy()
        // Remove the baseline offset from the attributes so it isn't applied twice
        attributes[NSBaselineOffsetAttributeName] = nil
        attachmentString.addAttributes(attributes, range: NSRange(location: 0, length: attachmentString.length))

        attributedString.append(attachmentString)
    }

}
#endif

extension Special: Composable {

    public func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle) {
        attributedString.append(NSAttributedString(string: description, attributes: baseStyle.attributes))
    }

}
