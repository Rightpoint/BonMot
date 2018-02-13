//
//  Emphasis.swift
//  BonMot
//
//  Created by Zev Eisenberg on 2/12/18.
//  Copyright © 2018 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public struct Emphasis: OptionSet {

    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let italic = Emphasis(rawValue: 1 << 0)
    public static let bold = Emphasis(rawValue: 1 << 1)
    public static let expanded = Emphasis(rawValue: 1 << 2)
    public static let condensed = Emphasis(rawValue: 1 << 3)
    public static let vertical = Emphasis(rawValue: 1 << 4)
    public static let uiOptimized = Emphasis(rawValue: 1 << 5)
    public static let tightLineSpacing = Emphasis(rawValue: 1 << 6) // AKA Tight Leading
    public static let looseLineSpacing = Emphasis(rawValue: 1 << 7) // AKA Loose Leading

}

extension Emphasis {

    var symbolicTraits: BONSymbolicTraits {
        var traits: BONSymbolicTraits = []
        if contains(.italic) {
            traits.insert(.italic)
        }
        if contains(.bold) {
            traits.insert(.bold)
        }
        if contains(.expanded) {
            traits.insert(.expanded)
        }
        if contains(.condensed) {
            traits.insert(.condensed)
        }
        if contains(.vertical) {
            traits.insert(.vertical)
        }
        if contains(.uiOptimized) {
            traits.insert(.uiOptimized)
        }
        if contains(.tightLineSpacing) {
            traits.insert(.tightLineSpacing)
        }
        if contains(.looseLineSpacing) {
            traits.insert(.looseLineSpacing)
        }

        return traits
    }

}
