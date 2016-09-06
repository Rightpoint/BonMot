//
//  UIFont+Testing.swift
//
//  Created by Brian King on 8/14/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

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
