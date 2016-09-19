//
//  Compatibility.swift
//  BonMot
//
//  Created by Brian King on 9/13/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import UIKit
import BonMot
#if swift(>=3.0)
    extension UIContentSizeCategory {
        var compatible: BonMotContentSizeCategory {
            return self
        }
    }
#else
    typealias IndexPath = NSIndexPath
    extension UIApplication {
        @nonobjc static var shared: UIApplication {
            return sharedApplication()
        }
    }
    extension UIColor {
        @nonobjc static var darkGray: UIColor {
            return darkGrayColor()
        }
        @nonobjc static var white: UIColor {
            return whiteColor()
        }
        @nonobjc static var black: UIColor {
            return blackColor()
        }
    }
    extension UIFont {
        @nonobjc static func systemFont(ofSize pointSize: CGFloat) -> UIFont {
            return systemFontOfSize(pointSize)
        }
    }

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

    extension NSAttributedString {
    @nonobjc final func attributes(at location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
    return attributesAtIndex(location, effectiveRange: range)
    }
    @nonobjc final func attribute(attribute: String, at location: Int, effectiveRange range: NSRangePointer) -> AnyObject? {
    return self.attribute(attribute, atIndex: location, effectiveRange: range)
    }
    @nonobjc final func enumerateAttribute(attrName: String, in enumerationRange: NSRange, options opts: NSAttributedStringEnumerationOptions, usingBlock block: (AnyObject?, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
    self.enumerateAttribute(attrName, inRange: enumerationRange, options: opts, usingBlock: block)
    }

    @nonobjc final func boundingRect(with size: CGSize, options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGRect {
    return boundingRectWithSize(size, options: options, context: context)
    }

    }
#endif
