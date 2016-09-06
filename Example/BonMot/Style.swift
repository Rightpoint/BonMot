//
//  Style.swift
//
//  Created by Brian King on 7/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BonMot

struct Style {

    // This is the font scaling example from WWDC 2016 Session 803. Note that all of this defines just 1 font style, and can get
    // pretty cumbersome to implement app wide.
    //
    // Only the title of the navigation bar uses this font function.
    static let wwdcFontScalingTable: [String: (pointSize: CGFloat, styleName: String, leading: CGFloat,  tracking: CGFloat)] = [
        UIContentSizeCategoryExtraSmall:                        (10.0, "Heavy",   3.0,  0.6),
        UIContentSizeCategorySmall:                             (12.0, "Heavy",   2.0,  0.4),
        UIContentSizeCategoryMedium:                            (14.0, "Roman",   1.0,  0.2),
        UIContentSizeCategoryLarge:                             (16.0, "Roman",   0.0,  0.0),
        UIContentSizeCategoryExtraLarge:                        (17.0, "Roman",   0.0,  0.0),
        UIContentSizeCategoryExtraExtraLarge:                   (18.0, "Roman",   0.0,  0.0),
        UIContentSizeCategoryExtraExtraExtraLarge:              (19.0, "Light",  -2.0, -0.1),
        UIContentSizeCategoryAccessibilityMedium:               (20.0, "Light",  -3.0, -0.2),
        UIContentSizeCategoryAccessibilityLarge:                (21.0, "Light",  -4.0, -0.2),
        UIContentSizeCategoryAccessibilityExtraLarge:           (22.0, "Light",  -4.0, -0.2),
        UIContentSizeCategoryAccessibilityExtraExtraLarge:      (23.0, "Light",  -4.0, -0.2),
        UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: (24.0, "Light",  -4.0, -0.2),
        ]


    static func wwdcFontScalingFunction(contentSizeCategory: String) -> UIFont {
        guard let info = wwdcFontScalingTable[contentSizeCategory] else {
            fatalError("Invalid content size category")
        }
        let fontName = "Avenir-\(info.styleName)"
        // Do leading and tracking in the font.
        guard let font =  UIFont(name: fontName, size: info.pointSize) else {
            fatalError("Unable to create font.")
        }
        return font
    }

}

extension Style: StyleAttributeProvider {

    func style(attributes theAttributes: StyleAttributes, traitCollection: UITraitCollection?) -> StyleAttributes {
        var theAttributes = theAttributes
        let contentSizeCategory = traitCollection?.bon_preferredContentSizeCategory ?? UIApplication.sharedApplication().preferredContentSizeCategory
        theAttributes[NSFontAttributeName] = Style.wwdcFontScalingFunction(contentSizeCategory)
        return theAttributes
    }

}

extension UIFont {

    static func appFontOfSize(pointSize: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Roman", size: pointSize)!
    }

}
