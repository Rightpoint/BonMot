//
//  AdaptiveStyleTransformation.swift
//
//  Created by Brian King on 9/20/16.
//
//

import UIKit

/// This protocol defines a style transformation that is dependent on a UITraitCollection.
/// An adaptive transformation is Embedded in the StyleAttributes so that any NSAttributedString
/// can be updated to a new trait collection using `attributedString.adapt(to: traitCollection)`.
///
/// Since NSAttributedString includes NSCoding support, AdaptiveStyleTransformation is embedded
/// in the StyleAttributes via a simple dictionary encoding strategy. NSCoding was avoided so
/// value types can be used. See EmbeddedTransformation for more info.
internal protocol AdaptiveStyleTransformation {

    /// Change any of theAttributes as desired to the specified traitCollection and return a new StyleAttributes dictionary.
    ///
    /// - parameter theAttributes: The input attributes
    /// - parameter to: The trait collection to adapt to
    func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes?

}
