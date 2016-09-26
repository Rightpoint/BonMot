//
//  DemoStrings.swift
//
//  Created by Brian King on 8/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BonMot

enum DemoStrings {
    static let lineHeight = BonMotC({ style in
        style.font = UIFont(name: "SuperClarendon-Black", size: 20)!
        style.lineHeightMultiple = 1.8
        style.adaptations.append(AdaptiveStyle.control)
    })

    static let gray = lineHeight.derive { style in
        style.font = UIFont(name: "GillSans-Light", size: 20)!
        style.textColor = .darkGray
    }
    static let blackBG = lineHeight.derive(
        .textColor(.white),
        .backgroundColor(.black)
    )
    static let redBG = lineHeight.derive(
        .textColor(.white),
        .backgroundColor(.raizlabsRed)
    )
    static let redTxt = lineHeight.derive(
        .textColor(.raizlabsRed)
    )

    static let colorString = NSAttributedString(attributedStrings: [
        gray.attributedString(from: "I want to be different. If everyone is wearing "),
        blackBG.attributedString(from: " black, "),
        gray.attributedString(from: " I want to be wearing "),
        redBG.attributedString(from: " red. \n"),
        redTxt.attributedString(from: "Maria Sharapova "),
        BonMot(.baselineOffset(-4.0), .textColor(.raizlabsRed)).attributedString(from: UIImage(named: "Tennis Racket")!)
        ])


    static let trackingString = BonMot(
        .tracking(.adobe(300)),
        .font(UIFont(name: "Avenir-Book", size: 18)!),
        .adapt(.control)
        ).attributedString(from: "Adults are always asking kids what they want to be when they grow up because they are looking for ideas.\n—Paula Poundstone")

    static let lineHeightString = BonMot(
        .font(UIFont(name: "AmericanTypewriter", size: 17.0)!),
        .lineHeightMultiple(1.8),
        .adapt(.control)
        ).attributedString(from: "I used to love correcting people’s grammar until I realized what I loved more was having friends.\n—Mara Wilson")

    static let proportionalStyle = BonMot(
        .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
        .adapt(.control)
    )

    static let proportionalStrings: [NSAttributedString] = [
        proportionalStyle.derive(
            .fontFeature(NumberSpacing.proportional),
            .fontFeature(NumberCase.upper)
            ).attributedString(from: "Proportional Uppercase\n1111111111\n0123456789"),
        proportionalStyle.derive(
            .fontFeature(NumberSpacing.proportional),
            .fontFeature(NumberCase.lower)
            ).attributedString(from: "Proportional Lowercase\n1111111111\n0123456789"),
        proportionalStyle.derive(
            .fontFeature(NumberSpacing.monospaced),
            .fontFeature(NumberCase.upper)
            ).attributedString(from: "Monospaced Uppercase\n1111111111\n0123456789"),
        proportionalStyle.derive(
            .fontFeature(NumberSpacing.monospaced),
            .fontFeature(NumberCase.lower)
            ).attributedString(from: "Monospaced Lowercase\n1111111111\n0123456789"),
        ]

    static let indentationStrings: [NSAttributedString] = [
        {
            let string = BonMot(
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .adapt(AdaptiveStyle.control)
            ).attributedString(from: UIImage(named: "robot")!)
            string.extend(withTabSpacer: 4.0)
            string.extend(with: "“It’s OK to ask for help. When doing a final exam, all the work must be yours, but in engineering, the point is to get the job done, and people are happy to help. Corollaries: You should be generous with credit, and you should be happy to help others.”")
            return string
        }(),
        {
            let string = BonMot(
                .font(UIFont(name: "AvenirNextCondensed-Regular", size: 18.0)!),
                .textColor(.darkGray),
                .adapt(AdaptiveStyle.control)
            ).attributedString(from: "🍑 →")
            string.extend(withTabSpacer: 4.0)
            string.extend(with: "You can also use strings (including emoji) for bullets as well, and they will still properly indent the appended text by the right amount.")
            return string
        }(),
        {
            let style = BonMot(
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .adapt(AdaptiveStyle.control)
            )
            let appleBullet = style.attributedString(from: "🍑 →")
            appleBullet.extend(withTabSpacer: 4.0)

            var styler = SimpleXMLStyler(tagStyles: TagStyles(styles: ["li": style]))
            styler.add(prefix: appleBullet, forElement: "li")
            styler.add(suffix: NSAttributedString(string: "\n"), forElement: "li")

            let xml = "<li>This row is defined with XML</li><li>Each row is represented with an &lt;li&gt; tag</li><li>Attributed strings define the string to use for bullets</li><li>The text style is also specified for the &lt;li&gt; tags</li>"
            guard let string = try? NSAttributedString(fromXML: xml, styler: styler) else {
                fatalError("Unable to load XML \(xml)")
            }
            return string
        }()
    ]

    static let imageStyle = BonMot(
        .font(UIFont(name: "HelveticaNeue-Bold", size: 24)!),
        .adapt(.control),
        .baselineOffset(8)
    )

    static let imageString = NSMutableAttributedString(attributedStrings: [
        .text("2", style: imageStyle),
        .image(UIImage(named: "bee")!),
        .image(UIImage(named: "oar")!),
        .image(UIImage(named: "knot")!),
        .text("2", style: imageStyle),
        .image(UIImage(named: "bee")!),
    ], separator: imageStyle.attributedString(from: " "))

    static let noSpaceTextStyle = BonMot(
        .font(.systemFont(ofSize: 17)),
        .adapt(.control),
        .textColor(.darkGray),
        .baselineOffset(10)
    )
    static let noSpaceString = NSMutableAttributedString(attributedStrings: [
        ("barn", "This"),
        ("bee", "string"),
        ("bug", "is"),
        ("circuit", "separated"),
        ("cut", "by"),
        ("discount", "images"),
        ("gift", "and"),
        ("pin", "no-break"),
        ("robot", "spaces"),
        ].map() { imageName, text in
            let string = BonMot().attributedString(from: UIImage(named: imageName)!)
            string.extend(with: Special.noBreakSpace.description, style: noSpaceTextStyle)
            string.extend(with: text, style: noSpaceTextStyle)
            return string
    }, separator: .text(" "))

    static let heartsString = NSMutableAttributedString(attributedStrings: (0..<20).makeIterator().map() { i in
        let offset: CGFloat = 15 * sin((CGFloat(i) / 20.0) * 7.0 * CGFloat(M_PI))
        return BonMot(.baselineOffset(offset)).attributedString(from: "❤️")
    })

    static func CustomStoryboard(identifier theIdentifier: String) -> AttributedStringStyle {
        // Embed an attribute for the storyboard identifier to link to. This is
        // a good example of custom attributes, even if this might not be the best
        // UIKit design pattern.
        return BonMot(.initialAttributes(["Storyboard": theIdentifier]))
    }

    static let dynamcTypeUIKit = DemoStrings.CustomStoryboard(identifier: "CatalogViewController")
        .attributedString(from: "Dynamic UIKit elements with custom fonts")
    static let preferredFonts = DemoStrings.CustomStoryboard(identifier: "PreferredFonts")
        .attributedString(from: "Preferred Fonts")
}
