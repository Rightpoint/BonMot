//
//  Compatibility.swift
//
//  Created by Brian King on 8/24/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

/// The purpose of this file is to declare extensions to UIKit objects to provide a compatible API between 2.x and 3.0.
/// All methods should be non-public and static or final to ensure they do not add selectors or methods to the external namespace.
/// The bon_ prefix is used in some cases because it would conflict with the original implementation  in 2.x or 3.x.

#if swift(>=3.0)
    public typealias BonMotTextStyle = UIFontTextStyle
    public typealias BonMotContentSizeCategory = UIContentSizeCategory
#else
    public typealias BonMotTextStyle = String
    public typealias BonMotContentSizeCategory = String
#endif

#if swift(>=3.0)
    extension UIFont {
        static func bon_preferredFont(forTextStyle textStyle: BonMotTextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
            if #available(iOS 10.0, *) {
                return preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
            }
            else {
                return preferredFont(forTextStyle: textStyle)
            }
        }

        final var bon_fontDescriptor: UIFontDescriptor {
            return fontDescriptor
        }

        final var bon_textStyle: UIFontTextStyle? {
            guard let textStyle = bon_fontDescriptor.bon_fontAttributes[UIFontDescriptorTextStyleAttribute] as? String else {
                return nil
            }
            return UIFontTextStyle(rawValue: textStyle)
        }
    }

    extension UIFontDescriptor {
        final var bon_fontAttributes: StyleAttributes {
            return fontAttributes
        }
    }

    extension UISegmentedControl {
        final func bon_titleTextAttributes(for state: UIControlState) -> StyleAttributes {
            let attributes = titleTextAttributes(for: state) ?? [:]
            var result: StyleAttributes = [:]
            for value in attributes {
                guard let string = value.key as? String else {
                    fatalError("Can not convert key \(value.key) to String")
                }
                result[string] = value
            }
            return result
        }
    }
#else
    typealias OptionSet = OptionSetType
    typealias XMLParser = NSXMLParser
    typealias XMLParserDelegate = NSXMLParserDelegate

    extension UIApplication {
        static var shared: UIApplication {
            return sharedApplication()
        }
    }

    extension UIFont {
        static func bon_preferredFont(forTextStyle textStyle: BonMotTextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
            #if swift(>=2.3)
            if #available(iOS 10.0, *) {
                return preferredFontForTextStyle(textStyle, compatibleWithTraitCollection: traitCollection)
            }
            #endif
            return preferredFontForTextStyle(textStyle)
        }

        final var bon_fontDescriptor: UIFontDescriptor {
            return fontDescriptor()
        }

        final var bon_textStyle: String? {
            guard let textStyle = bon_fontDescriptor.bon_fontAttributes[UIFontDescriptorTextStyleAttribute] as? String else {
                return nil
            }
            return textStyle
        }

        final func withSize(size: CGFloat) -> UIFont {
            return fontWithSize(size)
        }
    }

    extension UIFontDescriptor {
        final var bon_fontAttributes: StyleAttributes {
            return fontAttributes()
        }
    }
    extension NSAttributedString {
        func attributes(at location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
            return attributesAtIndex(location, effectiveRange: range)
        }
        func attribute(attribute: String, at location: Int, effectiveRange range: NSRangePointer) -> AnyObject? {
            return self.attribute(attribute, atIndex: location, effectiveRange: range)
        }

    }
    extension NSMutableAttributedString {
        final func append(string: NSAttributedString) {
            appendAttributedString(string)
        }

        func replaceCharacters(in range: NSRange, with str: String) {
            replaceCharactersInRange(range, withString: str)
        }
    }

    extension NSString {
        final func lowercased() -> String {
            return lowercaseString
        }
    }

    extension NSMutableString {
        func replacingOccurrences(of target: String, with string: String, options: NSStringCompareOptions, range: NSRange) {
            replaceOccurrencesOfString(target, withString: string, options: options, range: range)
        }
    }

    extension Array {
        mutating func append<S : SequenceType where S.Generator.Element == Element>(contentsOf newElements: S) {
            appendContentsOf(newElements)
        }
    }

    extension SequenceType {
        @warn_unused_result
        public func enumerated() -> EnumerateSequence<Self> {
            return enumerate()
        }
    }

    extension CollectionType where Index : RandomAccessIndexType {
        @warn_unused_result
        public func reversed() -> ReverseRandomAccessCollection<Self> {
            return reverse()
        }
    }

#endif

extension UITraitCollection {

    /// Obtain the preferredContentSizeCategory for the trait collection. This is compatible with iOS 9.x
    /// and will use the UIApplication preferredContentSizeCategory if the trait collections
    /// preferredContentSizeCategory is UIContentSizeCategoryUnspecified.
    public var bon_preferredContentSizeCategory: BonMotContentSizeCategory {
        #if swift(>=3.0)
            if #available(iOS 10.0, *) {
                if preferredContentSizeCategory != .unspecified {
                    return preferredContentSizeCategory
                }
            }
        #elseif swift(>=2.3)
            if #available(iOS 10.0, *) {
                if preferredContentSizeCategory != UIContentSizeCategoryUnspecified {
                    return preferredContentSizeCategory
                }
            }
        #endif
        return UIApplication.shared.preferredContentSizeCategory
    }
}
