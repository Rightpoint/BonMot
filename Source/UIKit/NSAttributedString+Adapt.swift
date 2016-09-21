//
//  NSAttributedString+Adapt.swift
//
//  Created by Brian King on 9/20/16.
//
//

extension NSAttributedString {

    /// Adapt a set of attributes to the specified trait collection. This will use the style object defined in the attributes or use the default style object specified.
    ///
    /// - parameter attributes: The attributes to transform
    /// - parameter to: The trait collection to transform the attributes too
    /// - parameter defaultStyle: The style to apply if there is no style specified in the attributes
    /// - returns: Attributes with fonts updated to the specified content size category.
    public static func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes {

        let attributes = AdaptiveAttributeHelpers.adapt(attributes: theAttributes, to: traitCollection) ?? theAttributes
        return attributes
    }

    /// Create a new NSAttributedString adapted to the new trait collection. This will re-apply the embedded style
    /// objects or apply the defaultStyle object if no styles are present.
    ///
    /// - parameter to: The trait collection containing the attribute string to be transformed.
    /// - parameter defaultStyle: The style to apply if there is no style specified in the attributes
    ///
    /// - returns: A new NSAttributedString with the style updated to the new trait collection.
    public final func adapt(to traitCollection: UITraitCollection) -> NSMutableAttributedString {
        guard let newString = mutableCopy() as? NSMutableAttributedString else {
            fatalError("Force cast of mutable copy failed.")
        }
        AdaptiveAttributeHelpers.adapt(string: newString, to: traitCollection)
        return newString
    }

}
