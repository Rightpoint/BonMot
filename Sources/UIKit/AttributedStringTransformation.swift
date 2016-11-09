//
//  AttributedStringTransformation.swift
//  BonMot
//
//  Created by Brian King on 9/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

/// Defines a transformation to be performed on an `NSMutableAttributedString`.
/// It is used for adative transformations that need to know about the content
/// of the string in order to be performed. These are applied after the
/// `AdaptiveStyleTransformation`s are applied.
internal protocol AttributedStringTransformation {

    /// Recalculate any values in the string over the specified range.
    ///
    /// - parameter string: The attributed string to be updated.
    /// - parameter in: The range to operate over.
    func update(string theString: NSMutableAttributedString, in range: NSRange)

}
