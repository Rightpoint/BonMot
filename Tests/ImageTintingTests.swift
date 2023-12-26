//
//  ImageTintingTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 9/28/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

#if canImport(AppKit)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

@testable import BonMot
import XCTest

#if !os(watchOS)
class ImageTintingTests: XCTestCase {

    func logoImage() throws -> BONImage {
        #if canImport(AppKit)
        let imageForTest = testBundle.image(forResource: "rz-logo-black")
        #elseif canImport(UIKit)
        let imageForTest = UIImage(named: "rz-logo-black", in: testBundle, compatibleWith: nil)
        #endif
        return try XCTUnwrap(imageForTest)
    }

    var raizlabsRed: BONColor {
        #if canImport(AppKit)
        NSColor(deviceRed: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        #elseif canImport(UIKit)
        UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
        #endif
    }

    let accessibilityDescription = "I’m the very model of a modern accessible image."

    func testImageTinting() throws {
        #if SWIFT_PACKAGE && canImport(AppKit)
        try XCTSkipIf(true, "Doesn't work on macOS SPM targets")
        #endif

        let blackImageName = "rz-logo-black"
        let redImageName = "rz-logo-red"

        #if canImport(AppKit)
            let sourceImage = try XCTUnwrap(testBundle.image(forResource: blackImageName))
            let controlTintedImage = try XCTUnwrap(testBundle.image(forResource: redImageName))
            let testTintedImage = sourceImage.tintedImage(color: raizlabsRed)
        #elseif canImport(UIKit)
            let sourceImage = try XCTUnwrap(UIImage(named: blackImageName, in: testBundle, compatibleWith: nil))
            let controlTintedImage = try XCTUnwrap(UIImage(named: redImageName, in: testBundle, compatibleWith: nil))
            let testTintedImage = sourceImage.tintedImage(color: raizlabsRed)
        #endif

        BONAssertEqualImages(controlTintedImage, testTintedImage)
    }

    func testTintingInAttributedString() throws {
        #if os(iOS) || os(tvOS)
        try XCTSkipIf(true, "No longer working for iOS/tvOS targets")
        #endif

        let imageForTest = try logoImage()

        let untintedString = NSAttributedString.composed(of: [
            imageForTest.styled(with: .color(raizlabsRed)),
            ])

        #if canImport(AppKit)
            let tintableImage = imageForTest
            tintableImage.isTemplate = true
        #elseif canImport(UIKit)
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

    func testNotTintingInAttributedString() throws {
        #if os(iOS) || os(tvOS)
        try XCTSkipIf(true, "No longer working for iOS/tvOS targets")
        #endif

        let imageForTest = try logoImage()

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

    func testAccessibilityIOSAndTVOS() throws {
        let imageForTest = try logoImage()

        #if os(iOS) || os(tvOS)
            imageForTest.accessibilityLabel = accessibilityDescription
            let tintedImage = imageForTest.tintedImage(color: raizlabsRed)
            XCTAssertEqual(tintedImage.accessibilityLabel, accessibilityDescription)
            XCTAssertEqual(tintedImage.accessibilityLabel, tintedImage.accessibilityLabel)
        #endif
    }

    #if canImport(AppKit)
    func testAccessibilityMacOS() throws {
        let imageForTest = try logoImage()

            imageForTest.accessibilityDescription = accessibilityDescription
            let tintedImage = imageForTest.tintedImage(color: raizlabsRed)
            XCTAssertEqual(tintedImage.accessibilityDescription, accessibilityDescription)
            XCTAssertEqual(tintedImage.accessibilityDescription, tintedImage.accessibilityDescription)
    }
    #endif
}
#endif
