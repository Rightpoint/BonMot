//
//  NSAttributedString+Adapt.swift
//  BonMot
//
//  Created by Brian King on 9/20/16.
//
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

extension NSAttributedString {

    /// Adapt a set of attributes to the specified trait collection. This will
    /// use the style object defined in the attributes or use the default style
    /// object specified.
    ///
    /// - Parameters:
    ///   - theAttributes: The attributes to transform.
    ///   - traitCollection: The trait collection to which to adapt the attributes.
    /// - Returns: Attributes with fonts updated to the specified content size category.
    public static func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes {
        let adaptations: [AdaptiveStyleTransformation] = EmbeddedTransformationHelpers.transformations(from: theAttributes)
        var styleAttributes = theAttributes
        for adaptiveStyle in adaptations {
            styleAttributes = adaptiveStyle.adapt(attributes: styleAttributes, to: traitCollection) ?? styleAttributes
        }
        return styleAttributes
    }

    /// Create a new `NSAttributedString` adapted to the new trait collection.
    /// Re-applies the embedded style objects.
    ///
    /// - Parameter traitCollection: The trait collection to adapt to.
    /// - Returns: A new `NSAttributedString` with the style updated to the new
    ///            trait collection.
    public final func adapted(to traitCollection: UITraitCollection) -> NSAttributedString {
        let newString = mutableStringCopy()
        newString.beginEditing()
        enumerateAttributes(in: NSRange(location: 0, length: length), options: []) { (attributes, range, _) in
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

    /// Adapt the receiver's attributes to the provided trait collection.
    ///
    /// - Parameter traitCollection: The trait collection to adapt to.
    /// - Returns: The adapted attributes.
    public func attributes(adaptedTo traitCollection: UITraitCollection) -> StyleAttributes {
        return NSAttributedString.adapt(attributes: attributes, to: traitCollection)
    }

}

// MARK: - Deprecations
extension NSAttributedString {

    // Deprecated - search the code and remove other deprecations when you remove this
    @available(*, deprecated, renamed: "adapted(to:)")
    public final func adapt(to traitCollection: UITraitCollection) -> NSAttributedString {
        return adapted(to: traitCollection)
    }

}
#endif
