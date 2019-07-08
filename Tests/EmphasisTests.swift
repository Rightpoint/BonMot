//
//  EmphasisTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 2/12/18.
//  Copyright © 2018 Rightpoint. All rights reserved.
//

@testable import BonMot
import XCTest

class EmphasisTests: XCTestCase {

    func testEmphasisCombination() {
        let baseFont = BONFont.systemFont(ofSize: 20)
        let base = StringStyle(.font(baseFont))
        let bold = base.byAdding(.emphasis(.bold))
        let italic = base.byAdding(.emphasis(.italic))
        let combined = bold.byAdding(stringStyle: italic)
        let attributes = combined.attributes
        guard let font = attributes[.font] as? BONFont else {
            XCTFail("Unable to get font")
            return
        }

        let descriptor = baseFont.fontDescriptor
        var traits = descriptor.symbolicTraits
        traits.insert([.italic, .bold])
        let newDescriptor: BONFontDescriptor? = descriptor.withSymbolicTraits(traits)
        guard let nonNilNewDescriptor = newDescriptor else {
            XCTFail("Unable to get descriptor")
            return
        }
        let controlFont = BONFont(descriptor: nonNilNewDescriptor, size: 0)

        XCTAssertEqual(font, controlFont)
    }

}
