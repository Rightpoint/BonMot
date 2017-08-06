//
//  Compatibility+Tests.swift
//  BonMot
//
//  Created by Brian King on 9/13/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

//swiftlint:disable file_length
#if os(OSX)
    import AppKit
    let BONFontDescriptorFeatureSettingsAttribute = NSFontFeatureSettingsAttribute
    let BONFontFeatureTypeIdentifierKey = NSFontFeatureTypeIdentifierKey
    let BONFontFeatureSelectorIdentifierKey = NSFontFeatureSelectorIdentifierKey
    typealias BONView = NSView
#else
    import UIKit
    let BONFontDescriptorFeatureSettingsAttribute = UIFontDescriptorFeatureSettingsAttribute
    let BONFontFeatureTypeIdentifierKey = UIFontFeatureTypeIdentifierKey
    let BONFontFeatureSelectorIdentifierKey = UIFontFeatureSelectorIdentifierKey
    typealias BONView = UIView
#endif
import BonMot

// MARK: - Shared (AppKit + UIKit)

extension NSParagraphStyle {

    /// Returns the default paragraph style.
    /// - note: This variable has to be prefixed since `default` is not a
    ///         valid variable name in Swift 2.3
    @nonobjc static var bon_default: NSParagraphStyle {
        #if os(OSX)
            return NSParagraphStyle.default()
        #else
            return NSParagraphStyle.default
        #endif
    }

}

//swiftlint:enable file_length
