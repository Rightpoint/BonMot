//
//  Compatibility.swift
//  BonMot
//
//  Created by Brian King on 8/24/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

//swiftlint:disable file_length
#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

//TODO: update this paragraph before release
/// This file declares extensions to UIKit, Foundation, and Standard library
/// types to provide a compatible API between Swift 2.x and 3.0. All methods
/// should be non-public and static or final to ensure they do not add selectors
/// or methods to the external namespace. The bon_ prefix is used when Swift 2.x
/// cannot support the token, e.g. ".default".

#if swift(>=4.0)
#else
    public struct NSAttributedStringKey: RawRepresentable, Equatable, Hashable {
        
    }
#endif

extension NSParagraphStyle {

    @nonobjc static var bon_default: NSParagraphStyle {
        #if os(OSX)
            return NSParagraphStyle.default()
        #else
            return NSParagraphStyle.default
        #endif
    }

}

//swiftlint:enable file_length
