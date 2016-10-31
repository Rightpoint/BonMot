//
//  DemoStrings.swift
//
//  Created by Brian King on 8/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

enum DemoStrings {

    /// Style a string, with both global and range-based overrides,
    /// from an XML source. This is the most common use case for
    /// styling substrings of localized strings, where searching for
    /// and replacing substrings on a per-language basis is cumbersome.
    static let xml: NSAttributedString = {

        // This would typically come from NSLocalizedString
        let localizedString = "I want to be different. If everyone is wearing <black><BON:noBreakSpace/>black,<BON:noBreakSpace/></black> I want to be wearing <red><BON:noBreakSpace/>red.<BON:noBreakSpace/></red>\n<signed>Maria Sharapova</signed> <racket/>"

        // Define a colored image that's slightly shifted to account for the line height
        let racket = UIImage(named: "Tennis Racket")!.styled(with:
            .color(.raizlabsRed), .baselineOffset(-4.0))

        // Define styles
        let accent = StringStyle(parts: .font(BONFont(name: "SuperClarendon-Black", size: 20)!))
        let black = accent.byAdding(.color(.white), .backgroundColor(.black))
        let red = accent.byAdding(.color(.white), .backgroundColor(.raizlabsRed))
        let signed = accent.byAdding(.color(.raizlabsRed))

        // Define the base style with xml rules for all tags
        let baseStyle = StringStyle(parts:
            .font(BONFont(name: "GillSans-Light", size: 20)!),
            .lineHeightMultiple(1.8),
            .color(.darkGray),
            .adapt(.control),
            .xmlRules([
                .style("black", black),
                .style("red", red),
                .style("signed", signed),
                .enter(element: "racket", insert: racket)
                ]
            )
        )
        return localizedString.styled(with: baseStyle)
    }()

    /// Compose a string piecewise from different components.
    /// If you are using localized strings, do not use this approach.
    /// Instead, use XML as in the previous example. Use composition
    /// only if you absolutely need to build the string from pieces.
    static let composition: NSAttributedString = {
        // Define a colored image that's slightly shifted to account for the line height
        let boat = UIImage(named: "boat")!.styled(with:
            .color(.raizlabsRed))

        let baseStyle = StringStyle(parts:
            .alignment(.center),
            .color(.black)
        )

        let preamble = baseStyle.byAdding(
            .font(BONFont(name: "AvenirNext-Bold", size: 14)!),
            .adapt(.body)
        )

        let bigger = baseStyle.byAdding(
            .font(BONFont(name: "AvenirNext-Heavy", size: 64)!),
            .adapt(.control)
        )

        return NSAttributedString.composed(of: [
            "You’re going to need a\n".styled(with: preamble),
            "Bigger\n".localizedUppercase.styled(with: bigger),
            boat,
            ], baseStyle: baseStyle)
    }()

    /// A simple examle, demonstrating using tracking and a few other adjustments
    static let trackingString = "my precious"
        .styled(
            with:
            .tracking(.point(12.86)),
            .font(UIFont(name: "AvenirNext-BoldItalic", size: 18)!),
            .alignment(.center),
            .color(BONColor(hex: 0x672C6E)),
            .adapt(.control)
    )

    /// This example uses XML to combine many feautres, including single-character kerning
    /// to move the period at the end of the sentence closer to its preceding character.
    static let lineSpacingString: NSAttributedString = {

        let fullStyle = StringStyle(parts:
            .alignment(.center),
            .color(.raizlabsRed),
            .font(BONFont(name: "AvenirNext-Medium", size: 16)!),
            .adapt(.body),
            .lineSpacing(20),
            .xmlRules([
                .style("large", StringStyle(parts:
                    .font(BONFont(name: "AvenirNext-Heavy", size: 64)!),
                    .lineSpacing(40),
                    .adapt(.control))),
                .style("kern", StringStyle(parts:
                    .tracking(.adobe(-80))
                    )),
                ])
        )

        let phrase = "GO<BON:noBreakSpace/>AHEAD,\n<large>MAKE\nMY\nDA<kern>Y.</kern></large>"

        let attributedString = phrase.styled(with: fullStyle)
        return attributedString
    }()

    static let proportionalStyle = StringStyle(parts:
        .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
        .adapt(.control)
    )

    static let proportionalStrings: [NSAttributedString] = [
        "Proportional Uppercase\n1111111111\n0123456789".styled(with: proportionalStyle.byAdding(
            .numberSpacing(.proportional),
            .numberCase(.upper))),
        "Proportional Lowercase\n1111111111\n0123456789".styled(with: proportionalStyle.byAdding(
            .numberSpacing(.proportional),
            .numberCase(.lower))),
        "Monospaced Uppercase\n1111111111\n0123456789".styled(with: proportionalStyle.byAdding(
            .numberSpacing(.monospaced),
            .numberCase(.upper))),
        "Monospaced Lowercase\n1111111111\n0123456789".styled(with: proportionalStyle.byAdding(
            .numberSpacing(.monospaced),
            .numberCase(.lower))),
        ]

    static let indentationStrings: [NSAttributedString] = [
        NSAttributedString.composed(of: [
            UIImage(named: "robot")!,
            Tab.headIndent(4.0),
            "“It’s OK to ask for help. When doing a final exam, all the work must be yours, but in engineering, the point is to get the job done, and people are happy to help. Corollaries: You should be generous with credit, and you should be happy to help others.”",
            Special.lineSeparator,
            Special.emDash,
            "Radia Perlman",
            ], baseStyle: StringStyle(parts:
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .adapt(.control)
            )),
        NSAttributedString.composed(of: [
            "🍑 →",
            Tab.headIndent(4.0),
            "You can also use strings (including emoji) for bullets as well, and they will still properly indent the appended text by the right amount."
            ], baseStyle: StringStyle(parts:
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .color(.darkGray),
                .adapt(.control)
            )),
        ({
            let listItem = StringStyle(parts:
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .adapt(.control),
                .paragraphSpacingAfter(10.0)
            )
            let code = StringStyle(parts:
                .font(UIFont(name: "Menlo-Regular", size: 16.0)!),
                .backgroundColor(BONColor.blue.withAlphaComponent(0.1)),
                .adapt(.control)
            )
            let bullet = NSAttributedString.composed(of: ["🍑 →", Tab.headIndent(4.0)])
            let rules: [XMLStyleRule] = [
                .style("li", listItem),
                .style("code", code),
                .enter(element: "li", insert: bullet),
                .exit(element: "li", insert: "\n")
            ]

            let xml = "<li>This list is defined with XML and displayed in a single <code>UILabel</code>.</li><li>Each row is represented with an <code>&lt;li&gt;</code> tag.</li><li>Attributed strings define the string to use for bullets.</li><li>The text style is also specified for the <code>&lt;li&gt;</code> and <code>&lt;code&gt;</code> tags.</li>"
            guard let string = try? NSAttributedString.composed(ofXML: xml, rules: rules) else {
                fatalError("Unable to load XML \(xml)")
            }
            return string
        })()
    ]

    static let imageString = NSAttributedString.composed(of: [
        "2".styled(with: .baselineOffset(8)),
        UIImage(named: "bee")!,
        UIImage(named: "oar")!,
        UIImage(named: "knot")!,
        "2".styled(with: .baselineOffset(8)),
        UIImage(named: "bee")!
        ], baseStyle: StringStyle(parts:
            .font(UIFont(name: "HelveticaNeue-Bold", size: 24)!),
            .adapt(.control)
        ))

    static let noSpaceTextStyle = StringStyle(parts:
        .font(.systemFont(ofSize: 17)),
        .adapt(.control),
        .color(.darkGray),
        .baselineOffset(10)
    )
    static let noBreakSpaceString = NSAttributedString.composed(of: [
        ("barn", "This"),
        ("bee", "string"),
        ("bug", "is"),
        ("circuit", "separated"),
        ("cut", "by"),
        ("discount", "images"),
        ("gift", "and"),
        ("pin", "no-break"),
        ("robot", "spaces"),
        ].map() {
            return NSAttributedString.composed(of: [UIImage(named: $0)!, Special.noBreakSpace, $1.styled(with: noSpaceTextStyle)])
        }, separator: " ")

    static let heartsString = NSAttributedString.composed(of: (0..<20).makeIterator().map() { i in
        let offset: CGFloat = 15 * sin((CGFloat(i) / 20.0) * 7.0 * CGFloat(M_PI))
        return "❤️".styled(with: .baselineOffset(offset))
    })

    static func CustomStoryboard(identifier theIdentifier: String) -> StringStyle {
        // Embed an attribute for the storyboard identifier to link to. This is
        // a good example of custom attributes, even if this might not be the best
        // UIKit design pattern.
        return StringStyle(parts: .initialAttributes(["Storyboard": theIdentifier]))
    }

    static let dynamcTypeUIKit = DemoStrings.CustomStoryboard(identifier: "CatalogViewController")
        .attributedString(from: "Dynamic UIKit elements with custom fonts")
    static let preferredFonts = DemoStrings.CustomStoryboard(identifier: "PreferredFonts")
        .attributedString(from: "Preferred Fonts")

}
