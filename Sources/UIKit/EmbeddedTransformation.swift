//
//  EmbeddedTransformation.swift
//  BonMot
//
//  Created by Brian King on 9/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// BonMot embeds transformation objects inside NSAttributedString attributes to do adaptive styling.
/// To simplify NSAttributedString NSCoding support, these transformations get embedded using plist compatible objects
/// This protocol defines a contract to simplify this. NSCoding is not used so value types can be used.
internal protocol EmbeddedTransformation {

    /// Return a plist compatible dictionary of any state that's needed to persist the adaption
    var representation: StyleAttributes { get }

    /// This factory method is used to take the adaptations dictionary and create an array of AdaptiveStyleTransformation.
    /// To register a new adaptive transformation, add the type to AdaptiveAttributeHelpers.adaptiveTransformationTypes.
    static func from(representation dictionary: StyleAttributes) -> EmbeddedTransformation?

}

// Internal helper functions for managing keys in the StyleAttributes related to adaptive functionality.
internal enum EmbeddedTransformationHelpers {
    struct Key {
        static let type = "type"
        static let size = "size"
    }

    static var EmbeddedTransformationTypes: [EmbeddedTransformation.Type] = [AdaptiveStyle.self, Tracking.self, Tab.self]

    static func embed(transformation theTransformation: EmbeddedTransformation, to styleAttributes: StyleAttributes) -> StyleAttributes {
        let representation = theTransformation.representation
        var styleAttributes = styleAttributes
        var adaptions = styleAttributes[BonMotTransformationsAttributeName] as? [StyleAttributes] ?? []

        // Only add the transformation once.
        let contains = adaptions.contains() { NSDictionary(dictionary: $0) == NSDictionary(dictionary: representation) }
        if !contains {
            adaptions.append(representation)
        }
        styleAttributes[BonMotTransformationsAttributeName] = adaptions
        return styleAttributes
    }

    static func transformations<T>(from styleAttributes: StyleAttributes) -> [T] {
        let representations = styleAttributes[BonMotTransformationsAttributeName] as? [StyleAttributes] ?? []
        let results: [T?] = representations.map { representation in
            for type in EmbeddedTransformationTypes {
                if let transformation = type.from(representation: representation) as? T {
                    return transformation
                }
            }
            return nil
        }
        return results.flatMap({ $0 })
    }

}
