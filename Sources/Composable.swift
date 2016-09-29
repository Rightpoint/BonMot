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

public protocol Composable {
    func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle)
}

public extension Composable {

    public func attributedString() -> NSAttributedString {
        return .compose(with: [self])
    }

    public func styled(with style: AttributedStringStyle) -> Composable {
        let string = NSMutableAttributedString()
        self.append(to: string, baseStyle: style)
        return string
    }

    public func styled(with parts: AttributedStringStylePart...) -> Composable {
        return styled(with: AttributedStringStyle.from(parts))
    }

}

public extension NSAttributedString {

    @nonobjc public static func compose(with composables: [Composable], baseStyle: AttributedStringStyle = AttributedStringStyle(), separator: Composable? = nil) -> NSAttributedString {
        let string = NSMutableAttributedString()
        string.beginEditing()
        for (index, textable) in composables.enumerated() {
            textable.append(to: string, baseStyle: baseStyle)
            if let separator = separator {
                if index != composables.indices.last {
                    separator.append(to: string, baseStyle: baseStyle)
                }
            }
        }
        string.endEditing()
        return string
    }

    /**
     * Return a Composable that will add only the attributed string, and will ignore the containing style
     */
    public static func only(attributedString string: NSAttributedString) -> Composable {
        return AttributedStringIgnoringStyle(string: string)
    }
}

extension NSAttributedString: Composable {

    @nonobjc public final func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle) {
        attributedString.extend(with: self, style: baseStyle)
    }
    
}

struct AttributedStringIgnoringStyle: Composable {
    let string: NSAttributedString

    func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle) {
        attributedString.append(string)
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
        var range = NSRange()
        var attributes = attributedString.extendingAttributes(with: baseStyle, effectiveRange: &range)
        let baselinesOffsetForAttachment = attributes[NSBaselineOffsetAttributeName] as? CGFloat ?? 0
        let attachment = NSTextAttachment()
        attachment.image = self
        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: baselinesOffsetForAttachment), size: size)

        let attachmentString = NSAttributedString(attachment: attachment).mutableCopy() as! NSMutableAttributedString
        // Remove the baseline offset from the attributes so it isn't applied twice
        attributes[NSBaselineOffsetAttributeName] = nil
        attachmentString.addAttributes(attributes, range: NSRange(location: 0, length: attachmentString.length))

        attributedString.append(attachmentString)
    }

}
#endif

extension Special: Composable {

    public func append(to attributedString: NSMutableAttributedString, baseStyle: AttributedStringStyle) {
        attributedString.append(NSAttributedString(string: description, attributes: baseStyle.attributes()))
    }

}
