//
//  AssertHelpers.swift
//  BonMot
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

import BonMot
import XCTest

func dataFromImage(image theImage: BONImage) -> Data {
    assert(theImage.size != .zero)
    #if os(OSX)
        let cgImageRef = theImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let bitmapImageRep = NSBitmapImageRep(cgImage: cgImageRef!)
        let pngData = bitmapImageRep.representation(using: .png, properties: [:])!
        return pngData
    #else
        return theImage.pngData()!
    #endif
}

func BONAssert<T: Equatable>(attributes dictionary: StyleAttributes?, key: NSAttributedString.Key, value: T, file: StaticString = #filePath, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? T else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssertEqual(dictionaryValue, value, "\(key): \(dictionaryValue) != \(value)", file: file, line: line)
}

func BONAssertColor(inAttributes dictionary: StyleAttributes?, key: NSAttributedString.Key, color controlColor: BONColor, file: StaticString = #filePath, line: UInt = #line) {
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

func BONAssert<T>(attributes dictionary: StyleAttributes?, key: NSAttributedString.Key, float: T, accuracy: T, file: StaticString = #filePath, line: UInt = #line) where T: FloatingPoint {
    guard let dictionaryValue = dictionary?[key] as? T else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssertEqual(dictionaryValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert<T>(attributes dictionary: StyleAttributes?, query: (BONFont) -> T, float: T, accuracy: T = T(0.001), file: StaticString = #filePath, line: UInt = #line) where T: BinaryFloatingPoint {
    guard let font = dictionary?[.font] as? BONFont else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let value = query(font)
    XCTAssertEqual(value, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert<T>(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> T, float: T, accuracy: T = T(0.001), file: StaticString = #filePath, line: UInt = #line) where T: BinaryFloatingPoint {
    guard let paragraphStyle = dictionary?[.paragraphStyle] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(actualValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert<T>(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> T, value: T, file: StaticString = #filePath, line: UInt = #line) where T: Equatable {
    guard let paragraphStyle = dictionary?[.paragraphStyle] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(value, actualValue, file: file, line: line)
}

func BONAssertEqualImages(_ image1: BONImage, _ image2: BONImage, file: StaticString = #filePath, line: UInt = #line) {
    let data1 = dataFromImage(image: image1)
    let data2 = dataFromImage(image: image2)
    XCTAssertEqual(data1, data2, file: file, line: line)
}

func BONAssertNotEqualImages(_ image1: BONImage, _ image2: BONImage, file: StaticString = #filePath, line: UInt = #line) {
    let data1 = dataFromImage(image: image1)
    let data2 = dataFromImage(image: image2)
    XCTAssertNotEqual(data1, data2, file: file, line: line)
}

func BONAssertEqualFonts(_ font1: BONFont, _ font2: BONFont, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    let descriptor1 = font1.fontDescriptor
    let descriptor2 = font2.fontDescriptor

    XCTAssertEqual(descriptor1, descriptor2, message(), file: file, line: line)
}
