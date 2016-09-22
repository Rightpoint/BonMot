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

/// Standard Library + Foundation
#if swift(>=3.0)
#else
    typealias OptionSet = Swift.OptionSet
    typealias XMLParser = Foundation.XMLParser
    typealias XMLParserDelegate = Foundation.XMLParserDelegate
    typealias BonMotStringTransform = String

    struct StringTransform {
        static let toUnicodeName = StringTransform.toUnicodeName
    }

    extension CGFloat {
        static var greatestFiniteMagnitude = CGFloat.max
    }

    extension NSString {
        @nonobjc final func lowercased() -> String {
            return lowercased
        }

        @nonobjc final func applyingTransform(_ transform: String, reverse: Bool) -> NSString? {
            return self.applyingTransform(transform, reverse: reverse)
        }

        @nonobjc final func replacingOccurrences(of string: String, with replacement: String) -> String {
            return self.replacingOccurrences(of: string, with: replacement)
        }

    }

    extension NSMutableString {
        @nonobjc final func replacingOccurrences(of target: String, with string: String, options: NSString.CompareOptions, range: NSRange) {
            replaceOccurrences(of: target, with: string, options: options, range: range)
        }
    }

    extension IndexSet {
        @nonobjc convenience init(indexesIn: NSRange) {
            (self as NSIndexSet).init(integersIn: indexesIn.toRange() ?? 0..<0)
        }
        @nonobjc final func enumerateRanges(options theOptions: NSEnumerationOptions = [], @noescape block: (NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
            self.enumerateRanges(options: theOptions, using: block)
        }
    }

    extension NSMutableIndexSet {
        @nonobjc final func remove(in range: NSRange) {
            self.remove(in: range)
        }
    }

    extension Array {
        mutating func append<S : Sequence where S.Iterator.Element == Element>(contentsOf newElements: S) {
            self.append(contentsOf: newElements)
        }
    }

    extension Sequence {
        @warn_unused_result
        func enumerated() -> EnumeratedSequence<Self> {
            return self.enumerated()
        }
    }

    extension Collection where Index : RandomAccessIndexType {
        @warn_unused_result
        func reversed() -> ReverseRandomAccessCollection<Self> {
            return self.reversed()
        }
    }

    extension String {
        struct Encoding {
            static let utf8 = String.Encoding.utf8
        }
        func lengthOfBytes(using encoding: String.Encoding) -> Int {
            return self.lengthOfBytes(using: encoding)
        }
        func data(using encoding: String.Encoding, allowLossyConversion: Bool = false) -> Data? {
            return self.data(using: encoding, allowLossyConversion: allowLossyConversion)
        }
    }
#endif

/// Shared text objects (AppKit + UIKit)
#if swift(>=3.0)
    extension NSParagraphStyle {
        // This method has to be prefixed since default is not a valid variable in Swift 2.3
        @nonobjc static var bon_default: NSParagraphStyle {
            return NSParagraphStyle.default
        }
    }
#else
    extension NSAttributedString {
        @nonobjc final func attributes(at location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
            return self.attributes(at: location, effectiveRange: range)
        }
        @nonobjc final func attribute(_ attribute: String, at location: Int, effectiveRange range: NSRangePointer) -> AnyObject? {
            return self.attribute(attribute, at: location, effectiveRange: range)
        }
        @nonobjc final func enumerateAttribute(_ attrName: String, in enumerationRange: NSRange, options opts: NSAttributedString.EnumerationOptions, usingBlock block: (AnyObject?, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
            enumerateAttribute(attrName, in: enumerationRange, options: opts, using: block)
        }
        @nonobjc final func enumerateAttributes(in enumerationRange: NSRange, options opts: NSAttributedString.EnumerationOptions, usingBlock block: ([String: AnyObject], NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
            self.enumerateAttributes(in: enumerationRange, options: opts, using: block)
        }
        @nonobjc final func boundingRect(with size: CGSize, options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGRect {
            return self.boundingRect(with: size, options: options, context: context)
        }
        @nonobjc final func attributedSubstring(from range: NSRange) -> NSAttributedString {
            return self.attributedSubstring(from: range)
        }
    }

    extension NSMutableAttributedString {
        @nonobjc final func append(_ string: NSAttributedString) {
            self.append(string)
        }
        @nonobjc final func replaceCharacters(in range: NSRange, with str: String) {
            self.replaceCharacters(in: range, with: str)
        }
    }

    extension NSStringDrawingOptions {
        @nonobjc static var usesLineFragmentOrigin = usesLineFragmentOrigin
        @nonobjc static var usesFontLeading = usesFontLeading
        @nonobjc static var usesDeviceMetrics = usesDeviceMetrics
        @nonobjc static var truncatesLastVisibleLine = truncatesLastVisibleLine
    }

    extension NSTextAlignment {
        @nonobjc static var natural = NSTextAlignment.natural
    }

    extension NSParagraphStyle {
        @nonobjc static var bon_default: NSParagraphStyle {
            return `default`
        }
    }

#endif


/// UIKit Only
#if os(iOS) || os(watchOS) || os(tvOS)
#if swift(>=3.0)
    public typealias BonMotTextStyle = UIFontTextStyle
    public typealias BonMotContentSizeCategory = UIContentSizeCategory
#else
    public typealias BonMotTextStyle = String
    public typealias BonMotContentSizeCategory = String

    extension UIApplication {
        @nonobjc static var shared: UIApplication {
            return shared
        }
    }

    extension UIFont {
        @available(iOS 10.0, *)
        @nonobjc static func preferredFont(forTextStyle textStyle: BonMotTextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
            #if swift(>=2.3)
                return preferredFontForTextStyle(textStyle, compatibleWithTraitCollection: traitCollection)
            #else
                fatalError("This method is not supported on iOS 10.0, and this should not be possible.")
            #endif
        }
        @nonobjc static func preferredFont(forTextStyle textStyle: BonMotTextStyle) -> UIFont {
            return self.preferredFont(forTextStyle: textStyle)
        }
        @nonobjc final var fontDescriptor: UIFontDescriptor {
            return fontDescriptor
        }
        @nonobjc final func withSize(_ size: CGFloat) -> UIFont {
            return self.withSize(size)
        }
    }

    extension UIFontDescriptor {
        @nonobjc final var fontAttributes: StyleAttributes {
            return fontAttributes
        }
    }
#endif
#endif

