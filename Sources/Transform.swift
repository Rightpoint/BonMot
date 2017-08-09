//
//  Transform.swift
//  BonMot
//
//  Created by Zev Eisenberg on 3/24/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public enum Transform {

    public typealias TransformFunction = (String) -> String

    case lowercase
    case uppercase
    case capitalized

    case lowercaseWithLocale(Locale)
    case uppercaseWithLocale(Locale)
    case capitalizedWithLocale(Locale)
    case custom(TransformFunction)

    public var transformer: TransformFunction {
        switch self {
        case .lowercase: return { string in string.localizedLowercase }
        case .uppercase: return { string in string.localizedUppercase }
        case .capitalized: return { string in string.localizedCapitalized }

        case .lowercaseWithLocale(let locale): return { string in string.lowercased(with: locale) }
        case .uppercaseWithLocale(let locale): return { string in string.uppercased(with: locale) }
        case .capitalizedWithLocale(let locale): return { string in string.capitalized(with: locale) }

        case .custom(let transform): return transform
        }
    }

}

extension Transform: EmbeddedTransformation {

    internal enum Keys {

        static let name = "name"
        static let locale = "locale"

    }

    internal enum Name: String {

        case lowercase
        case uppercase
        case capitalized
        case custom

    }

    internal var name: Name {
        switch self {
        case .lowercase, .lowercaseWithLocale: return Name.lowercase
        case .uppercase, .uppercaseWithLocale: return Name.uppercase
        case .capitalized, .capitalizedWithLocale: return Name.capitalized
        case .custom: return Name.custom
        }
    }

    public var asDictionary: StyleAttributes {
        var dict: StyleAttributes = [
            Keys.name: name.rawValue,
        ]

        switch self {
        case .lowercaseWithLocale(let locale):
            dict[Keys.locale] = locale as NSLocale
        case .uppercaseWithLocale(let locale):
            dict[Keys.locale] = locale as NSLocale
        case .capitalizedWithLocale(let locale):
            dict[Keys.locale] = locale as NSLocale
        default:
            break
        }

        return dict
    }

    public init?(dictionary dict: StyleAttributes) {
        guard let name = (dict[Keys.name] as? String).flatMap(Name.init) else {
            return nil
        }

        switch (name, dict[Keys.locale] as? Locale) {
        case (.lowercase, nil):
            self = .lowercase
        case (.uppercase, nil):
            self = .uppercase
        case (.capitalized, nil):
            self = .capitalized
        case (.lowercase, let locale?):
            self = .lowercaseWithLocale(locale)
        case (.uppercase, let locale?):
            self = .uppercaseWithLocale(locale)
        case (.capitalized, let locale?):
            self = .capitalizedWithLocale(locale)
        default:
            return nil
        }
    }

}
