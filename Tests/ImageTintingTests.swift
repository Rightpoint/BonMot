//
//  ImageTintingTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 9/28/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

@testable import BonMot
import XCTest

class ImageTintingTests: XCTestCase {

    let imageForTest = testBundle.testImage(forResource: "rz-logo-black")!
    #if os(OSX)
        let raizlabsRed = NSColor(deviceRed: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
    #else
        let raizlabsRed = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
    #endif

    let accessibilityDescription = "I’m the very model of a modern accessible image."

    func testImageTinting() {
        let blackImageName = "rz-logo-black"
        let redImageName   = "rz-logo-red"

        let sourceImage        = testBundle.testImage(forResource: blackImageName)!
        let controlTintedImage = testBundle.testImage(forResource: redImageName)!
        #if os(OSX)
            let testTintedImage = sourceImage.tintedImage(color: raizlabsRed)
        #else
            let testTintedImage = sourceImage.tintedImage(color: raizlabsRed)
        #endif

        BONAssertEqualImages(controlTintedImage, testTintedImage)
    }

    func testTintingInAttributedString() {
        let untintedString = NSAttributedString.composed(of: [
            imageForTest.styled(with: .color(raizlabsRed)),
            ])

        #if os(OSX)
            let tintableImage = imageForTest
            tintableImage.isTemplate = true
        #else
            let tintableImage = imageForTest.withRenderingMode(.alwaysTemplate)
        #endif

        let tintedString = NSAttributedString.composed(of: [
            tintableImage.styled(with: .color(raizlabsRed)),
            ])

        let untintedResult = untintedString.snapshotForTesting()
        let tintedResult = tintedString.snapshotForTesting()

        XCTAssertNotNil(untintedResult)
        XCTAssertNotNil(tintedResult)

        BONAssertNotEqualImages(untintedResult!, tintedResult!)
    }

    func testNotTintingInAttributedString() {
        let untintedString = NSAttributedString.composed(of: [
            imageForTest,
            ])

        let tintAttemptString = NSAttributedString.composed(of: [
            imageForTest.styled(with: .color(raizlabsRed)),
            ])

        let untintedResult = untintedString.snapshotForTesting()
        let tintAttemptResult = tintAttemptString.snapshotForTesting()

        XCTAssertNotNil(untintedResult)
        XCTAssertNotNil(tintAttemptResult)

        BONAssertEqualImages(untintedResult!, tintAttemptResult!)
    }

    func testAccessibilityIOSAndTVOS() {
        #if os(iOS) || os(tvOS)
            imageForTest.accessibilityLabel = accessibilityDescription
            let tintedImage = imageForTest.tintedImage(color: raizlabsRed)
            XCTAssertEqual(tintedImage.accessibilityLabel, accessibilityDescription)
            XCTAssertEqual(tintedImage.accessibilityLabel, tintedImage.accessibilityLabel)
        #endif
    }

    func testAccessibilityOSX() {
        #if os(OSX)
            imageForTest.accessibilityDescription = accessibilityDescription
            let tintedImage = imageForTest.tintedImage(color: raizlabsRed)
            XCTAssertEqual(tintedImage.accessibilityDescription, accessibilityDescription)
            XCTAssertEqual(tintedImage.accessibilityDescription, tintedImage.accessibilityDescription)
        #endif
    }
}
