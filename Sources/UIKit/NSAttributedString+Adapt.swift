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
    /// - parameter defaultStyle: The style to apply if there is no style specified in the attributes
    /// - returns: Attributes with fonts updated to the specified content size category.
    public static func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes {
        guard let adaptations: [AdaptiveStyleTransformation] = EmbededTransformationHelpers.transformations(from: theAttributes) else {
            return theAttributes
        }
        var styleAttributes = theAttributes
        for adaptiveStyle in adaptations {
            styleAttributes = adaptiveStyle.adapt(attributes: styleAttributes, to: traitCollection) ?? styleAttributes
        }
        return styleAttributes
    }

    /// Create a new NSAttributedString adapted to the new trait collection. This will re-apply the embedded style
    /// objects or apply the defaultStyle object if no styles are present.
    ///
    /// - parameter to: The trait collection containing the attribute string to be transformed.
    /// - parameter defaultStyle: The style to apply if there is no style specified in the attributes
    ///
    /// - returns: A new NSAttributedString with the style updated to the new trait collection.
    public final func adapt(to traitCollection: UITraitCollection) -> NSAttributedString {
        guard let newString = mutableCopy() as? NSMutableAttributedString else {
            fatalError("Force cast of mutable copy failed.")
        }
        let wholeRange = NSRange(location: 0, length: length)
        enumerateAttributes(in: wholeRange, options: []) { (attributes, range, stop) in
            newString.setAttributes(NSAttributedString.adapt(attributes: attributes, to: traitCollection), range: range)
        }
        newString.applyEmbeddedTransformations()
        return newString
    }

}

extension NSMutableAttributedString {
    @nonobjc final func applyEmbeddedTransformations() {
        let wholeRange = NSRange(location: 0, length: length)

        enumerateAttributes(in: wholeRange, options: []) { (attributes, range, stop) in
            guard let transformations: [AttributedStringTransformation] = EmbededTransformationHelpers.transformations(from: attributes) else {
                return
            }
            for transformation in transformations {
                transformation.update(string: self, in: range, with: attributes)
            }
        }
    }
}
