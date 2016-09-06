//
//  DemoStrings.swift
//
//  Created by Brian King on 8/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BonMot

enum DemoStrings {
    static let lineHeight = BonMotZ({ style in
        style.font = UIFont(name: "SuperClarendon-Black", size: 20)!
        style.lineHeightMultiple = 1.8
    })

    static let gray = lineHeight.configure { style in
        style.font = UIFont(name: "GillSans-Light", size: 20)!
        style.textColor = .darkGrayColor()
    }
    static let blackBG = lineHeight.configure(
        .textColor(.whiteColor()),
        .backgroundColor(.blackColor())
    )

    static let redBG = lineHeight.configure(
        .textColor(.whiteColor()),
        .backgroundColor(.redColor())
    )
    static let redTxt = lineHeight.configure(
        .textColor(.redColor())
    )

    static let colorString = NSAttributedString(attributedStrings: [
        gray.append(string: "I want to be different. If everyone is wearing "),
        blackBG.append(string: " black, "),
        gray.append(string: " I want to be wearing "),
        redBG.append(string: " red. \n"),
        redTxt.append(string: "Maria Sharapova "),
        BonMot(.baselineOffset(-4.0), .textColor(.redColor())).append(image: UIImage(named: "Tennis Racket")!)
        ])


    static let trackingString = BonMot(
        .tracking(.adobe(300)),
        .font(UIFont(name: "Avenir-Book", size: 18)!)
        )
        .append(string: "Adults are always asking kids what they want to be when they grow up because they are looking for ideas.\n—Paula Poundstone")

    static let lineHeightString = BonMot(
        .font(UIFont(name: "AmericanTypewriter", size: 17.0)!),
        .lineHeightMultiple(1.8)
        ).append(string: "I used to love correcting people’s grammar until I realized what I loved more was having friends.\n—Mara Wilson")

    static let proportionalStrings: [NSAttributedString] = [
        BonMot(
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
            .fontFeature(NumberSpacing.proportional),
            .fontFeature(NumberCase.upper)
            ).append(string: "Proportional Uppercase\n1111111111\n0123456789"),
        BonMot(
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
            .fontFeature(NumberSpacing.proportional),
            .fontFeature(NumberCase.lower)
            ).append(string: "Proportional Lowercase\n1111111111\n0123456789"),
        BonMot(
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
            .fontFeature(NumberSpacing.monospaced),
            .fontFeature(NumberCase.upper)
            ).append(string: "Monospaced Uppercase\n1111111111\n0123456789"),
        BonMot(
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
            .fontFeature(NumberSpacing.monospaced),
            .fontFeature(NumberCase.lower)
            ).append(string: "Monospaced Lowercase\n1111111111\n0123456789"),
        ]

    static let indentationStrings: [NSAttributedString] = [
        BonMot(.font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!)
            ).append(image: UIImage(named: "robot")!)
            .append(tabStopWithSpacer: 4.0)
            .append(string: "“It’s OK to ask for help. When doing a final exam, all the work must be yours, but in engineering, the point is to get the job done, and people are happy to help. Corollaries: You should be generous with credit, and you should be happy to help others.”")
            ,
        BonMot(.font(UIFont(name: "AvenirNextCondensed-Regular", size: 18.0)!),
            .textColor(.darkGrayColor())
            ).append(string: "🍑 →")
            .append(tabStopWithSpacer: 4.0)
            .append(string: "You can also use strings (including emoji) for bullets as well, and they will still properly indent the appended text by the right amount."),
    ]
    static let imageStyle = BonMot(
        .font(UIFont(name: "HelveticaNeue-Bold", size: 24)!),
        .baselineOffset(8)
    )

    static let imageString = NSMutableAttributedString(attributedStrings: [
        imageStyle.append(string: "2"),
        NSAttributedString(image: UIImage(named: "bee")!),
        NSAttributedString(image: UIImage(named: "oar")!),
        NSAttributedString(image: UIImage(named: "knot")!),
        imageStyle.append(string: "2"),
        NSAttributedString(image: UIImage(named: "bee")!),
    ], separator: imageStyle.append(string: " "))

    static let noSpaceStyle = BonMot(
        .font(.systemFontOfSize(17)),
        .textColor(.darkGrayColor())
    )
    static let noSpaceImageStyle = BonMot(.baselineOffset(-10))

    static let noSpaceString = NSMutableAttributedString(attributedStrings: [
        (UIImage(named: "barn")!, "This"),
        (UIImage(named: "bee")!, "string"),
        (UIImage(named: "bug")!, "is"),
        (UIImage(named: "circuit")!, "separated"),
        (UIImage(named: "cut")!, "by"),
        (UIImage(named: "discount")!, "images"),
        (UIImage(named: "gift")!, "and"),
        (UIImage(named: "pin")!, "no-break"),
        (UIImage(named: "robot")!, "spaces"),
        ].map() { image, text in
            return noSpaceImageStyle.append(image: image).append(string: text, style: noSpaceStyle)
        }, separator: noSpaceStyle.append(string: "\u{2003}"))

    static let heartsString = NSMutableAttributedString(attributedStrings: (0..<20).generate().map() { i in
        let offset: CGFloat = 15 * sin((CGFloat(i) / 20.0) * 7.0 * CGFloat(M_PI))
        return BonMot(.baselineOffset(offset)).append(string: "❤️")
    })

}
