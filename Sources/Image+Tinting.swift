//
//  Image+Tinting.swift
//  BonMot
//
//  Created by Zev Eisenberg on 9/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public extension BONImage {

    @objc(bon_tintedImageWithColor:)

    func tintedImage(color theColor: BONColor) -> BONImage {

        // Save original properties
        #if os(OSX)
            let originalTemplate = isTemplate
        #else
            let originalCapInsets = capInsets
            let originalResizingMode = resizingMode
            let originalAlignmentRectInsets = alignmentRectInsets
        #endif

        let imageRect = CGRect(origin: .zero, size: size)

        // Create image context
        #if os(OSX)
            let image = NSImage(size: size)

            let rep = NSBitmapImageRep(
                bitmapDataPlanes: nil,
                pixelsWide: Int(size.width),
                pixelsHigh: Int(size.height),
                bitsPerSample: 8,
                samplesPerPixel: 4,
                hasAlpha: true,
                isPlanar: false,
                colorSpaceName: theColor.colorSpaceName,
                bytesPerRow: 0,
                bitsPerPixel: 0
                )!

            image.addRepresentation(rep)

            image.lockFocus()

            let context = NSGraphicsContext.current()?.cgContext
            precondition(context != nil)

            context?.setBlendMode(.normal)
            let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil)!
            context?.draw(cgImage, in: imageRect)

            // .sourceIn: resulting color = source color * destination alpha
            context?.setBlendMode(.sourceIn)
            context?.setFillColor(theColor.cgColor)
            context?.fill(imageRect)

            image.unlockFocus()

            // Restore original properties
            image.isTemplate = originalTemplate

            return image
        #else
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            let context = UIGraphicsGetCurrentContext()!
            // Flip the context vertically
            context.translateBy(x: 0.0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)

            // Image tinting mostly inspired by http://stackoverflow.com/a/22528426/255489

            context.setBlendMode(.normal)
            context.draw(cgImage!, in: imageRect)

            // .sourceIn: resulting color = source color * destination alpha
            context.setBlendMode(.sourceIn)
            context.setFillColor(theColor.cgColor)
            context.fill(imageRect)

            // Get new image
            var image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            // Restore original properties
            image = image.withAlignmentRectInsets(originalAlignmentRectInsets)
            if !UIEdgeInsetsEqualToEdgeInsets(originalCapInsets, image.capInsets) || originalResizingMode != image.resizingMode {
                image = image.resizableImage(withCapInsets: originalCapInsets, resizingMode: originalResizingMode)
            }

            return image
        #endif
    }

}
