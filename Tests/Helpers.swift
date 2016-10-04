//
//  Helpers.swift
//
//  Created by Brian King on 8/29/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import BonMot
import XCTest

#if os(OSX)
#else
    import UIKit
    #if swift(>=3.0)
        let titleTextStyle = UIFontTextStyle.title1
        let differentTextStyle = UIFontTextStyle.title2
        @available(iOS 10.0, *)
        let largeTraitCollection = UITraitCollection(preferredContentSizeCategory: .large)
    #elseif swift(>=2.3)
        let titleTextStyle = UIFontTextStyleTitle1
        let differentTextStyle = UIFontTextStyleTitle2
        @available(iOS 10.0, *)
        let largeTraitCollection = UITraitCollection(preferredContentSizeCategory: UIContentSizeCategoryLarge)
    #else
        let titleTextStyle = UIFontTextStyleTitle1
        let differentTextStyle = UIFontTextStyleTitle2
     #endif
#endif

#if swift(>=3.0)
    extension BONColor {
        static var colorA: BONColor {
            return red
        }
        static var colorB: BONColor {
            return blue
        }
        static var colorC: BONColor {
            return purple
        }
    }
#else
    extension BONColor {
        static var colorA: BONColor {
            return redColor()
        }
        static var colorB: BONColor {
            return blueColor()
        }
        static var colorC: BONColor {
            return purpleColor()
        }
    }
#endif

extension BONFont {
    static var fontA: BONFont {
        return BONFont(name: "Avenir-Roman", size: 30)!
    }
    static var fontB: BONFont {
        return BONFont(name: "Avenir-Roman", size: 20)!
    }
}

let styleA = AttributedStringStyle.style(
    .font(.fontA),
    .color(.colorA)
)

let styleB = AttributedStringStyle.style(
    .font(.fontB),
    .color(.colorB),
    .headIndent(10),
    .tailIndent(10)
)

#if os(OSX)
#else
let adaptiveStyle = AttributedStringStyle.style(
    .font(.fontA),
    .color(.colorA),
    .adapt(.body)
)
#endif

let styleBz = AttributedStringStyle.style(
    .font(.fontB),
    .color(.colorB),
    .headIndent(10),
    .tailIndent(10)
)

let fullStyle: AttributedStringStyle = {
    let terribleValue = CGFloat(1000000)
    var fullStyle = AttributedStringStyle()
    fullStyle.font = BONFont(name: "Copperplate", size: 20)
    fullStyle.link = NSURL(string: "http://www.raizlabs.com/")
    fullStyle.backgroundColor = .colorC
    fullStyle.color = .colorC

    fullStyle.underline = (.byWord, .colorC)
    fullStyle.strikethrough = (.byWord, .colorC)

    fullStyle.baselineOffset = terribleValue

    fullStyle.lineSpacing = terribleValue

    fullStyle.paragraphSpacingAfter = terribleValue
    fullStyle.alignment = .left
    fullStyle.firstLineHeadIndent = terribleValue
    fullStyle.headIndent = terribleValue
    fullStyle.tailIndent = terribleValue
    fullStyle.lineBreakMode = .byTruncatingMiddle
    fullStyle.minimumLineHeight = terribleValue
    fullStyle.maximumLineHeight = terribleValue
    fullStyle.baseWritingDirection = .rightToLeft
    fullStyle.lineHeightMultiple = terribleValue
    fullStyle.paragraphSpacingBefore = terribleValue
    fullStyle.hyphenationFactor = Float(terribleValue)

    #if os(iOS) || os(tvOS) || os(OSX)
        fullStyle.fontFeatureProviders = [NumberCase.upper, NumberCase.upper, NumberCase.upper, NumberCase.upper]
    #endif
    #if os(iOS) || os(tvOS)
        fullStyle.adaptations = [.preferred, .control, .body]
    #endif
    fullStyle.tracking = .adobe(terribleValue)
    return fullStyle
}()

class EBGaramondLoader: NSObject {

    static func loadFontIfNeeded() {
        let _ = loadFont
    }

    // Can't include font the normal (Plist) way for logic tests, so load it the hard way
    // Source: http://stackoverflow.com/questions/14735522/can-i-embed-a-custom-font-in-a-bundle-and-access-it-from-an-ios-framework
    // Method: https://marco.org/2012/12/21/ios-dynamic-font-loading
    private static var loadFont: Void = {
        #if swift(>=3.0)
        guard let path = Bundle(for: EBGaramondLoader.self).path(forResource: "EBGaramond12-Regular", ofType: "otf"),
            let data = NSData(contentsOfFile: path)
            else {
                fatalError("Can not load EBGaramond12")
        }
        guard let provider = CGDataProvider(data: data) else {
            fatalError("Can not create provider")
        }

        #if swift(>=2.3)
            let fontRef = CGFont(provider)
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
        #else
            guard let path = NSBundle(forClass: EBGaramondLoader.self).pathForResource("EBGaramond12-Regular", ofType: "otf"),
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
        #endif
        return ()
    }()
}

extension NSAttributedString {

    func rangesFor<T>(attribute name: String) -> [String: T] {
        var attributesByRange: [String: T] = [:]
        enumerateAttribute(name, in: NSRange(location: 0, length: length), options: []) { value, range, stop in
            if let object = value as? T {
                attributesByRange["\(range.location):\(range.length)"] = object
            }
        }
        return attributesByRange
    }

}

extension BONView {
    func testingSnapshot() -> BONImage {
        #if os(OSX)
            let dataOfView = dataWithPDF(inside: bounds)
            let image = NSImage(data: dataOfView)!
            return image
        #else
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        #endif
    }
}

#if swift(>=3.0)
#else
extension XCTestCase {
    func measure(block: () -> Void) {
        measureBlock(block)
    }
}
#endif
