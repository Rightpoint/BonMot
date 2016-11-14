//
//  TextAlignmentConstraintTests.swift
//  BonMot
//
//  Created by Cameron Pulsford on 10/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

import XCTest
@testable import BonMot

class TextAlignmentConstraintTests: XCTestCase {

    private func field(withText text: String, fontSize: CGFloat) -> BONTextField {
        let field = BONTextField(frame: .zero)
        field.translatesAutoresizingMaskIntoConstraints = false

        #if swift(>=3.0)
            field.font = .systemFont(ofSize: fontSize)
        #else
            field.font = .systemFontOfSize(fontSize)
        #endif

        #if os(OSX)
            field.stringValue = text
        #else
            field.text = text
        #endif

        return field
    }

    func testTopConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .top,
            relatedBy: .equal,
            toItem: right,
            attribute: .top
        )

        XCTAssertEqualWithAccuracy(constraint.constant, 0, accuracy: 0.0001)
    }

    func testCapHeightConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .capHeight,
            relatedBy: .equal,
            toItem: right,
            attribute: .capHeight
        )

        #if os(OSX)
            let target: CGFloat = 8.6528
        #else
            let target: CGFloat = 8.1694
        #endif

        XCTAssertEqualWithAccuracy(constraint.constant, target, accuracy: 0.0001)
    }

    func testXHeightConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .xHeight,
            relatedBy: .equal,
            toItem: right,
            attribute: .xHeight
        )

        #if os(OSX)
            let target: CGFloat = 14.53417
        #else
            let target: CGFloat = 14.05078
        #endif

        XCTAssertEqualWithAccuracy(constraint.constant, target, accuracy: 0.0001)
    }

    func testTopToCapHeightConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .top,
            relatedBy: .equal,
            toItem: right,
            attribute: .capHeight
        )

        #if os(OSX)
            let target: CGFloat = 13.1103
        #else
            let target: CGFloat = 12.378
        #endif

        XCTAssertEqualWithAccuracy(constraint.constant, target, accuracy: 0.0001)
    }

    func testCapHeightToTopConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .capHeight,
            relatedBy: .equal,
            toItem: right,
            attribute: .top
        )

        #if os(OSX)
            let target: CGFloat = -4.4575
        #else
            let target: CGFloat = -4.20850
        #endif

        XCTAssertEqualWithAccuracy(constraint.constant, target, accuracy: 0.0001)
    }

    func testTopToXHeightConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .top,
            relatedBy: .equal,
            toItem: right,
            attribute: .xHeight
        )

        #if os(OSX)
            let target: CGFloat = 22.02148
        #else
            let target: CGFloat = 21.289
        #endif

        XCTAssertEqualWithAccuracy(constraint.constant, target, accuracy: 0.0001)
    }

    func testXHeightToTopConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .xHeight,
            relatedBy: .equal,
            toItem: right,
            attribute: .top
        )

        #if os(OSX)
            let target: CGFloat = -7.4873
        #else
            let target: CGFloat = -7.2382
        #endif

        XCTAssertEqualWithAccuracy(constraint.constant, target, accuracy: 0.0001)
    }

    func testCapHeightToXHeightConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .capHeight,
            relatedBy: .equal,
            toItem: right,
            attribute: .xHeight
        )

        #if os(OSX)
            let target: CGFloat = 17.5639
        #else
            let target: CGFloat = 17.0806
        #endif

        XCTAssertEqualWithAccuracy(constraint.constant, target, accuracy: 0.0001)
    }

    func testXHeightToCapHeightConstraint() {
        let left = field(withText: "left", fontSize: 17)
        let right = field(withText: "right", fontSize: 50)

        let constraint = TextAlignmentConstraint.with(
            item: left,
            attribute: .xHeight,
            relatedBy: .equal,
            toItem: right,
            attribute: .capHeight
        )

        #if os(OSX)
            let target: CGFloat = 5.6230
        #else
            let target: CGFloat = 5.1396
        #endif

        XCTAssertEqualWithAccuracy(constraint.constant, target, accuracy: 0.0001)
    }

}
