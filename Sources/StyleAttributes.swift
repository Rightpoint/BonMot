//
//  StyleAttributes.swift
//
//  Created by Brian King on 9/20/16.
//
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

#if swift(>=3.0)
    public typealias StyleAttributeValue = Any
#else
    public typealias StyleAttributeValue = AnyObject
#endif

public typealias StyleAttributes = [String: StyleAttributeValue]

// An internal namespace of helper functions for managing the contents of StyleAttributes
internal enum StyleAttributeHelpers {

    /// A function to coerce an NSMutableParagraphStyle from a value in an attributes dictionary. This will
    /// return a mutable copy of a NSParagraphStyle, or a new NSMutableParagraphStyle if the value is nil.
    static func paragraph(from styleAttributes: StyleAttributes) -> NSMutableParagraphStyle {
        let theObject = styleAttributes[NSParagraphStyleAttributeName]
        let result: NSMutableParagraphStyle
        if let paragraphStyle = theObject as? NSMutableParagraphStyle {
            result = paragraphStyle
        }
        else if let paragraphStyle = theObject as? NSParagraphStyle {
            result = paragraphStyle.mutableParagraphStyleCopy()
        }
        else {
            result = NSMutableParagraphStyle()
        }
        return result
    }

    static func font(from styleAttributes: StyleAttributes) -> BONFont {
        guard let font = styleAttributes[NSFontAttributeName] as? BONFont else {
            fatalError("Requesting font from a style that has no font.")
        }
        return font
    }

}
