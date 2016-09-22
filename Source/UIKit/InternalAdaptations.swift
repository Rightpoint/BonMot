//
//  InternalAdaptations.swift
//
//  Created by Brian King on 9/20/16.
//
//

import Foundation

extension Tracking: AdaptiveStyleTransformation {

    enum Key {
        static let type = "type"
        static let size = "size"

        enum Value {
            static let adobeTracking = "adobe-tracking"
        }
    }

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
        if case let (Key.Value.adobeTracking?, size?) = (dictionary[Key.type] as? String, dictionary[Key.size] as? CGFloat) {
            return Tracking.adobe(size)
        }
        return nil
    }

    var representation: StyleAttributes {
        if case let .adobe(size) = self {
            return [Key.type: Key.Value.adobeTracking, Key.size: size]
        }
        else {
            // We don't need to persist regular tracking as it does not depend on the font size.
            return [:]
        }
    }

}
