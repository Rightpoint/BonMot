//
//  Tracking+Adaptive.swift
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

extension Tracking: AdaptiveStyleTransformation {

    func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes? {
        if case .adobe = self {
            var attributes = theAttributes
            let styledFont = theAttributes[.font] as? UIFont
            attributes.update(possibleValue: kerning(forFont: styledFont), forKey: .kern)
            return attributes
        }
        else {
            return nil
        }
    }

}

extension Tracking: EmbeddedTransformation {

    struct Value {
        static let adobeTracking = "adobe-tracking"
    }

    static func from(dictionary dict: StyleAttributes) -> EmbeddedTransformation? {
        if case let (Value.adobeTracking?, size?) = (dict[EmbeddedTransformationHelpers.Key.type] as? String, dict[EmbeddedTransformationHelpers.Key.size] as? CGFloat) {
            return Tracking.adobe(size)
        }
        return nil
    }

    var asDictionary: StyleAttributes {
        if case let .adobe(size) = self {
            return [
                EmbeddedTransformationHelpers.Key.type: Value.adobeTracking,
                EmbeddedTransformationHelpers.Key.size: size,
            ]
        }
        else {
            // We don't need to persist point tracking, as it does not depend on
            // the font size.
            return [:]
        }
    }

}
