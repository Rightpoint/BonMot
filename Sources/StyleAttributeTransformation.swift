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

}
