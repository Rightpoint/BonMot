//
//  Compatibility.swift
//
//  Created by Brian King on 8/24/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// The purpose of this file is to declare extensions to UIKit objects to provide a compatible API between 2.x and 3.0.
/// All methods should be non-public and static or final to ensure they do not add selectors or methods to the external namespace.
/// The bon_ prefix is used when 2.x can not support the token (Like default)

/// Standard Library + Foundation
#if swift(>=3.0)
#else
    typealias OptionSet = OptionSetType
    public typealias Error = ErrorType
    typealias XMLParser = NSXMLParser
    typealias XMLParserDelegate = NSXMLParserDelegate
    typealias BonMotStringTransform = String
    typealias CharacterSet = NSCharacterSet
    typealias Data = NSData

    struct StringTransform {
        static let toUnicodeName = NSStringTransformToUnicodeName
    }

    extension CGFloat {
        static var greatestFiniteMagnitude = CGFloat.max
    }

    extension CGContext {
        @nonobjc func translateBy(x dx: CGFloat, y ty: CGFloat) {
            CGContextTranslateCTM(self, dx, ty)
        }

        @nonobjc func scaleBy(x dx: CGFloat, y dy: CGFloat) {
            CGContextScaleCTM(self, dx, dy)
        }

        @nonobjc func setBlendMode(blendMode: CGBlendMode) {
            CGContextSetBlendMode(self, blendMode)
        }

        @nonobjc func draw(image: CGImage, in rect: CGRect) {
            CGContextDrawImage(self, rect, image)
        }

        @nonobjc func setFillColor(color: CGColor) {
            CGContextSetFillColorWithColor(self, color)
        }

        @nonobjc func fill(rect: CGRect) {
            CGContextFillRect(self, rect)
        }

    }

    extension CGBlendMode {
        static var normal: CGBlendMode {
            return .Normal
        }

        static var sourceIn: CGBlendMode {
            return .SourceIn
        }
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
        @nonobjc final func rangeOfCharacter(from characterSet: CharacterSet, options: NSStringCompareOptions, range: NSRange) -> NSRange {
            return rangeOfCharacterFromSet(characterSet, options: options, range: range)
        }
        @nonobjc final func range(of string: String, options: NSStringCompareOptions, range: NSRange) -> NSRange {
            return rangeOfString(string, options: options, range: range)
        }
    }

    extension NSMutableString {
        @nonobjc final func replacingOccurrences(of target: String, with string: String, options: NSStringCompareOptions, range: NSRange) {
            replaceOccurrencesOfString(target, withString: string, options: options, range: range)
        }
    }
    extension NSStringCompareOptions {
        @nonobjc static var backwards: NSStringCompareOptions {
            return .BackwardsSearch
        }
    }

    extension NSCharacterSet {
        @nonobjc static var newlines: NSCharacterSet {
            return newlineCharacterSet()
        }
    }

    extension NSIndexSet {
        @nonobjc convenience init(indexesIn: NSRange) {
            self.init(indexesInRange: indexesIn)
        }
        @nonobjc final func enumerateRanges(options theOptions: NSEnumerationOptions = [], block: (NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
            enumerateRangesWithOptions(theOptions, usingBlock: block)
        }
    }

    extension NSMutableIndexSet {
        @nonobjc final func remove(in range: NSRange) {
            removeIndexesInRange(range)
        }
    }

    extension Array {
        mutating func append<S: SequenceType where S.Generator.Element == Element>(contentsOf newElements: S) {
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

/// Shared (AppKit + UIKit)
#if swift(>=3.0)
    extension NSParagraphStyle {
        // This method has to be prefixed since default is not a valid variable in Swift 2.3
        @nonobjc static var bon_default: NSParagraphStyle {
            #if os(OSX)
                return NSParagraphStyle.default()
            #else
                return NSParagraphStyle.default
            #endif
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

    extension BONColor {
        @nonobjc var cgColor: CGColorRef {
            return self.CGColor
        }
    }
#endif

/// UIKit Only
#if swift(>=3.0)
#else

#if os(iOS) || os(tvOS)
    extension UIApplication {
        @nonobjc static var shared: UIApplication {
            return sharedApplication()
        }
    }

    extension UIFont {
        @available(iOS 10.0, tvOS 10.0, *)
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
    }
#endif

#if os(iOS) || os(watchOS) || os(tvOS)
    extension UIFont {
        @nonobjc final var fontDescriptor: UIFontDescriptor {
            return fontDescriptor()
        }
        @nonobjc final func withSize(size: CGFloat) -> UIFont {
            return fontWithSize(size)
        }
        @nonobjc static func systemFont(ofSize pointSize: CGFloat) -> UIFont {
            return systemFontOfSize(pointSize)
        }
    }

    extension UIFontDescriptor {
        @nonobjc final var fontAttributes: StyleAttributes {
            return fontAttributes()
        }
    }

    extension UIImage {
        @nonobjc func withAlignmentRectInsets(insets: UIEdgeInsets) -> UIImage {
            return imageWithAlignmentRectInsets(insets)
        }

        @nonobjc func resizableImage(withCapInsets capInsets: UIEdgeInsets, resizingMode: UIImageResizingMode) -> UIImage {
            return resizableImageWithCapInsets(capInsets, resizingMode: resizingMode)
        }

        @nonobjc var cgImage: CGImageRef? {
            return self.CGImage
        }

        @nonobjc func withRenderingMode(renderingMode: UIImageRenderingMode) -> UIImage {
            return imageWithRenderingMode(renderingMode)
        }
    }

    extension UIImageRenderingMode {
        @nonobjc static var alwaysOriginal: UIImageRenderingMode {
            return .AlwaysOriginal
        }
    }
#endif
#endif

/// AppKit Only
#if swift(>=3.0)
#else

#if os(OSX)
    extension NSImage {
        @nonobjc var isTemplate: Bool {
            set {
                template = newValue
            }
            get {
                return template
            }
        }

        @nonobjc func cgImage(forProposedRect rect: UnsafeMutablePointer<NSRect>, context: NSGraphicsContext?, hints: [String: AnyObject]?) -> CGImageRef? {
            return CGImageForProposedRect(rect, context: context, hints: hints)
        }
    }

    extension NSGraphicsContext {
        @nonobjc class func current() -> NSGraphicsContext? {
            return currentContext()
        }

        @nonobjc var cgContext: CGContextRef {
            return CGContext
        }
    }
#endif
#endif
