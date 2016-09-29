//
//  MutableCopying.swift
//  BonMot
//
//  Created by Zev Eisenberg on 9/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif


internal extension NSAttributedString {

    @nonobjc func mutableStringCopy() -> NSMutableAttributedString {
        guard let copy = mutableCopy() as? NSMutableAttributedString else {
            fatalError("Failed to mutableCopy() \(self)")
        }
        return copy
    }
}

internal extension NSParagraphStyle {
    @nonobjc func mutableParagraphStyleCopy() -> NSMutableParagraphStyle {
        guard let copy = mutableCopy() as? NSMutableParagraphStyle else {
            fatalError("Failed to mutableCopy() \(self)")
        }
        return copy
    }
}
