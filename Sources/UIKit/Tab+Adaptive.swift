//
//  Tab+Adaptive.swift
//  BonMot
//
//  Created by Brian King on 10/2/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

// Just declare conformance. Implementation is already defined and used even
// if adaptive code is not included in the target.
extension Tab: AttributedStringTransformation { }

extension Tab: EmbeddedTransformation {

    struct Value {

        static let spacer = "spacer"
        static let headIndent = "headIndent"

    }

    static func from(dictionary dict: StyleAttributes) -> EmbeddedTransformation? {
        switch (dict[EmbeddedTransformationHelpers.Key.type] as? String,
                dict[EmbeddedTransformationHelpers.Key.size] as? CGFloat) {
        case (Value.spacer?, let width?):
            return Tab.spacer(width)
        case (Value.headIndent?, let width?):
            return Tab.headIndent(width)
        default:
            return nil
        }
    }

    var asDictionary: StyleAttributes {
        switch self {
        case let .spacer(size):
            return [
                EmbeddedTransformationHelpers.Key.type: Value.spacer,
                EmbeddedTransformationHelpers.Key.size: size,
            ]

        case let .headIndent(size):
            return [
                EmbeddedTransformationHelpers.Key.type: Value.headIndent,
                EmbeddedTransformationHelpers.Key.size: size,
            ]
        }
    }

}
