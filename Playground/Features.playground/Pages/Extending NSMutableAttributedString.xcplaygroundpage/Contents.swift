/*:
 # Extending NSMutableAttributedString
 Extending NSMutableAttributedString is similar to appending, except that the attributes at the end of the string are reused.

 */

import UIKit
import BonMot

//: Define the base style
let style = BonMotC() { style in
    style.font = UIFont(name: "GillSans-Light", size: 20)
    style.lineHeightMultiple = 1.8
    style.color = .darkGray
}

let quote = style.attributedString(from: "I want to be different.")
//: Extend this attributed string. This will reuse the style at the end of the string, unlike append
quote.extend(with: " If everyone is wearing ")

//: Extend the string and specify a font, color and backgroundColor. This will override the font and color of the original style, but preserve the lineHeightMultiple
quote.extend(with: " black, ", style: BonMot(.font(UIFont(name: "SuperClarendon-Black", size: 20)!), .color(.white), .backgroundColor(.black)))

//: Append the string with the specified attributes. This will only use the attributes that are specified.
quote.append(NSAttributedString(string: " I want to be wearing ", attributes: style.attributes()))

quote.extend(with: " red.", style: BonMot(.font(UIFont(name: "SuperClarendon-Black", size: 20)!), .color(.white), .backgroundColor(.raizlabsRed)))

quote.append(NSAttributedString(string: "\n Maria Sharapova ", attributes: BonMot(.font(UIFont(name: "SuperClarendon-Black", size: 20)!), .color(.raizlabsRed)).attributes()))
quote.extend(with: UIImage(named: "Tennis Racket")!, style: BonMot(.color(.white), .baselineOffset(-4)))
