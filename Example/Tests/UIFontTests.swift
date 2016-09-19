//
//  UIFontTests.swift
//
//  Created by Brian King on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
@testable import BonMot

#if swift(>=3.0)
    let testTextStyle = UIFontTextStyle.title3
#else
    let testTextStyle = UIFontTextStyleTitle3
#endif

class UIFontTests: XCTestCase {

    /**
     * These tests explores how font attributes persist after construction
     *
     * Note that when a font is created, injected attributes are removed.
     * It appears that font attributes only describe, but can not modify a font.
     * UIFontDescriptorTextStyleAttribute is dropped if a new value is specified outside of the UIFontTextStyle values.
     *
     * An early version of the adaptive behavior used associated objects to associate a scaling function with a font. This turned out to not be a valid approach since
     * UIFont's are unique objects, and the swift API obscured that fact.
     */
    func testUIFont() {
        var attributes = UIFont(name: "Avenir-Roman", size: 10)!.fontDescriptor.fontAttributes
        attributes[UIFontDescriptorFeatureSettingsAttribute] = [
            [
                UIFontFeatureTypeIdentifierKey: 1,
                UIFontFeatureSelectorIdentifierKey: 1
            ],
        ]
        attributes[UIFontDescriptorTextStyleAttribute] = "Test"
        let newAttributes = UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: 0).fontDescriptor.fontAttributes
        XCTAssertEqual(newAttributes.count, 2)
        XCTAssertEqual(newAttributes["NSFontNameAttribute"] as? String, "Avenir-Roman")
        XCTAssertEqual(newAttributes["NSFontSizeAttribute"] as? Int, 10)
    }

    func testTextStyleWithOtherFont() {
        var attributes = UIFont(name: "Avenir-Roman", size: 10)!.fontDescriptor.fontAttributes
        attributes[UIFontDescriptorTextStyleAttribute] = testTextStyle
        let newAttributes = UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: 0).fontDescriptor.fontAttributes
        XCTAssertEqual(newAttributes.count, 2)
        XCTAssertEqual(newAttributes["NSCTFontUIUsageAttribute"] as? BonMotTextStyle, testTextStyle)
        XCTAssertEqual(newAttributes["NSFontSizeAttribute"] as? Int, 10)
    }


//    func testPreferredFont() {
//        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        let pointSize = font.pointSize
//        for size in UIApplication.contentSizeCategoriesToTest {
//            UIApplication.sharedApplication().fakeContentSizeCategory(size)
//            let newFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//            print("\(pointSize) = \(newFont.pointSize)")
//        }
//    }
}

