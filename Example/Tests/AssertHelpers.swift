//
//  AssertHelpers.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

func BONAssert<T: Equatable>(attributes dictionary: StyleAttributes?, key: String, value: T, file: StaticString = #file, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? T else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssert(dictionaryValue == value, "\(key): \(dictionaryValue) != \(value)", file: file, line: line)
}

func BONAssert<T: FloatingPoint>(attributes dictionary: StyleAttributes?, key: String, float: T, accuracy: T, file: StaticString = #file, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? T else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssertEqualWithAccuracy(dictionaryValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (UIFont) -> CGFloat, float: CGFloat, accuracy: CGFloat = 0.001, file: StaticString = #file, line: UInt = #line) {
    guard let font = dictionary?[NSFontAttributeName] as? UIFont else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let value = query(font)
    XCTAssertEqualWithAccuracy(value, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> CGFloat, float: CGFloat, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    guard let paragraphStyle = dictionary?[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqualWithAccuracy(actualValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert<T: RawRepresentable>(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> T, value: T, file: StaticString = #file, line: UInt = #line) where T.RawValue: Equatable {
    guard let paragraphStyle = dictionary?[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(value.rawValue, actualValue.rawValue)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> Int, value: Int, file: StaticString = #file, line: UInt = #line) {
    guard let paragraphStyle = dictionary?[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(value, actualValue)
}
