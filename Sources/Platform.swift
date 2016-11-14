//
//  Platform.swift
//  BonMot
//
//  Created by Brian King on 9/22/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
    public typealias BONColor = NSColor
    public typealias BONImage = NSImage
    public typealias BONTextField = NSTextField

    public typealias BONFont = NSFont
    public typealias BONFontDescriptor = NSFontDescriptor
    let BONFontDescriptorFeatureSettingsAttribute = NSFontFeatureSettingsAttribute
    let BONFontFeatureTypeIdentifierKey = NSFontFeatureTypeIdentifierKey
    let BONFontFeatureSelectorIdentifierKey = NSFontFeatureSelectorIdentifierKey
#else
    import UIKit
    public typealias BONColor = UIColor
    public typealias BONImage = UIImage

    public typealias BONFont = UIFont
    public typealias BONFontDescriptor = UIFontDescriptor
    let BONFontDescriptorFeatureSettingsAttribute = UIFontDescriptorFeatureSettingsAttribute
    let BONFontFeatureTypeIdentifierKey = UIFontFeatureTypeIdentifierKey
    let BONFontFeatureSelectorIdentifierKey = UIFontFeatureSelectorIdentifierKey

    #if os(iOS) || os(tvOS)
        public typealias BONTextField = UITextField
    #endif
#endif

#if swift(>=3.0)
    public typealias StyleAttributeValue = Any
#else
    public typealias StyleAttributeValue = AnyObject
#endif

public typealias StyleAttributes = [String: StyleAttributeValue]

#if os(iOS) || os(tvOS)
    #if swift(>=3.0)
        public typealias BonMotTextStyle = UIFontTextStyle
        public typealias BonMotContentSizeCategory = UIContentSizeCategory
    #else
        public typealias BonMotTextStyle = String
        public typealias BonMotContentSizeCategory = String
    #endif
#endif

// This key is defined here because it needs to be used in non-adaptive code.
public let BonMotTransformationsAttributeName = "BonMotTransformations"
