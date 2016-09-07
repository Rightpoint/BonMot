//
//  AssertHelpers.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

func FPAssertKey<T: Equatable>(dictionary: StyleAttributes, key: String, value: T, file: StaticString = #file, line: UInt = #line) {
    if let dictionaryValue = dictionary[key] as? T {
        XCTAssert(dictionaryValue == value, "\(key): \(dictionaryValue) != \(value)", file: file, line: line)
    }
    else {
        XCTFail("value is not of expected type", file: file, line: line)
    }
}

func FPAssertKey<T: FloatingPointType>(dictionary: StyleAttributes, key: String, float: T, accuracy: T, file: StaticString = #file, line: UInt = #line) {
    if let dictionaryValue = dictionary[key] as? T {
        XCTAssertEqualWithAccuracy(dictionaryValue, float, accuracy: accuracy, file: file, line: line)
    }
    else {
        XCTFail("value is not of expected type", file: file, line: line)
    }
}

func FPAssertFont(dictionary: StyleAttributes?, query: (UIFont) -> CGFloat, float: CGFloat, accuracy: CGFloat = 0.001, file: StaticString = #file, line: UInt = #line) {
    if let dictionary = dictionary,
        let font = dictionary[NSFontAttributeName] as? UIFont {
        let value = query(font)
        XCTAssertEqualWithAccuracy(value, float, accuracy: accuracy, file: file, line: line)
    }
    else {
        XCTFail("value is not of expected type", file: file, line: line)
    }
}

func FPAssertParagraphStyle(dictionary: StyleAttributes?, query: (NSParagraphStyle) -> CGFloat, float: CGFloat, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    if let dictionary = dictionary,
        let paragraphStyle = dictionary[NSParagraphStyleAttributeName] as? NSParagraphStyle {
        let actualValue = query(paragraphStyle)
        XCTAssertEqualWithAccuracy(actualValue, float, accuracy: accuracy, file: file, line: line)
    }
    else {
        XCTFail("value is not of expected type", file: file, line: line)
    }
}

func FPAssertParagraphStyle<T: RawRepresentable where T.RawValue: Equatable>(dictionary: StyleAttributes, query: (NSParagraphStyle) -> T, value: T, file: StaticString = #file, line: UInt = #line) {
    if let paragraphStyle = dictionary[NSParagraphStyleAttributeName] as? NSParagraphStyle {
        let actualValue = query(paragraphStyle)
        XCTAssertEqual(value.rawValue, actualValue.rawValue)
    }
    else {
        XCTFail("value is not of expected type", file: file, line: line)
    }
}

func FPAssertParagraphStyle(dictionary: StyleAttributes, query: (NSParagraphStyle) -> Int, value: Int, file: StaticString = #file, line: UInt = #line) {
    if let paragraphStyle = dictionary[NSParagraphStyleAttributeName] as? NSParagraphStyle {
        let actualValue = query(paragraphStyle)
        XCTAssertEqual(value, actualValue)
    }
    else {
        XCTFail("value is not of expected type", file: file, line: line)
    }
}
