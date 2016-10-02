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

extension Tracking: EmbededTransformation {

    struct Value {
        static let adobeTracking = "adobe-tracking"
    }

    static func from(representation dictionary: StyleAttributes) -> EmbededTransformation? {
        if case let (Value.adobeTracking?, size?) = (dictionary[EmbededTransformationHelpers.Key.type] as? String, dictionary[EmbededTransformationHelpers.Key.size] as? CGFloat) {
            return Tracking.adobe(size)
        }
        return nil
    }

    var representation: StyleAttributes {
        if case let .adobe(size) = self {
            return [EmbededTransformationHelpers.Key.type: Value.adobeTracking,
                    EmbededTransformationHelpers.Key.size: size]
        }
        else {
            // We don't need to persist regular tracking as it does not depend on the font size.
            return [:]
        }
    }

}
