//
//  AdaptiveAttributeHelpers.swift
//  Pods
//
//  Created by Brian King on 9/20/16.
//
//

/// Internal helper functions for managing keys in the StyleAttributes related to adaptive functionality.
enum AdaptiveAttributeHelpers {
    enum AttributeName {
        static let designatedFont = "BonMotDesignatedFont"
        static let adaptions = "BonMotAdaptions"
    }

    static var adaptiveTransformationTypes: [AdaptiveStyleTransformation.Type] = [
        AdaptiveStyle.self,
        Tracking.self,
    ]

    static func add(designedFont font: UIFont, to styleAttributes: StyleAttributes) -> StyleAttributes {
        var styleAttributes = styleAttributes
        styleAttributes[AttributeName.designatedFont] = font
        return styleAttributes
    }

    static func add(adaptiveTransformation transformation: AdaptiveStyleTransformation, to styleAttributes: StyleAttributes) -> StyleAttributes {
        let representation = transformation.representation
        var styleAttributes = styleAttributes
        var adaptions = styleAttributes[AttributeName.adaptions] as? [StyleAttributes] ?? []

        // Only add the adaption once.
        if !adaptions.contains(where: { NSDictionary(dictionary: $0) == NSDictionary(dictionary: representation) }) {
            adaptions.append(representation)
        }
        styleAttributes[AttributeName.adaptions] = adaptions
        return styleAttributes
    }

    static func adaptions(from styleAttributes: StyleAttributes) -> [AdaptiveStyleTransformation]? {
        let representations = styleAttributes[AttributeName.adaptions] as? [StyleAttributes]
        let results: [AdaptiveStyleTransformation?]? = representations?.map { representation in
            for type in adaptiveTransformationTypes {
                if let transformation = type.from(representation: representation) {
                    return transformation
                }
            }
            return nil
        }
        return results?.flatMap({ $0 })
    }

    static func adapt(attributes theAttributes: StyleAttributes, to traitCollection: UITraitCollection) -> StyleAttributes? {
        guard let adaptations = AdaptiveAttributeHelpers.adaptions(from: theAttributes) else {
            return nil
        }
        var styleAttributes = theAttributes
        for adaptiveStyle in adaptations {
            styleAttributes = adaptiveStyle.adapt(attributes: styleAttributes, to: traitCollection) ?? styleAttributes
        }
        return styleAttributes
    }

    static func adapt(string attributedString: NSMutableAttributedString, to traitCollection: UITraitCollection) {
        let wholeRange = NSRange(location: 0, length: attributedString.length)

        attributedString.enumerateAttributes(in: wholeRange, options: []) { (attributes, range, stop) in
            if let adapted = adapt(attributes: attributes, to: traitCollection) {
                attributedString.setAttributes(adapted, range: range)
            }
        }
    }
}
