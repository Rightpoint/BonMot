//
//  Compatibility.swift
//  BonMot
//
//  Created by Brian King on 8/24/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

//swiftlint:disable file_length
#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// This file declares extensions to UIKit, Foundation, and Standard library
/// types to provide a compatible API between Swift 2.x and 3.0. All methods
/// should be non-public and static or final to ensure they do not add selectors
/// or methods to the external namespace. The bon_ prefix is used when Swift 2.x
/// cannot support the token, e.g. ".default".

// MARK: - Standard Library + Foundation
#if swift(>=3.0)
#else
    typealias OptionSet = OptionSetType

    // Declared as public because XMLBuilderError needs it.
    public typealias Error = ErrorType

    // Declared as public because Transform needs it
    public typealias Locale = NSLocale

    // Declared as public because StringStyle needs it
    public typealias URL = NSURL

    typealias XMLParser = NSXMLParser
    typealias XMLParserDelegate = NSXMLParserDelegate
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

        var inverted: NSCharacterSet {
            return invertedSet
        }

        @nonobjc static var controlCharacters: NSCharacterSet {
            return controlCharacterSet()
        }

        @nonobjc static var whitespaces: NSCharacterSet {
            return whitespaceCharacterSet()
        }

        @nonobjc static var whitespacesAndNewlines: NSCharacterSet {
            return whitespaceAndNewlineCharacterSet()
        }

        @nonobjc static var decimalDigits: NSCharacterSet {
            return decimalDigitCharacterSet()
        }

        @nonobjc static var letters: NSCharacterSet {
            return letterCharacterSet()
        }

        @nonobjc static var lowercaseLetters: NSCharacterSet {
            return lowercaseLetterCharacterSet()
        }

        @nonobjc static var uppercaseLetters: NSCharacterSet {
            return uppercaseLetterCharacterSet()
        }

        @nonobjc static var nonBaseCharacters: NSCharacterSet {
            return nonBaseCharacterSet()
        }

        @nonobjc static var alphanumerics: NSCharacterSet {
            return alphanumericCharacterSet()
        }

        @nonobjc static var decomposables: NSCharacterSet {
            return decomposableCharacterSet()
        }

        @nonobjc static var illegalCharacters: NSCharacterSet {
            return illegalCharacterSet()
        }

        @nonobjc static var punctuationCharacters: NSCharacterSet {
            return punctuationCharacterSet()
        }

        @nonobjc static var capitalizedLetters: NSCharacterSet {
            return capitalizedLetterCharacterSet()
        }

        @nonobjc static var symbols: NSCharacterSet {
            return symbolCharacterSet()
        }

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

    extension NSBundle {

        @nonobjc func path(forResource resource: String, ofType type: String) -> String? {
            return pathForResource(resource, ofType: type)
        }

    }

    extension SequenceType where Generator.Element == String {

        func joined(separator separator: String = "") -> String {
            return joinWithSeparator(separator)
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

        func components(separatedBy separator: NSCharacterSet) -> [String] {
            return componentsSeparatedByCharactersInSet(separator)
        }

        func appending(string: String) -> String {
            return stringByAppendingString(string)
        }

        init<T>(describing instance: T) {
            self.init(instance)
        }

        var localizedLowercase: String {
            return localizedLowercaseString
        }

        var localizedUppercase: String {
            return localizedUppercaseString
        }

        var localizedCapitalized: String {
            return localizedCapitalizedString
        }

        func lowercased(with locale: Locale) -> String {
            return self.lowercaseStringWithLocale(locale)
        }

        func uppercased(with locale: Locale) -> String {
            return self.uppercaseStringWithLocale(locale)
        }

        func capitalized(with locale: Locale) -> String {
            return self.capitalizedStringWithLocale(locale)
        }

    }

    extension NSObjectProtocol {

        func responds(to aSelector: Selector!) -> Bool {
            return respondsToSelector(aSelector)
        }

        func perform(aSelector: Selector!, with object: AnyObject!) -> Unmanaged<AnyObject>! {
            return performSelector(aSelector, withObject: object)
        }

    }

    extension Locale {

        convenience init(identifier: String) {
            self.init(localeIdentifier: identifier)
        }

    }
#endif

// MARK: - Shared (AppKit + UIKit)
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

        @nonobjc final func enumerateAttributes(in enumerationRange: NSRange, options opts: NSAttributedStringEnumerationOptions, using block: ([String: AnyObject], NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
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
            return CGColor
        }

    }
#endif

// MARK: - UIKit Only
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

        extension UIControlState {

            @nonobjc static var normal: UIControlState {
                return .Normal
            }

        }

        extension UIButton {

            @nonobjc final func setAttributedTitle(title: NSAttributedString?, for state: UIControlState) {
                setAttributedTitle(title, forState: state)
            }

        }
    #endif

    #if os(iOS) || os(watchOS) || os(tvOS)
        extension BONFont {

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

            @nonobjc final func addingAttributes(attributes: [String: AnyObject]) -> UIFontDescriptor {
                return fontDescriptorByAddingAttributes(attributes)
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
                return CGImage
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

    #if os(iOS) || os(tvOS) || os(OSX)
        extension NSLayoutAttribute {

            static let left = NSLayoutAttribute.Left
            static let right = NSLayoutAttribute.Right
            static let top = NSLayoutAttribute.Top
            static let bottom = NSLayoutAttribute.Bottom
            static let leading = NSLayoutAttribute.Leading
            static let trailing = NSLayoutAttribute.Trailing
            static let width = NSLayoutAttribute.Width
            static let height = NSLayoutAttribute.Height
            static let centerX = NSLayoutAttribute.CenterX
            static let centerY = NSLayoutAttribute.CenterY
            static let lastBaseline = NSLayoutAttribute.LastBaseline
            static let firstBaseline = NSLayoutAttribute.FirstBaseline
            static let notAnAttribute = NSLayoutAttribute.NotAnAttribute

            #if os(iOS) || os(tvOS)
                static let leftMargin = NSLayoutAttribute.LeftMargin
                static let rightMargin = NSLayoutAttribute.RightMargin
                static let topMargin = NSLayoutAttribute.TopMargin
                static let bottomMargin = NSLayoutAttribute.BottomMargin
                static let leadingMargin = NSLayoutAttribute.LeadingMargin
                static let trailingMargin = NSLayoutAttribute.TrailingMargin
                static let centerXWithinMargins = NSLayoutAttribute.CenterXWithinMargins
                static let centerYWithinMargins = NSLayoutAttribute.CenterYWithinMargins
            #endif

        }
    #endif
#endif

// MARK: - AppKit Only
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
//swiftlint:enable file_length
