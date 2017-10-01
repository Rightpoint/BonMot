//
//  Compatibility.swift
//  BonMot
//
//  Created by Brian King on 8/24/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// This file declares extensions to system types to provide a compatible API
/// between Swift iOS, macOS, watchOS, and tvOS.

#if os(OSX)
#else
    public extension NSParagraphStyle {

        typealias LineBreakMode = NSLineBreakMode

    }

    #if os(iOS) || os(tvOS)
        public extension NSLayoutConstraint {

            typealias Attribute = NSLayoutAttribute
            typealias Relation = NSLayoutRelation
        }
    #endif
#endif
