//
//  Platform.swift
//
//  Created by Brian King on 9/22/16.
//
//

#if os(OSX)
    import AppKit
    public typealias BONColor = NSColor
    public typealias BONImage = NSImage

    public typealias BONFont = NSFont
    public typealias BONFontDescriptor = NSFontDescriptor
    let BONFontDescriptorFeatureSettingsAttribute = NSFontFeatureSettingsAttribute
    let BONFontFeatureTypeIdentifierKey = NSFontFeatureTypeIdentifierKey
    let BONFontFeatureSelectorIdentifierKey = NSFontFeatureSelectorIdentifierKey

    // All BonMotTextStyle references should be #if'd.
    public typealias BonMotTextStyle = String
#else
    import UIKit
    public typealias BONColor = UIColor
    public typealias BONImage = UIImage

    public typealias BONFont = UIFont
    public typealias BONFontDescriptor = UIFontDescriptor
    let BONFontDescriptorFeatureSettingsAttribute = UIFontDescriptorFeatureSettingsAttribute
    let BONFontFeatureTypeIdentifierKey = UIFontFeatureTypeIdentifierKey
    let BONFontFeatureSelectorIdentifierKey = UIFontFeatureSelectorIdentifierKey
#if swift(>=3.0)
    public typealias BonMotTextStyle = UIFontTextStyle
    public typealias BonMotContentSizeCategory = UIContentSizeCategory
#else
    public typealias BonMotTextStyle = String
    public typealias BonMotContentSizeCategory = String
#endif

#endif

#if swift(>=3.0)
    public func BonMot(_ parts: AttributedStringStylePart...) -> AttributedStringStyle {
        return AttributedStringStyle.from(parts: parts)
    }

    public func BonMotC(_ configure: (inout AttributedStringStyle) -> Void) -> AttributedStringStyle {
        var style = AttributedStringStyle()
        configure(&style)
        return style
    }
#else
    public func BonMot(parts: AttributedStringStylePart...) -> AttributedStringStyle {
        return AttributedStringStyle.from(parts)
    }

    public func BonMotC(configure: (inout AttributedStringStyle) -> Void) -> AttributedStringStyle {
        var style = AttributedStringStyle()
        configure(&style)
        return style
    }
#endif

public typealias BonMotI = AttributedStringStyle
