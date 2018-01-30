//
//  Compatibility+Tests.swift
//  BonMot
//
//  Created by Brian King on 9/13/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import BonMot

#if os(OSX)
    import AppKit
    let BONFontDescriptorFeatureSettingsAttribute = NSFontDescriptor.AttributeName.featureSettings
    let BONFontFeatureTypeIdentifierKey = NSFontDescriptor.FeatureKey.typeIdentifier
    let BONFontFeatureSelectorIdentifierKey = NSFontDescriptor.FeatureKey.selectorIdentifier
    typealias BONView = NSView
#else
    import UIKit
    let BONFontDescriptorFeatureSettingsAttribute = UIFontDescriptor.AttributeName.featureSettings
    let BONFontFeatureTypeIdentifierKey = UIFontDescriptor.FeatureKey.featureIdentifier
    let BONFontFeatureSelectorIdentifierKey = UIFontDescriptor.FeatureKey.typeIdentifier
    typealias BONView = UIView
#endif

extension NSAttributedStringKey: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value)
    }

}

extension BONFontDescriptor.AttributeName: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value)
    }

}

#if os(OSX)
    extension NSImage.Name: ExpressibleByStringLiteral {

        public init(stringLiteral value: String) {
            self.init(value)
        }

    }

    extension Bundle {

        func image(forResource resource: String) -> NSImage? {
            return image(forResource: NSImage.Name(resource))
        }

    }

#endif
