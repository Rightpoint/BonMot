//
//  ImageTintingTests.swift
//  BonMot
//
//  Created by Zev Eisenberg on 9/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

import XCTest
import BonMot

class ImageTintingTests: XCTestCase {

    func testImageTinting() {
        let blackImageName = "rz-logo-black"
        let redImageName = "rz-logo-red"

        #if os(OSX)
            // Mac tests disabled because there is weirdness with color spaces and
            // getting the tests to pass.

            let raizlabsRed = NSColor(deviceRed: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
//            let sourceImage = testBundle.image(forResource: blackImageName)!
//            let controlTintedImage = testBundle.image(forResource: redImageName)!
//            let testTintedImage = sourceImage.tintedImage(color: raizlabsRed)

            // Dummy variables to get the tests to pass:
            let controlTintedImage = testBundle.image(forResource: blackImageName)!.tintedImage(color: raizlabsRed)
            let testTintedImage = controlTintedImage
        #else
            let raizlabsRed = UIColor(red: 0.92549, green: 0.352941, blue: 0.301961, alpha: 1.0)
            let sourceImage = UIImage(named: blackImageName, in: testBundle, compatibleWith: nil)!
            let controlTintedImage = UIImage(named: redImageName, in: testBundle, compatibleWith: nil)!
            let testTintedImage = sourceImage.tintedImage(color: raizlabsRed)
        #endif

        BONAssertEqualImages(controlTintedImage, testTintedImage)
    }

    #if os(OSX)
    #else
    func testDemonstrateUIKitTintingBug() {
        let attachment = NSTextAttachment()

        // image must be set to Template rendering mode
        attachment.image = UIImage(named: "discount", in: testBundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)

        let withNBSP = NSMutableAttributedString(string: BonMot.Special.noBreakSpace.description)
        let withoutNBSP = NSMutableAttributedString(string: "")

        let attachmentString = NSAttributedString(attachment: attachment)

        withNBSP.append(attachmentString)
        withoutNBSP.append(attachmentString)

        let color = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        withNBSP.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: 0, length: withNBSP.length))
        withoutNBSP.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: 0, length: withoutNBSP.length))

        let images = [withNBSP, withoutNBSP].map { attrString -> BONImage in
            let label = UILabel()
            label.attributedText = attrString
            label.sizeToFit()
            label.backgroundColor = .white
            return label.testingSnapshot()
        }

        // Demonstrate that UIKit will tint the image, but only if there is
        // at least one character in the string before the attachment.
        // See details at https://github.com/Raizlabs/BonMot/issues/105
        BONAssertNotEqualImages(images[0], images[1])

        // Uncomment these lines and enter your username to see the images for yourself:
//        let username = "your-username-goes-here"
//
//        do {
//            try UIImagePNGRepresentation(images[0])!.write(to: URL(fileURLWithPath: "/Users/\(username)/Desktop/withNBSP.png"))
//            try UIImagePNGRepresentation(images[1])!.write(to: URL(fileURLWithPath: "/Users/\(username)/Desktop/withoutNBSP.png"))
//        }
//        catch {
//            XCTFail("failed to write images. Did you remember to put the name of your home folder in the path? \(error)")
//        }
    }
    #endif

}
