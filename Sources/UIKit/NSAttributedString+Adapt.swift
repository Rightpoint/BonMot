//
//  NSAttributedString+Adapt.swift
//
//  Created by Brian King on 9/20/16.
//
//

import UIKit

extension NSAttributedString {

    /// Adapt a set of attributes to the specified trait collection. This will use the style object defined in the attributes or use the default style object specified.
    ///
    /// - parameter attributes: The attributes to transform
    /// - parameter to: The trait collection to transform the attributes too
    /// - returns: Attributes with fonts updated to the specified content size category.
    public static func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes {
        let adaptations: [AdaptiveStyleTransformation] = EmbeddedTransformationHelpers.transformations(from: theAttributes)
        var styleAttributes = theAttributes
        for adaptiveStyle in adaptations {
            styleAttributes = adaptiveStyle.adapt(attributes: styleAttributes, to: traitCollection) ?? styleAttributes
        }
        return styleAttributes
    }

    /// Create a new `NSAttributedString` adapted to the new trait collection. This will re-apply the embedded style
    /// objects
    ///
    /// - parameter to: The trait collection to adapt to
    /// - returns: A new `NSAttributedString` with the style updated to the new trait collection.
    public final func adapt(to traitCollection: UITraitCollection) -> NSAttributedString {
        let newString = mutableStringCopy()
        newString.beginEditing()
        enumerateAttributes(in: NSRange(location: 0, length: length), options: []) { (attributes, range, stop) in
            var styleAttributes = attributes

            // Adapt any AdaptiveStyleTransformation embedded in the attributes.
            let adaptiveStyles: [AdaptiveStyleTransformation] = EmbeddedTransformationHelpers.transformations(from: attributes)
            for adaptiveStyle in adaptiveStyles {
                styleAttributes = adaptiveStyle.adapt(attributes: styleAttributes, to: traitCollection) ?? styleAttributes
            }
            // Apply any AttributedStringTransformation embedded in the attributes.
            let transformations: [AttributedStringTransformation] = EmbeddedTransformationHelpers.transformations(from: attributes)
            for transformation in transformations {
                transformation.update(string: newString, in: range)
            }
            newString.setAttributes(NSAttributedString.adapt(attributes: attributes, to: traitCollection), range: range)
        }
        newString.endEditing()
        return newString
    }

}

extension StringStyle {

    public func attributes(adaptedTo traitCollection: UITraitCollection) -> StyleAttributes {
        return NSAttributedString.adapt(attributes: attributes, to: traitCollection)
    }
}
