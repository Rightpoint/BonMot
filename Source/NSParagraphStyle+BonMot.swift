//
//  NSParagraphStyle+BonMot.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

extension NSMutableParagraphStyle {

    /// A function to coerce an NSMutableParagraphStyle from a value in an attributes dictionary. This will
    /// return a mutable copy of a NSParagraphStyle, or a new NSMutableParagraphStyle if the value is nil.
    /// This will fatal if a non NSMutableParagraphStyle? type is passed in.
    static func from(object theObject: StyleAttributeValue?) -> NSMutableParagraphStyle {
        let result: NSMutableParagraphStyle
        if let paragraphStyle = theObject as? NSMutableParagraphStyle {
            result = paragraphStyle
        }
        else if let paragraphStyle = theObject as? NSParagraphStyle {
            result = paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
        }
        else {
            result = NSMutableParagraphStyle()
        }
        return result
    }
}

