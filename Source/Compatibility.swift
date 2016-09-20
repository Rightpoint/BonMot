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
    typealias OptionSet = OptionSetType
    typealias XMLParser = NSXMLParser
    typealias XMLParserDelegate = NSXMLParserDelegate
    typealias BonMotStringTransform = String

    struct StringTransform {
        static let toUnicodeName = NSStringTransformToUnicodeName
    }

    extension CGFloat {
        static var greatestFiniteMagnitude = CGFloat.max
    }

    extension NSString {
        @nonobjc final func lowercased() -> String {
            return lowercaseString
        }

        @nonobjc final func applyingTransform(transform: String, reverse: Bool) -> NSString? {
            return stringByApplyingTransform(transform, reverse: reverse)
        }

        @nonobjc final func replacingOccurrences(of string: String, with replacement: String) -> String {
            return stringByReplacingOccurrencesOfString(string, withString: replacement)
        }

    }

    extension NSMutableString {
        @nonobjc final func replacingOccurrences(of target: String, with string: String, options: NSStringCompareOptions, range: NSRange) {
            replaceOccurrencesOfString(target, withString: string, options: options, range: range)
        }
    }

    extension NSIndexSet {
        @nonobjc convenience init(indexesIn: NSRange) {
            self.init(indexesInRange: indexesIn)
        }
        @nonobjc final func enumerateRanges(options theOptions: NSEnumerationOptions = [], @noescape block: (NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
            enumerateRangesWithOptions(theOptions, usingBlock: block)
        }
    }

    extension NSMutableIndexSet {
        @nonobjc final func remove(in range: NSRange) {
            removeIndexesInRange(range)
        }
    }

    extension Array {
        mutating func append<S : SequenceType where S.Generator.Element == Element>(contentsOf newElements: S) {
            appendContentsOf(newElements)
        }
    }

    extension SequenceType {
        @warn_unused_result
        func enumerated() -> EnumerateSequence<Self> {
            return enumerate()
        }
    }

    extension CollectionType where Index : RandomAccessIndexType {
        @warn_unused_result
        func reversed() -> ReverseRandomAccessCollection<Self> {
            return reverse()
        }
    }

    extension String {
        struct Encoding {
            static let utf8 = NSUTF8StringEncoding
        }
        func lengthOfBytes(using encoding: NSStringEncoding) -> Int {
            return lengthOfBytesUsingEncoding(encoding)
        }
        func data(using encoding: NSStringEncoding, allowLossyConversion: Bool = false) -> NSData? {
            return dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion)
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
            return attributesAtIndex(location, effectiveRange: range)
        }
        @nonobjc final func attribute(attribute: String, at location: Int, effectiveRange range: NSRangePointer) -> AnyObject? {
            return self.attribute(attribute, atIndex: location, effectiveRange: range)
        }
        @nonobjc final func enumerateAttribute(attrName: String, in enumerationRange: NSRange, options opts: NSAttributedStringEnumerationOptions, usingBlock block: (AnyObject?, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
            enumerateAttribute(attrName, inRange: enumerationRange, options: opts, usingBlock: block)
        }
        @nonobjc final func enumerateAttributes(in enumerationRange: NSRange, options opts: NSAttributedStringEnumerationOptions, usingBlock block: ([String: AnyObject], NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
            enumerateAttributesInRange(enumerationRange, options: opts, usingBlock: block)
        }
        @nonobjc final func boundingRect(with size: CGSize, options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGRect {
            return boundingRectWithSize(size, options: options, context: context)
        }
        @nonobjc final func attributedSubstring(from range: NSRange) -> NSAttributedString {
            return attributedSubstringFromRange(range)
        }
    }

    extension NSMutableAttributedString {
        @nonobjc final func append(string: NSAttributedString) {
            appendAttributedString(string)
        }
        @nonobjc final func replaceCharacters(in range: NSRange, with str: String) {
            replaceCharactersInRange(range, withString: str)
        }
    }

    extension NSStringDrawingOptions {
        @nonobjc static var usesLineFragmentOrigin = UsesLineFragmentOrigin
        @nonobjc static var usesFontLeading = UsesFontLeading
        @nonobjc static var usesDeviceMetrics = UsesDeviceMetrics
        @nonobjc static var truncatesLastVisibleLine = TruncatesLastVisibleLine
    }

    extension NSTextAlignment {
        @nonobjc static var natural = NSTextAlignment.Natural
    }

    extension NSParagraphStyle {
        @nonobjc static var bon_default: NSParagraphStyle {
            return defaultParagraphStyle()
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
            return sharedApplication()
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
            return preferredFontForTextStyle(textStyle)
        }
        @nonobjc final var fontDescriptor: UIFontDescriptor {
            return fontDescriptor()
        }
        @nonobjc final func withSize(size: CGFloat) -> UIFont {
            return fontWithSize(size)
        }
    }

    extension UIFontDescriptor {
        @nonobjc final var fontAttributes: StyleAttributes {
            return fontAttributes()
        }
    }
#endif
#endif

