//
//  AdaptiveStyleTransformation.swift
//  BonMot
//
//  Created by Brian King on 9/20/16.
//
//

import UIKit

/// Defines a style transformation that is dependent on a `UITraitCollection`.
/// An adaptive transformation is embedded in the `StyleAttributes` so that any
/// `NSAttributedString` can be updated to a new trait collection using
/// `attributedString.adapted(to: traitCollection)`.
///
/// Since `NSAttributedString` conforms to `NSCoding`, `AdaptiveStyleTransformation`
/// is embedded in the `StyleAttributes` via simple dictionary encoding.
/// `NSCoding` was avoided so that value types can conform. See 
/// `EmbeddedTransformation` for more information.
internal protocol AdaptiveStyleTransformation {

    /// Change any of `theAttributes`, as desired, to the specified
    /// `traitCollection` and return a new `StyleAttributes` dictionary.
    ///
    /// - Parameters:
    ///   - theAttributes: The input attributes.
    ///   - traitCollection: The trait collection to adapt to.
    /// - Returns: The adapted attributes, if any.
    func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes?

}
