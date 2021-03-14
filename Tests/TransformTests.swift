//
//  TransformTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 3/24/17.
//  Copyright © 2017 Rightpoint. All rights reserved.
//

@testable import BonMot
import XCTest

private extension Locale {

    static var german: Locale {
        return Locale(identifier: "de_DE")
    }

}

class TransformTests: XCTestCase {

    func testStyle(withTransform theTransform: Transform) -> StringStyle {
        return StringStyle(
            .color(.darkGray),
            .xmlRules([
                .style("bold", StringStyle(
                    .color(.blue),
                    .transform(theTransform)
                )),
                ]))
    }

    func assertCorrectColors(inSubstrings substrings: [(substring: String, color: BONColor)], in string: NSAttributedString, file: StaticString = #filePath, line: UInt = #line) {
        // Confirm that lengths and strings match

        let reconstructed = substrings.reduce("") { $0 + $1.substring }
        XCTAssertEqual(reconstructed, string.string, "Reconstructed string did not match test string", file: file, line: line)

        // Confirm that colors match for substrings
        var startIndex = 0
        for (substring, substringColor) in substrings {
            let substringUTF16Count = substring.utf16.count
            defer { startIndex += substringUTF16Count }

            for i in startIndex..<(startIndex + substringUTF16Count) {
                let characterRange = NSRange(location: i, length: 1)
                let characterAttributes = string.attributes(at: startIndex, longestEffectiveRange: nil, in: characterRange)

                guard let characterColor = characterAttributes[.foregroundColor] as? BONColor else {
                    XCTFail("Failed to get color at index \(startIndex) of string \(string)", file: file, line: line)
                    continue
                }

                XCTAssertEqual(characterColor, substringColor, "Colors not equal at index \(i) of string \(string)", file: file, line: line)
            }
        }
    }

    func testLowercase() {
        let string = "Time remaining: <bold>&lt; 1 DAY</bold> FROM NOW"

        let styled = string.styled(with: testStyle(withTransform: .lowercase))

        XCTAssertEqual(styled.string, "Time remaining: < 1 day FROM NOW")

        assertCorrectColors(inSubstrings: [
            ("Time remaining: ", .darkGray),
            ("< 1 day", .blue),
            (" FROM NOW", .darkGray),
            ], in: styled)
    }

    func testUppercase() {
        let string = "Time remaining: <bold>&lt; 1 day</bold> from now"

        let styled = string.styled(with: testStyle(withTransform: .uppercase))

        XCTAssertEqual(styled.string, "Time remaining: < 1 DAY from now")

        assertCorrectColors(inSubstrings: [
            ("Time remaining: ", .darkGray),
            ("< 1 DAY", .blue),
            (" from now", .darkGray),
            ], in: styled)
    }

    func testCapitalized() {
        let string = "Time remaining: <bold>&lt; 1 day after the moment that is now</bold> (but no longer)"

        let styled = string.styled(with: testStyle(withTransform: .capitalized))

        XCTAssertEqual(styled.string, "Time remaining: < 1 Day After The Moment That Is Now (but no longer)")

        assertCorrectColors(inSubstrings: [
            ("Time remaining: ", .darkGray),
            ("< 1 Day After The Moment That Is Now", .blue),
            (" (but no longer)", .darkGray),
            ], in: styled)
    }

    func testLocalizedLowercase() {
        let string = "Translation: <bold>&lt;Straße&gt;</bold> is German for <bold>street</bold>."

        let styled = string.styled(with: testStyle(withTransform: .lowercaseWithLocale(.german)))

        XCTAssertEqual(styled.string, "Translation: <straße> is German for street.")

        assertCorrectColors(inSubstrings: [
            ("Translation: ", .darkGray),
            ("<straße>", .blue),
            (" is German for ", .darkGray),
            ("street", .blue),
            (".", .darkGray),
            ], in: styled)

    }

    func testLocalizedUppercase() {
        let string = "Translation: <bold>&lt;Straße&gt;</bold> is German for <bold>street</bold>."

        let styled = string.styled(with: testStyle(withTransform: .uppercaseWithLocale(.german)))

        XCTAssertEqual(styled.string, "Translation: <STRASSE> is German for STREET.")

        assertCorrectColors(inSubstrings: [
            ("Translation: ", .darkGray),
            ("<STRASSE>", .blue),
            (" is German for ", .darkGray),
            ("STREET", .blue),
            (".", .darkGray),
            ], in: styled)
    }

    func testLocalizedCapitalized() {
        let string = "Translation: <bold>&lt;straße&gt;</bold> is German for <bold>street</bold>."

        let styled = string.styled(with: testStyle(withTransform: .capitalizedWithLocale(.german)))

        XCTAssertEqual(styled.string, "Translation: <Straße> is German for Street.")

        assertCorrectColors(inSubstrings: [
            ("Translation: ", .darkGray),
            ("<Straße>", .blue),
            (" is German for ", .darkGray),
            ("Street", .blue),
            (".", .darkGray),
            ], in: styled)
    }

    func testCustom() {
        let doubler = { (string: String) -> String in
            let doubled = string.flatMap { (character: Character) -> [Character] in
                switch character {
                case " ": return [character]
                default: return [character, character]
                }
            }
            let joined = String(doubled)
            return joined
        }

        XCTAssertEqual(doubler(""), "")
        XCTAssertEqual(doubler("a"), "aa")
        XCTAssertEqual(doubler("abc"), "aabbcc")
        XCTAssertEqual(doubler("abc def"), "aabbcc ddeeff")
        XCTAssertEqual(doubler("abc ß def"), "aabbcc ßß ddeeff")

        let string = "Time remaining: <bold>&lt; 1 day</bold> from now"

        let styled = string.styled(with: testStyle(withTransform: .custom(doubler)))

        XCTAssertEqual(styled.string, "Time remaining: << 11 ddaayy from now")

        assertCorrectColors(inSubstrings: [
            ("Time remaining: ", .darkGray),
            ("<< 11 ddaayy", .blue),
            (" from now", .darkGray),
            ], in: styled)
    }

}
