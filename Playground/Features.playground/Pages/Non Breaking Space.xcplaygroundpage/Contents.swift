/*:
 # Non Breaking Space
 A non breaking space is a text character that appears like a space, but that word wrapping will not break.

 The example below uses this feature in conjunction with inline images to represent a collection of paired images and text.
 */

import UIKit
import BonMot

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
        // Create the image
        let string = BonMot().attributedString(from: BONImage(named: imageName)!)
        // Create a style for the text and shift the baseline up by 10 to align with the images
        let textStyle = BonMot(
            .font(.systemFont(ofSize: 17)),
            .color(.darkGray),
            .baselineOffset(10)
        )
        // Add the non breaking space
        string.extend(with: Special.noBreakSpace.description, style: textStyle)
        // Add the text
        string.extend(with: text, style: textStyle)
        return string
}, separator: .text(" "))

/*:
 Resize the inline rendering to explore how the word wrap behavior is changed by the non breaking space.

 [Next](@next)
 */
