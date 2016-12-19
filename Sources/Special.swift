//
//  Special.swift
//  BonMot
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

/// Interesting Unicode characters for use in creating strings. Most characters
/// in `Special` are either non-printing (like the various space characters) or
/// visually ambiguous when viewed with a monospace code font (like the dashes
/// and hyphens).
public enum Special: UnicodeScalar {

    // Keep the cases sorted by unichar value when adding new cases.
    case tab = "\u{0009}"
    case lineFeed = "\u{000A}"
    case verticalTab = "\u{000B}"
    case formFeed = "\u{000C}"
    case carriageReturn = "\u{000D}"
    case space = "\u{0020}"
    case nextLine = "\u{0085}"
    case noBreakSpace = "\u{00A0}"
    case enSpace = "\u{2002}"
    case emSpace = "\u{2003}"
    case figureSpace = "\u{2007}"
    case thinSpace = "\u{2009}"
    case hairSpace = "\u{200A}"
    case zeroWidthSpace = "\u{200B}"
    case nonBreakingHyphen = "\u{2011}"
    case figureDash = "\u{2012}"
    case enDash = "\u{2013}"
    case emDash = "\u{2014}"
    case horizontalEllipsis = "\u{2026}"
    case lineSeparator = "\u{2028}"
    case paragraphSeparator = "\u{2029}"
    case leftToRightOverride = "\u{202D}"
    case narrowNoBreakSpace = "\u{202F}"
    case wordJoiner = "\u{2060}"
    case minusSign = "\u{2212}"
    case objectReplacementCharacter = "\u{FFFC}" // NSAttachmentCharacter

}

extension Special: CustomStringConvertible {

    /// A `String` initialized the `UnicodeScalar` of the receiver as its `rawValue`.
    public var description: String {
        return String(rawValue)
    }

}

extension Special {

    /// A developer-facing string for this UnicodeValue. Useful for debugging.
    public var name: String {
        switch self {
        case .tab: return "tab"
        case .lineFeed: return "lineFeed"
        case .verticalTab: return "verticalTab"
        case .formFeed: return "formFeed"
        case .carriageReturn: return "carriageReturn"
        case .space: return "space"
        case .nextLine: return "nextLine"
        case .noBreakSpace: return "noBreakSpace"
        case .enSpace: return "enSpace"
        case .emSpace: return "emSpace"
        case .figureSpace: return "figureSpace"
        case .thinSpace: return "thinSpace"
        case .hairSpace: return "hairSpace"
        case .zeroWidthSpace: return "zeroWidthSpace"
        case .nonBreakingHyphen: return "nonBreakingHyphen"
        case .figureDash: return "figureDash"
        case .enDash: return "enDash"
        case .emDash: return "emDash"
        case .horizontalEllipsis: return "horizontalEllipsis"
        case .lineSeparator: return "lineSeparator"
        case .paragraphSeparator: return "paragraphSeparator"
        case .leftToRightOverride: return "leftToRightOverride"
        case .narrowNoBreakSpace: return "narrowNoBreakSpace"
        case .wordJoiner: return "wordJoiner"
        case .minusSign: return "minusSign"
        case .objectReplacementCharacter: return "objectReplacementCharacter"
        }
    }

    /// All of the enum values contained in `Special`.
    public static var all: [Special] = [
        .tab,
        .lineFeed,
        .verticalTab,
        .formFeed,
        .carriageReturn,
        .space,
        .nextLine,
        .noBreakSpace,
        .enSpace,
        .emSpace,
        .figureSpace,
        .thinSpace,
        .hairSpace,
        .zeroWidthSpace,
        .nonBreakingHyphen,
        .figureDash,
        .enDash,
        .emDash,
        .horizontalEllipsis,
        .lineSeparator,
        .paragraphSeparator,
        .leftToRightOverride,
        .narrowNoBreakSpace,
        .wordJoiner,
        .minusSign,
        .objectReplacementCharacter,
    ]

}
