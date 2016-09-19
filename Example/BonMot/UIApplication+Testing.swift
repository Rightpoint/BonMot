//
//  UIApplication+Testing.swift
//
//  Created by Brian King on 7/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit


/// Small extension with some test code to showcase and test that Dynamic Type is working
/// Note that this does not work very well on iOS 10, although it does work to some degree.
extension UIApplication {

    func fakeContentSizeCategory(contentSizeCategory: String) {
        #if swift(>=2.3)
            #if swift(>=3.0)
                let notificationCenter = NotificationCenter.default
                let notificationName = NSNotification.Name.UIContentSizeCategoryDidChange
            #else
                let notificationCenter = NSNotificationCenter.defaultCenter()
                let notificationName = UIContentSizeCategoryDidChangeNotification
            #endif

            let traitCollection = bon_topTraitEnvironment.traitCollection.bon_duplicateTraitCollection(preferredContentSizeCategory: contentSizeCategory)
            (bon_topTraitEnvironment as! NSObject).setValue(traitCollection, forKey: "traitCollection")
            notificationCenter.postNotificationName(notificationName, object: bon_topTraitEnvironment, userInfo: [UIContentSizeCategoryNewValueKey: contentSizeCategory])
        #else
            setValue(contentSizeCategory, forKey: "preferredContentSizeCategory")
        #endif
    }

    final var bon_topTraitEnvironment: UITraitEnvironment {
        return keyWindow!
    }

    final var bon_preferredContentSizeCategory: String {
        #if swift(>=2.3)
            if #available(iOS 10.0, *) {
                return bon_topTraitEnvironment.traitCollection.preferredContentSizeCategory
            }
            else {
                return preferredContentSizeCategory
            }
        #else
            return preferredContentSizeCategory
        #endif
    }

    @nonobjc static var contentSizeCategoriesToTest = [
        UIContentSizeCategory.extraSmall,
        UIContentSizeCategory.small,
        UIContentSizeCategory.medium,
        UIContentSizeCategory.large,
        UIContentSizeCategory.extraLarge,
        UIContentSizeCategory.extraExtraLarge,
        UIContentSizeCategory.extraExtraExtraLarge,
        UIContentSizeCategory.accessibilityMedium,
        UIContentSizeCategory.accessibilityLarge,
        UIContentSizeCategory.accessibilityExtraLarge,
        UIContentSizeCategory.accessibilityExtraExtraLarge,
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge
    ]

    func nextContentSizeCategory() -> String {
        let contentSizeCategories = UIApplication.contentSizeCategoriesToTest
        guard let index = contentSizeCategories.indexOf(bon_preferredContentSizeCategory) else {
            fatalError("Invalid contentSizeCategory configured")
        }
        let newIndex = index.successor() < contentSizeCategories.count ? index.successor() : contentSizeCategories.startIndex
        return contentSizeCategories[newIndex]
    }

    @objc func selectNextContentSizeCategory() {
        fakeContentSizeCategory(nextContentSizeCategory())
    }
    
}

extension UITraitCollection {
    func bon_duplicateTraitCollection(preferredContentSizeCategory preferredContentSizeCategory: String) -> UITraitCollection {
        var traitCollections: [UITraitCollection] = Array()
        if userInterfaceIdiom != .Unspecified {
            traitCollections.append(UITraitCollection(userInterfaceIdiom: userInterfaceIdiom))
        }
        if displayScale != 0.0 {
            traitCollections.append(UITraitCollection(displayScale: displayScale))
        }
        if horizontalSizeClass != .Unspecified {
            traitCollections.append(UITraitCollection(horizontalSizeClass: horizontalSizeClass))
        }
        if verticalSizeClass != .Unspecified {
            traitCollections.append(UITraitCollection(verticalSizeClass: verticalSizeClass))
        }
        if forceTouchCapability != .Unknown {
            traitCollections.append(UITraitCollection(forceTouchCapability: forceTouchCapability))
        }
        #if swift(>=2.3)
        if #available(iOS 10.0, *), layoutDirection != .Unspecified {
            traitCollections.append(UITraitCollection(layoutDirection: layoutDirection))
        }
        if #available(iOS 10.0, *), preferredContentSizeCategory != UIContentSizeCategoryUnspecified {
            traitCollections.append(UITraitCollection(preferredContentSizeCategory: preferredContentSizeCategory))
        }
        if #available(iOS 10.0, *), displayGamut != .Unspecified {
            traitCollections.append(UITraitCollection(displayGamut: displayGamut))
        }
        #endif
        return UITraitCollection(traitsFromCollections: traitCollections)
    }
}

extension UIFont {
    @nonobjc static let styles = [
        UIFontTextStyleTitle1,
        UIFontTextStyleTitle2,
        UIFontTextStyleTitle3,
        UIFontTextStyleHeadline,
        UIFontTextStyleSubheadline,
        UIFontTextStyleBody,
        UIFontTextStyleCallout,
        UIFontTextStyleFootnote,
        UIFontTextStyleCaption1,
        UIFontTextStyleCaption2,
        ]

    @nonobjc static var allStyleFonts: [UIFont] {
        return styles.map() {
            return UIFont.preferredFontForTextStyle($0)
        }
    }

    var textStyleName: String {
        guard let textStyle = fontDescriptor().fontAttributes()[UIFontDescriptorTextStyleAttribute] as? String else {
            fatalError("Invalid font, should not be asking for the text style.")
        }
        return textStyle.stringByReplacingOccurrencesOfString("UICTFontTextStyle", withString: "")
    }
}
