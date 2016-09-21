//
//  InternalAdaptations.swift
//  Pods
//
//  Created by Brian King on 9/20/16.
//
//

import Foundation

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

    static func from(representation dictionary: StyleAttributes) -> AdaptiveStyleTransformation? {
        if case let ("adobe-tracking"?, size?) = (dictionary["type"] as? String, dictionary["size"] as? CGFloat) {
            return Tracking.adobe(size)
        }
        return nil
    }

    var representation: StyleAttributes {
        if case let .adobe(size) = self {
            return ["type": "adobe-tracking", "size": size]
        }
        else {
            // We don't need to persist regular tracking as it does not depend on the font size.
            return [:]
        }
    }

}
