//
//  MutableCopying.swift
//  BonMot
//
//  Created by Zev Eisenberg on 9/28/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

extension NSAttributedString {

    @nonobjc func mutableStringCopy() -> NSMutableAttributedString {
        guard let copy = mutableCopy() as? NSMutableAttributedString else {
            fatalError("Failed to mutableCopy() \(self)")
        }
        return copy
    }

    @nonobjc func immutableCopy() -> NSAttributedString {
        guard let copy = copy() as? NSAttributedString else {
            fatalError("Failed to copy() \(self)")
        }
        return copy
    }
}

extension NSParagraphStyle {

    @nonobjc func mutableParagraphStyleCopy() -> NSMutableParagraphStyle {
        guard let copy = mutableCopy() as? NSMutableParagraphStyle else {
            fatalError("Failed to mutableCopy() \(self)")
        }
        return copy
    }

}
