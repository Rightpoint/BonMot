//
//  FontFeatures.swift
//
//  Created by Brian King on 8/31/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

// This is not supported by watchOS
#if os(iOS) || os(tvOS) || os(OSX)

/// Protocol to provide values to be used by `UIFontFeatureTypeIdentifierKey` and `UIFontFeatureSelectorIdentifierKey`.
/// You can typically find these values in CoreText.SFNTLayoutTypes
public protocol FontFeatureProvider {
    func featureSettings() -> (type: Int, selector: Int)
}

public extension BONFont {
    /// Create a new font and attempt to enable the specified font features. The returned font will have all
    /// features enabled that are supported by the font.
    /// - parameter withFeatures: the features to attempt to enable on the font
    /// - returns: a new font with the specified features enabled
    public func font(withFeatures featureProviders: [FontFeatureProvider]) -> BONFont {
        var fontAttributes = fontDescriptor.fontAttributes
        var features = fontAttributes[BONFontDescriptorFeatureSettingsAttribute] as? [StyleAttributes] ?? []
        if featureProviders.count > 0 {
            let newFeatures = featureProviders.map() { $0.featureAttribute() }
            features.append(contentsOf: newFeatures)
            fontAttributes[BONFontDescriptorFeatureSettingsAttribute] = features
        }
        let descriptor = BONFontDescriptor(fontAttributes: fontAttributes)
        #if os(OSX)
            return BONFont(descriptor: descriptor, size: pointSize)!
        #else
            return BONFont(descriptor: descriptor, size: pointSize)
        #endif
    }
}

/// An enumeration representing the kNumberCaseType features.
public enum NumberCase: FontFeatureProvider {
    case upper, lower
    public func featureSettings() -> (type: Int, selector: Int) {
        switch self {
        case .upper:
            return (type: kNumberCaseType, selector: kUpperCaseNumbersSelector)
        case .lower:
            return (type: kNumberCaseType, selector: kLowerCaseNumbersSelector)
        }
    }
}

/// An enumeration representing the kNumberSpacingType features.
public enum NumberSpacing: FontFeatureProvider {
    case monospaced, proportional
    public func featureSettings() -> (type: Int, selector: Int) {
        switch self {
        case .monospaced:
            return (type: kNumberSpacingType, selector: kMonospacedNumbersSelector)
        case .proportional:
            return (type: kNumberSpacingType, selector: kProportionalNumbersSelector)
        }
    }
}

extension FontFeatureProvider {

    /// - returns: a dictionary representing one feature for the attributes key in the font attributes
    func featureAttribute() -> StyleAttributes {
        let featureSettings = self.featureSettings()
        return [
            BONFontFeatureTypeIdentifierKey: featureSettings.type,
            BONFontFeatureSelectorIdentifierKey: featureSettings.selector
        ]
    }
}

#endif
