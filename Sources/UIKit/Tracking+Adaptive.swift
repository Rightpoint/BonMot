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
            let styledFont = theAttributes[NSFontAttributeName] as? UIFont
            attributes.update(possibleValue: kerning(forFont: styledFont), forKey: NSKernAttributeName)
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

    static func from(representation dictionary: StyleAttributes) -> EmbeddedTransformation? {
        if case let (Value.adobeTracking?, size?) = (dictionary[EmbeddedTransformationHelpers.Key.type] as? String, dictionary[EmbeddedTransformationHelpers.Key.size] as? CGFloat) {
            return Tracking.adobe(size)
        }
        return nil
    }

    var representation: StyleAttributes {
        if case let .adobe(size) = self {
            return [EmbeddedTransformationHelpers.Key.type: Value.adobeTracking,
                    EmbeddedTransformationHelpers.Key.size: size]
        }
        else {
            // We don't need to persist regular tracking as it does not depend on the font size.
            return [:]
        }
    }

}
