//
//  FontInspectorTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 11/2/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
@testable import BonMot

class FontInspectorTests: XCTestCase {

    let systemFont = BONFont.systemFont(ofSize: 24)
    let garamond: BONFont = {
        EBGaramondLoader.loadFontIfNeeded()
        return BONFont(name: "EBGaramond12-Regular", size: 24)!
    }()

    override func setUp() {
        super.setUp()
        EBGaramondLoader.loadFontIfNeeded()
    }

    func testHasFeature() {
        XCTAssertTrue(systemFont.has(feature: SmallCaps.fromLowercase))
        XCTAssertTrue(systemFont.has(feature: SmallCaps.disabled))
        XCTAssertFalse(systemFont.has(feature: NumberCase.lower))
        XCTAssertTrue(garamond.has(feature: NumberCase.lower))
    }

    //swiftlint:disable:next function_body_length
    func testAvailableFeatures() {
        let garamondControlString = [
            "Available font features of EBGaramond12-Regular",
            "",
            "All Typographic Features - feature type identifier: 0",
            "    Exclusive: false",
            "    Selectors:",
            "    * On - selector: 0 (default)",
            "",
            "Ligatures - feature type identifier: 1",
            "    Exclusive: false",
            "    Selectors:",
            "    * Common Ligatures - selector: 2 (default)",
            "    * Rare Ligatures - selector: 4",
            "    * Historical Ligatures - selector: 22",
            "",
            "Number Spacing - feature type identifier: 6",
            "    Exclusive: true",
            "    Selectors:",
            "    * Monospaced Numbers - selector: 0",
            "    * Proportional Numbers - selector: 1",
            "    * No Change - selector: 4 (default)",
            "",
            "Vertical Position - feature type identifier: 10",
            "    Exclusive: true",
            "    Selectors:",
            "    * Normal Vertical Position - selector: 0 (default)",
            "    * Superiors/Superscripts - selector: 1",
            "    * Inferiors/Subscripts - selector: 2",
            "    * Ordinals - selector: 3",
            "    * Scientific Inferiors - selector: 4",
            "",
            "Contextual Fractional Forms - feature type identifier: 11",
            "    Exclusive: true",
            "    Selectors:",
            "    * No Fractional Forms - selector: 0 (default)",
            "    * Diagonal - selector: 2",
            "",
            "Number Case - feature type identifier: 21",
            "    Exclusive: true",
            "    Selectors:",
            "    * Old-Style Figures - selector: 0",
            "    * Lining Figures - selector: 1",
            "    * No Change - selector: 2 (default)",
            "",
            "Text Spacing - feature type identifier: 22",
            "    Exclusive: true",
            "    Selectors:",
            "    * No Change - selector: 7 (default)",
            "    * No Kerning - selector: 8",
            "",
            "Case-Sensitive Layout - feature type identifier: 33",
            "    Exclusive: false",
            "    Selectors:",
            "    * Capital Forms - selector: 0",
            "",
            "Alternative Stylistic Sets - feature type identifier: 35",
            "    Exclusive: false",
            "    Selectors:",
            "    * Cyrillic alternate de, el and elj - selector: 2",
            "    * Stylistic Set 2 - selector: 4",
            "    * Stylistic Set 5 - selector: 10",
            "    * Stylistic Set 6 - selector: 12",
            "    * Stylistic Set 7 - selector: 14",
            "    * Stylistic Set 20 - selector: 40",
            "",
            "Contextual Alternates - feature type identifier: 36",
            "    Exclusive: false",
            "    Selectors:",
            "    * Contextual Alternates - selector: 0 (default)",
            "",
            "Lower Case - feature type identifier: 37",
            "    Exclusive: true",
            "    Selectors:",
            "    * No Change - selector: 0 (default)",
            "    * Small Capitals - selector: 1",
            "",
            "Upper Case - feature type identifier: 38",
            "    Exclusive: true",
            "    Selectors:",
            "    * No Change - selector: 0 (default)",
            "    * Small Capitals - selector: 1",
            ].joined(separator: "\n")
        let garamondAvailableFeatures = garamond.availableFontFeatures
        let rejoined = garamondAvailableFeatures.components(separatedBy: "\n").joined(separator: "ZZZZ")
        print("Garamond available features: \(rejoined)")
        XCTAssertEqual(garamondAvailableFeatures, garamondControlString)
    }

}
