//
//  AssertHelpers.swift
//  BonMot
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

func dataFromImage(image theImage: BONImage) -> Data {
    assert(theImage.size != .zero)
    #if os(OSX)
        let cgImageRef = theImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let bitmapImageRep = NSBitmapImageRep(cgImage: cgImageRef!)
        let pngData = bitmapImageRep.representation(using: .png, properties: [:])!
        return pngData
    #else
        return UIImagePNGRepresentation(theImage)!
    #endif
}

func BONAssert<T: Equatable>(attributes dictionary: StyleAttributes?, key: NSAttributedStringKey, value: T, file: StaticString = #file, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? T else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssert(dictionaryValue == value, "\(key): \(dictionaryValue) != \(value)", file: file, line: line)
}

func BONAssertColor(inAttributes dictionary: StyleAttributes?, key: NSAttributedStringKey, color controlColor: BONColor, file: StaticString = #file, line: UInt = #line) {
    guard let testColor = dictionary?[key] as? BONColor else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }

    let testComps = testColor.rgbaComponents
    let controlComps = controlColor.rgbaComponents

    XCTAssertEqual(testComps.r, controlComps.r, accuracy: 0.0001)
    XCTAssertEqual(testComps.g, controlComps.g, accuracy: 0.0001)
    XCTAssertEqual(testComps.b, controlComps.b, accuracy: 0.0001)
    XCTAssertEqual(testComps.a, controlComps.a, accuracy: 0.0001)
}

func BONAssert(attributes dictionary: StyleAttributes?, key: NSAttributedStringKey, float: CGFloat, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? CGFloat else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssertEqual(dictionaryValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (BONFont) -> CGFloat, float: CGFloat, accuracy: CGFloat = 0.001, file: StaticString = #file, line: UInt = #line) {
    guard let font = dictionary?[.font] as? BONFont else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let value = query(font)
    XCTAssertEqual(value, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> CGFloat, float: CGFloat, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    guard let paragraphStyle = dictionary?[.paragraphStyle] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(actualValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> Int, value: Int, file: StaticString = #file, line: UInt = #line) {
    guard let paragraphStyle = dictionary?[.paragraphStyle] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(value, actualValue, file: file, line: line)
}

func BONAssert<T: RawRepresentable>(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> T, value: T, file: StaticString = #file, line: UInt = #line) where T.RawValue: Equatable {
    guard let paragraphStyle = dictionary?[.paragraphStyle] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(value.rawValue, actualValue.rawValue, file: file, line: line)
}

func BONAssertEqualImages(_ image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
    let data1 = dataFromImage(image: image1)
    let data2 = dataFromImage(image: image2)
    XCTAssertEqual(data1, data2, file: file, line: line)
}

func BONAssertNotEqualImages(_ image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
    let data1 = dataFromImage(image: image1)
    let data2 = dataFromImage(image: image2)
    XCTAssertNotEqual(data1, data2, file: file, line: line)
}

func BONAssertEqualFonts(_ font1: BONFont, _ font2: BONFont, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    let descriptor1 = font1.fontDescriptor
    let descriptor2 = font2.fontDescriptor

    XCTAssertEqual(descriptor1, descriptor2, message, file: file, line: line)
}
