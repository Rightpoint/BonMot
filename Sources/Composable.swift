//
//  Composable.swift
//  BonMot
//
//  Created by Brian King on 9/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

public protocol Composable {
    func append(to attributedString: NSMutableAttributedString, style: AttributedStringStyle)
}

public extension Composable {

    public func attributedString() -> NSAttributedString {
        return .compose(with: [self])
    }

    public func styled(with style: AttributedStringStyle) -> Composable {
        let string = NSMutableAttributedString()
        self.append(to: string, style: style)
        return string
    }

    public func styled(with parts: AttributedStringStylePart...) -> Composable {
        return styled(with: AttributedStringStyle.from(parts: parts))
    }

}

public extension NSAttributedString {

    static func compose(with textables: [Composable], style: AttributedStringStyle = AttributedStringStyle(), separator: Composable? = nil) -> NSAttributedString {
        let string = NSMutableAttributedString()
        string.beginEditing()
        for (index, textable) in textables.enumerated() {
            textable.append(to: string, style: style)
            if let separator = separator {
                if index != textables.indices.last {
                    separator.append(to: string, style: style)
                }
            }
        }
        string.endEditing()
        return string
    }
    
}

extension String: Composable {

    public func append(to attributedString: NSMutableAttributedString, style: AttributedStringStyle) {
        attributedString.append(style.attributedString(from: self))
    }

}

extension BONImage: Composable {

    public func append(to attributedString: NSMutableAttributedString, style: AttributedStringStyle) {
        var attributes = attributedString.extendingAttributes(with: style, effectiveRange: nil)
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

extension Special: Composable {

    public func append(to attributedString: NSMutableAttributedString, style: AttributedStringStyle) {
        attributedString.append(NSAttributedString(string: description, attributes: style.attributes()))
    }

}

extension NSAttributedString: Composable {

    public func append(to attributedString: NSMutableAttributedString, style: AttributedStringStyle) {
        attributedString.extend(with: self, style: style)
    }

}

enum TabHelpers: Composable {
    case spacer(CGFloat)
    case headIndent(CGFloat)

    var padding: CGFloat {
        switch self {
        case let .spacer(padding): return padding
        case let .headIndent(padding): return padding
        }
    }

    func append(to attributedString: NSMutableAttributedString, style: AttributedStringStyle) {
        // Get the paragraph
        var effectiveRange = NSRange(location: 0, length: 0)
        var attributes = attributedString.extendingAttributes(with: style, effectiveRange: &effectiveRange)
        let paragraph = StyleAttributeHelpers.paragraph(from: attributes)
        attributes[NSParagraphStyleAttributeName] = paragraph

        // Calculate the tab stop
        let max = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        let contentWidth = attributedString.boundingRect(with: max, options: .usesLineFragmentOrigin, context: nil).width
        let tabStop = contentWidth + padding

        if paragraph.tabStops == NSParagraphStyle.bon_default.tabStops {
            paragraph.tabStops = []
        }
        if case .headIndent = self {
            paragraph.headIndent = tabStop
        }

        paragraph.addTabStop(NSTextTab(textAlignment: .natural, location: tabStop, options: [:]))

        // Append the string and update the effective range
        attributedString.append(NSAttributedString(string: "\t"))
        effectiveRange.length += 1
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: effectiveRange)
    }
}

struct AttributedStringIgnoringStyle: Composable {
    let string: NSAttributedString

    func append(to attributedString: NSMutableAttributedString, style: AttributedStringStyle) {
        attributedString.append(string)
    }
}

public struct Text {

    public static func spacer(ofWidth width: CGFloat) -> Composable {
        return TabHelpers.spacer(width)
    }

    public static func shiftHeadIndent(after width: CGFloat) -> Composable {
        return TabHelpers.headIndent(width)
    }

    /**
     * Return a Composable that will add only the attributed string, and will ignore the containing style
     */
    public static func only(attributedString string: NSAttributedString) -> Composable {
        return AttributedStringIgnoringStyle(string: string)
    }
}
