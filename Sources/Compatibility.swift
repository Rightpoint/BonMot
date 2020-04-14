//
//  Compatibility.swift
//  BonMot
//
//  Created by Brian King on 8/24/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

// This file declares extensions to system types to provide a compatible API
// between Swift iOS, macOS, watchOS, and tvOS.

#if swift(>=4.2)
#else
    extension NSAttributedString {

        public typealias Key = NSAttributedStringKey

    }
#endif

#if os(OSX)
    #if swift(>=4.2)
    #else
        public typealias NSLineBreakMode = NSParagraphStyle.LineBreakMode
    #endif
#else
    public extension NSParagraphStyle {

        typealias LineBreakMode = NSLineBreakMode

    }

    #if os(iOS) || os(tvOS) || os(watchOS)
        #if swift(>=4.2)
        #else
        extension UIFontDescriptor {

            public typealias SymbolicTraits = UIFontDescriptorSymbolicTraits

        }
        #endif

        extension NSAttributedString.Key {
            #if swift(>=4.2)
            #else
                static let accessibilitySpeechPunctuation = NSAttributedString.Key(UIAccessibilitySpeechAttributePunctuation)
                static let accessibilitySpeechLanguage = NSAttributedString.Key(UIAccessibilitySpeechAttributeLanguage)
                static let accessibilitySpeechPitch = NSAttributedString.Key(UIAccessibilitySpeechAttributePitch)

                @available(iOS 11.0, tvOS 11.0, watchOS 4.0, *)
                static let accessibilitySpeechIPANotation = NSAttributedString.Key(UIAccessibilitySpeechAttributeIPANotation)

                @available(iOS 11.0, tvOS 11.0, watchOS 4.0, *)
                static let accessibilitySpeechQueueAnnouncement = NSAttributedString.Key(UIAccessibilitySpeechAttributeQueueAnnouncement)

                @available(iOS 11.0, tvOS 11.0, watchOS 4.0, *)
                static let accessibilityTextHeadingLevel = NSAttributedString.Key(UIAccessibilityTextAttributeHeadingLevel)
            #endif
        }
    #endif

    #if os(iOS) || os(tvOS)
        #if swift(>=4.2)
        #else
            public extension NSLayoutConstraint {

                typealias Attribute = NSLayoutAttribute
                typealias Relation = NSLayoutRelation
            }

            extension UIFont {

                public typealias TextStyle = UIFontTextStyle

            }

            extension UIContentSizeCategory {

                static var didChangeNotification: NSNotification.Name {
                    return NSNotification.Name.UIContentSizeCategoryDidChange
                }

            }

            extension UIViewController {

                var children: [UIViewController] {
                    return childViewControllers
                }

            }

            extension UIApplication {

                public typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey

            }

        #endif
    #endif
#endif

#if swift(>=4.1)
#else
    extension Array {
        func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
            return try flatMap(transform)
        }
    }
#endif
