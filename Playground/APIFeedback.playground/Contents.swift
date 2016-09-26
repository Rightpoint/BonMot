// Open via BonMot.xcworkspace and build the BonMot-iOS target if the playground does not work.

import UIKit
import BonMot

let noSpaceStyle = BonMot(
    .font(.systemFont(ofSize: 17)),
    .adapt(.control),
    .textColor(.darkGray)
)

let noSpaceString = NSMutableAttributedString(attributedStrings: [
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
        let string = BonMot(.baselineOffset(-10)).attributedString(from: UIImage(named: imageName)!)
        string.extend(with: text, style: noSpaceStyle)
        return string
}, separator: .text(Special.noBreakSpace.description))
