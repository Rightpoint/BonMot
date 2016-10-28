//
//  DemoStrings.swift
//
//  Created by Brian King on 8/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

enum DemoStrings {
    static let colorString: NSAttributedString = {
        // Define a colored image that's slightly shifted to account for the line height
        let racket = UIImage(named: "Tennis Racket")!.styled(with:
            .color(.raizlabsRed), .baselineOffset(-4.0))

        let gray = StringStyle.style(
            .font(BONFont(name: "GillSans-Light", size: 20)!),
            .lineHeightMultiple(1.8),
            .color(.darkGray))
        let accent = gray.byAdding(.font(BONFont(name: "SuperClarendon-Black", size: 20)!))

        let black = accent.byAdding(.color(.white), .backgroundColor(.black))
        let red = accent.byAdding(.color(.white), .backgroundColor(.raizlabsRed))
        let signed = accent.byAdding(.color(.raizlabsRed))

        return NSAttributedString.composed(of: [
            "I want to be different. If everyone is wearing ",
            "\(Special.noBreakSpace)black,\(Special.noBreakSpace)".styled(with: black),
            " I want to be wearing ",
            "\(Special.noBreakSpace)red.\(Special.noBreakSpace)".styled(with: red),
            "\nMaria Sharapova ".styled(with: signed),
            racket
            ], baseStyle: gray)
    }()

    static let colorStringXML: NSAttributedString = {
        // Define a colored image that's slightly shifted to account for the line height
        let racket = UIImage(named: "Tennis Racket")!.styled(with:
            .color(.raizlabsRed), .baselineOffset(-4.0))

        // Define styles
        let accent = StringStyle.style(.font(BONFont(name: "SuperClarendon-Black", size: 20)!))
        let black = accent.byAdding(.color(.white), .backgroundColor(.black))
        let red = accent.byAdding(.color(.white), .backgroundColor(.raizlabsRed))
        let signed = accent.byAdding(.color(.raizlabsRed))

        // Define the base style with xml rules for all tags
        let baseStyle = StringStyle.style(
            .font(BONFont(name: "GillSans-Light", size: 20)!),
            .lineHeightMultiple(1.8),
            .color(.darkGray),
            .xmlRules([
                .style("black", black),
                .style("red", red),
                .style("signed", signed),
                .enter(element: "racket", insert: racket)
                ]
            )
        )
        return "I want to be different. If everyone is wearing <black><BON:noBreakSpace/>black,<BON:noBreakSpace/></black> I want to be wearing <red><BON:noBreakSpace/>red.<BON:noBreakSpace/></red>\n<signed>Maria Sharapova</signed> <racket/>".styled(with: baseStyle)
    }()

    static let trackingString = "Adults are always asking kids what they want to be when they grow up because they are looking for ideas.\n—Paula Poundstone"
        .styled(with: .tracking(.adobe(300)),
                .font(UIFont(name: "Avenir-Book", size: 18)!),
                .adapt(.control))

    static let lineHeightString = "I used to love correcting people’s grammar until I realized what I loved more was having friends.\n—Mara Wilson"
        .styled(with: .font(UIFont(name: "AmericanTypewriter", size: 17.0)!),
                .lineHeightMultiple(1.8),
                .adapt(.control)
    )

    static let proportionalStyle = StringStyle.style(
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
            ], baseStyle: .style(
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .adapt(.control)
            )),
        NSAttributedString.composed(of: [
            "🍑 →",
            Tab.headIndent(4.0),
            "You can also use strings (including emoji) for bullets as well, and they will still properly indent the appended text by the right amount."
            ], baseStyle: .style(
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .color(.darkGray),
                .adapt(.control)
            )),
        ({
            let listItem = StringStyle.style(
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .adapt(.control),
                .paragraphSpacingAfter(10.0)
            )
            let code = StringStyle.style(
                .font(UIFont(name: "Menlo-Regular", size: 16.0)!),
                .backgroundColor(UIColor.blue.withAlphaComponent(0.1)),
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
        ], baseStyle: .style(
            .font(UIFont(name: "HelveticaNeue-Bold", size: 24)!),
            .adapt(.control)
        ))

    static let noSpaceTextStyle = StringStyle.style(
        .font(.systemFont(ofSize: 17)),
        .adapt(.control),
        .color(.darkGray),
        .baselineOffset(10)
    )
    static let noSpaceString = NSAttributedString.composed(of: [
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
        return StringStyle.style(.initialAttributes(["Storyboard": theIdentifier]))
    }

    static let dynamcTypeUIKit = DemoStrings.CustomStoryboard(identifier: "CatalogViewController")
        .attributedString(from: "Dynamic UIKit elements with custom fonts")
    static let preferredFonts = DemoStrings.CustomStoryboard(identifier: "PreferredFonts")
        .attributedString(from: "Preferred Fonts")

}