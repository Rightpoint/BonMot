//
//  StyleAttributeProvider.swift
//
//  Created by Brian King on 8/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

public let StyleAttributeProviderAttributeName = "StyleAttributeProvider"

#if swift(>=3.0)
    public typealias StyleAttributeValue = Any
#else
    public typealias StyleAttributeValue = AnyObject
#endif

public typealias StyleAttributes = [String: StyleAttributeValue]

/// StyleAttributeProvider declares a transformation of attributes. The trait collection is passed along so values can
/// be customized depending on the trait collection. This is the primary contract provided by BonMot that allows
/// the transformation of attributes along with a traitCollection
public protocol StyleAttributeProvider {

    func style(attributes theAttributes: StyleAttributes, traitCollection: UITraitCollection?) -> StyleAttributes

}

/// An extension to provide UIKit interaction helpers to the style object
public extension StyleAttributeProvider {

    /// Return the StyleAttributes to apply to the attributed string. This method will also embed the style object in
    /// the attributed string so the string can be adapted as the trait collection changes.
    public func styleAttributes(attributes theAttributes: StyleAttributes = [:], traitCollection: UITraitCollection? = nil) -> StyleAttributes {
        var attributes = style(attributes: theAttributes, traitCollection: traitCollection)
        attributes[StyleAttributeProviderAttributeName] = StyleAttributeProviderHolder(style: self)
        return attributes
    }

    public func append(string theString: String, attributes: StyleAttributes = [:], traitCollection: UITraitCollection? = nil) -> NSMutableAttributedString {
        let attributes = styleAttributes(attributes: attributes, traitCollection: traitCollection)
        return NSMutableAttributedString(string: theString, attributes: attributes)
    }

    public func append(image theImage: UIImage, attributes: StyleAttributes = [:], traitCollection: UITraitCollection? = nil) -> NSMutableAttributedString {
        let attributes = styleAttributes(attributes: attributes, traitCollection: traitCollection)
        return NSMutableAttributedString(image: theImage, attributes: attributes)
    }

    func font(attributes theAttributes: StyleAttributes = [:], traitCollection theTraitCollection: UITraitCollection? = nil) -> UIFont {
        let attributes = styleAttributes(attributes: theAttributes, traitCollection: theTraitCollection)
        guard let font = attributes[NSFontAttributeName] as? UIFont else {
            fatalError("Requesting font from a style that has no font.")
        }
        return font
    }

}
