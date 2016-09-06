//
//  Helpers.swift
//
//  Created by Brian King on 8/29/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

extension UIColor {
    static var colorA: UIColor {
        return redColor()
    }
    static var colorB: UIColor {
        return redColor()
    }
}

extension UIFont {
    static var fontA: UIFont {
        return UIFont(name: "Avenir-Roman", size: 30)!
    }
    static var fontB: UIFont {
        return UIFont(name: "Avenir-Roman", size: 20)!
    }
}


let styleA = BonMot(
    .font(.fontA),
    .textColor(.colorA)
)

let styleB = BonMot(
    .font(.fontB),
    .textColor(.colorB),
    .headIndent(10),
    .tailIndent(10)
)

let adaptiveStyle = BonMot(
    .font(.fontA),
    .textColor(.colorA),
    .adapt(.body)
)

let styleBi = BonMotI(
    font: .fontB,
    textColor: .colorB,
    headIndent: 10,
    tailIndent: 10
)

let styleBz = BonMotZ { style in
    style.font = .fontB
    style.textColor = .colorB
    style.headIndent = 10
    style.tailIndent = 10
}

class EBGarandLoader: NSObject {
    static var token: dispatch_once_t = 0

    // Can't include font the normal (Plist) way for logic tests, so load it the hard way
    // Source: http://stackoverflow.com/questions/14735522/can-i-embed-a-custom-font-in-a-bundle-and-access-it-from-an-ios-framework
    // Method: https://marco.org/2012/12/21/ios-dynamic-font-loading
    static func loadFontIfNeeded() {
        dispatch_once(&token) {
            guard let path = NSBundle(forClass: EBGarandLoader.self).pathForResource("EBGaramond12-Regular", ofType: "otf"),
                let data = NSData(contentsOfFile: path)
                else {
                    fatalError("Can not load EBGaramond12")
            }
            guard let provider = CGDataProviderCreateWithCFData(data) else {
                fatalError("Can not create provider")
            }

            #if swift(>=2.3)
                let fontRef = CGFontCreateWithDataProvider(provider)
            #else
                guard let fontRef = CGFontCreateWithDataProvider(provider) else {
                    fatalError("Can not create CGFont")
                }
            #endif
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterGraphicsFont(fontRef, &error)
            if let error = error {
                fatalError("Unable to load font: \(error)")
            }
        }
    }
}

extension NSAttributedString {

    func attributeValuesByRanges<T>(name: String) -> [String: T] {
        var attributesByRange: [String: T] = [:]
        enumerateAttribute(name, inRange: NSRange(location: 0, length: length), options: []) { value, range, stop in
            if let object = value as? T {
                attributesByRange["\(range.location):\(range.length)"] = object
            }
        }
        return attributesByRange
    }

}
