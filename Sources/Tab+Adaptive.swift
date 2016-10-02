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

extension Tab: AttributedStringTransformation {
    // Just declare conformance. Implementation is already defined and used even if adaptive code is not included in the target.
}

extension Tab: EmbededTransformation {

    struct Value {
        static let spacer = "spacer"
        static let headIndent = "headIndent"
    }

    static func from(representation dictionary: StyleAttributes) -> EmbededTransformation? {
        switch (dictionary[EmbededTransformationHelpers.Key.type] as? String,
                dictionary[EmbededTransformationHelpers.Key.size] as? CGFloat) {
        case (Value.spacer?, let width?):
            return Tab.spacer(width)
        case (Value.headIndent?, let width?):
            return Tab.headIndent(width)
        default:
            return nil
        }
    }

    var representation: StyleAttributes {
        switch self {
        case let .spacer(size):
            return [EmbededTransformationHelpers.Key.type: Value.spacer,
                    EmbededTransformationHelpers.Key.size: size]

        case let .headIndent(size):
            return [EmbededTransformationHelpers.Key.type: Value.headIndent,
                    EmbededTransformationHelpers.Key.size: size]
        }
    }

}
