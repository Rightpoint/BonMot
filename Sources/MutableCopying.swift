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

private protocol BONMutableCopying {

    func bonMutableCopy<T>() -> T

}

private extension BONMutableCopying where Self: NSMutableCopying {

    func bonMutableCopy<T>() -> T {
        let errorMessage = "Failed to turn object of type \(Self.self) into object of type \(T.self)"
        #if swift(>=3.0)
            guard let copy = mutableCopy() as? T else {
            fatalError(errorMessage)
            }
        #else
            guard let copy = mutableCopyWithZone(nil) as? T else {
                fatalError(errorMessage)
            }
        #endif

        return copy
    }

}

extension NSAttributedString: BONMutableCopying { }
extension NSParagraphStyle: BONMutableCopying { }

public extension NSAttributedString {
    public var bonMutableCopy: NSMutableAttributedString {
        return bonMutableCopy() as NSMutableAttributedString
    }
}

public extension NSParagraphStyle {
    public var bonMutableCopy: NSMutableParagraphStyle {
        return bonMutableCopy() as NSMutableParagraphStyle
    }
}
