//
//  Compatibility+Tests.swift
//  BonMot
//
//  Created by Brian King on 9/13/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

//swiftlint:disable file_length
#if os(OSX)
    import AppKit
    let BONFontDescriptorFeatureSettingsAttribute = NSFontFeatureSettingsAttribute
    let BONFontFeatureTypeIdentifierKey = NSFontFeatureTypeIdentifierKey
    let BONFontFeatureSelectorIdentifierKey = NSFontFeatureSelectorIdentifierKey
    typealias BONView = NSView
#else
    import UIKit
    let BONFontDescriptorFeatureSettingsAttribute = UIFontDescriptorFeatureSettingsAttribute
    let BONFontFeatureTypeIdentifierKey = UIFontFeatureTypeIdentifierKey
    let BONFontFeatureSelectorIdentifierKey = UIFontFeatureSelectorIdentifierKey
    typealias BONView = UIView
#endif
import BonMot

#if swift(>=3.0)
#else
    typealias IndexPath = NSIndexPath
    typealias Bundle = NSBundle
    typealias UIApplicationLaunchOptionsKey = NSObject
    typealias UIApplicationLaunchOptionsValue = AnyObject

    extension Bundle {

        convenience init(for aClass: AnyClass) {
            self.init(forClass: aClass)
        }

        #if os(OSX)
            @nonobjc func image(forResource resourceName: String) -> NSImage? {
                return imageForResource(resourceName)
            }
        #endif

    }

    #if os(OSX)
        extension NSView {

            @nonobjc func dataWithPDF(inside rect: NSRect) -> NSData {
                return dataWithPDFInsideRect(bounds)
            }

        }

        extension NSImage {

            @nonobjc func cgImage(forProposedRect rect: UnsafeMutablePointer<NSRect>, context: NSGraphicsContext?, hints: [String: AnyObject]?) -> CGImageRef? {
                return CGImageForProposedRect(rect, context: context, hints: hints)
            }

        }

        extension NSBitmapImageRep {

            convenience init(cgImage: CGImageRef) {
                self.init(CGImage: cgImage)
            }

            @nonobjc func representation(using type: NSBitmapImageFileType, properties: [String: AnyObject]) -> NSData? {
                return representationUsingType(type, properties: properties)
            }

        }
    #endif

    extension NSUnderlineStyle {

        @nonobjc static var byWord = NSUnderlineStyle.ByWord

    }

    extension NSTextAlignment {

        @nonobjc static var center: NSTextAlignment = NSTextAlignment.Center
        @nonobjc static var left: NSTextAlignment = NSTextAlignment.Left

    }

    extension NSLineBreakMode {

        @nonobjc static var byClipping = NSLineBreakMode.ByClipping
        @nonobjc static var byWordWrapping = NSLineBreakMode.ByWordWrapping
        @nonobjc static var byTruncatingMiddle = NSLineBreakMode.ByTruncatingMiddle

    }

    extension NSWritingDirection {

        @nonobjc static var leftToRight = NSWritingDirection.LeftToRight
        @nonobjc static var rightToLeft = NSWritingDirection.RightToLeft
        @nonobjc static var natural = NSWritingDirection.Natural

    }

    extension NSKeyedArchiver {

        @nonobjc static func archivedData(withRootObject rootObject: AnyObject) -> NSData {
            return archivedDataWithRootObject(rootObject)
        }

    }
    extension NSKeyedUnarchiver {

        @nonobjc static func unarchiveObject(with data: NSData) -> AnyObject? {
            return unarchiveObjectWithData(data)
        }

    }

    extension Range {

        func makeIterator() -> RangeGenerator<Element> {
            return generate()
        }

    }

    extension String {

        mutating func append(string: String) {
            appendContentsOf(string)
        }

        @nonobjc var localizedUppercase: String {
            return localizedUppercaseString
        }

    }

    extension CALayer {

        @nonobjc func render(in context: CGContextRef) {
            renderInContext(context)
        }

    }
#endif

// MARK: - Standard Library + Foundation
#if swift(>=3.0)
#else
    typealias OptionSet = OptionSetType
    typealias XMLParser = NSXMLParser
    typealias XMLParserDelegate = NSXMLParserDelegate
    typealias BonMotStringTransform = String
    typealias Data = NSData

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

        func contains(other: String) -> Bool {
            return containsString(other)
        }

    }

    extension NSLayoutRelation {

        static let lessThanOrEqual = NSLayoutRelation.LessThanOrEqual
        static let equal = NSLayoutRelation.Equal
        static let greaterThanOrEqual = NSLayoutRelation.GreaterThanOrEqual

    }

    extension BONFont {

        @nonobjc static func boldSystemFont(ofSize size: CGFloat) -> BONFont {
            return boldSystemFontOfSize(size)
        }

    }

    extension BONColor {

        @nonobjc static var darkGray: BONColor {
            return darkGrayColor()
        }

        @nonobjc static var black: BONColor {
            return blackColor()
        }

        @nonobjc static var white: BONColor {
            return whiteColor()
        }

        @nonobjc static var blue: BONColor {
            return blueColor()
        }

        @nonobjc func withAlphaComponent(alpha: CGFloat) -> BONColor {
            return colorWithAlphaComponent(alpha)
        }

    }
#endif

// MARK: - Shared (AppKit + UIKit)
#if swift(>=3.0)
    extension NSParagraphStyle {

        /// Returns the default paragraph style.
        /// - note: This variable has to be prefixed since `default` is not a
        ///         valid variable name in Swift 2.3
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

        @nonobjc final func boundingRect(with size: CGSize, options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGRect {
            return boundingRectWithSize(size, options: options, context: context)
        }

    }

    extension NSMutableAttributedString {

        @nonobjc final func append(attributedString: NSAttributedString) {
            appendAttributedString(attributedString)
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

    extension BONFont {

        @nonobjc static func systemFont(ofSize size: CGFloat) -> BONFont {
            return BONFont.systemFontOfSize(size)
        }

    }

#endif

// MARK: - UIKit Only
#if os(iOS) || os(watchOS) || os(tvOS)
#if swift(>=3.0)
    typealias UIApplicationLaunchOptionsValue = Any
    extension UIContentSizeCategory {

        var compatible: BonMotContentSizeCategory {
            return self
        }

    }

#else

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

    extension UIImage {

        convenience init?(named: String, in bundle: Bundle, compatibleWith traitCollection: UITraitCollection?) {
            self.init(named: named, inBundle: bundle, compatibleWithTraitCollection: traitCollection)
        }

        func withRenderingMode(renderingMode: UIImageRenderingMode) -> UIImage {
            return imageWithRenderingMode(renderingMode)
        }

    }

    extension UIImageRenderingMode {

        @nonobjc static var alwaysTemplate: UIImageRenderingMode {
            return .AlwaysTemplate
        }

    }

    extension UIButton {

        @nonobjc final func attributedTitle(for state: UIControlState) -> NSAttributedString? {
            return attributedTitleForState(state)
        }

    }

    extension UIViewController {

        @nonobjc final func present(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
            presentViewController(viewController, animated: animated, completion: completion)
        }

    }

    extension UIView {

        @nonobjc var isOpaque: Bool {
            set {
                opaque = newValue
            }
            get {
                return opaque
            }
        }

    }

    extension UIAlertControllerStyle {

        @nonobjc static var alert = UIAlertControllerStyle.Alert
        @nonobjc static var actionSheet = UIAlertControllerStyle.ActionSheet

    }

    extension UIAlertActionStyle {

        @nonobjc static var cancel = UIAlertActionStyle.Cancel
        @nonobjc static var destructive = UIAlertActionStyle.Destructive

    }

    extension UITableView {

        @nonobjc final func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell? {
            return dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        }

        @nonobjc final func deselectRow(at indexPath: IndexPath, animated: Bool) {
            deselectRowAtIndexPath(indexPath, animated: animated)
        }

    }

    extension UIBarButtonItem {

        @nonobjc final func setTitleTextAttributes(attributes: [String: AnyObject], for state: UIControlState) {
            setTitleTextAttributes(attributes, forState: state)
        }

    }

    extension UIControlState {

        @nonobjc static var normal = UIControlState.Normal

    }

    extension UIStoryboard {

        @nonobjc final func instantiateViewController(withIdentifier identifier: String) -> UIViewController? {
            return instantiateViewControllerWithIdentifier(identifier)
        }

    }

    extension UITableViewCellAccessoryType {

        @nonobjc static var none = UITableViewCellAccessoryType.None
        @nonobjc static var disclosureIndicator = UITableViewCellAccessoryType.DisclosureIndicator

    }

    struct UIContentSizeCategory {

        var rawValue: String
        static var extraSmall: UIContentSizeCategory = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryExtraSmall) }()
        static var small = { return UIContentSizeCategory(rawValue: UIContentSizeCategorySmall) }()
        static var medium = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryMedium) }()
        static var large = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryLarge) }()
        static var extraLarge = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryExtraLarge) }()
        static var extraExtraLarge = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryExtraExtraLarge) }()
        static var extraExtraExtraLarge = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryExtraExtraExtraLarge) }()
        static var accessibilityMedium = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryAccessibilityMedium) }()
        static var accessibilityLarge = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryAccessibilityLarge) }()
        static var accessibilityExtraLarge = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryAccessibilityExtraLarge) }()
        static var accessibilityExtraExtraLarge = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryAccessibilityExtraExtraLarge) }()
        static var accessibilityExtraExtraExtraLarge = { return UIContentSizeCategory(rawValue: UIContentSizeCategoryAccessibilityExtraExtraExtraLarge) }()

        var compatible: BonMotContentSizeCategory {
            return rawValue
        }

    }

#endif
#endif
//swiftlint:enable file_length
