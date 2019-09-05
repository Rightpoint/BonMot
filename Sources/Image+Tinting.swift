//
//  Image+Tinting.swift
//  BonMot
//
//  Created by Zev Eisenberg on 9/28/16.
//  Copyright © 2016 Rightpoint. All rights reserved.
//

import Foundation

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public extension BONImage {

    #if os(OSX)
    /// Returns a copy of the receiver where the alpha channel is maintained,
    /// but every pixel's color is replaced with `color`.
    ///
    /// - note: The returned image does _not_ have the template flag set,
    ///         preventing further tinting.
    ///
    /// - Parameter theColor: The color to use to tint the receiver.
    /// - Returns: A tinted copy of the image.
    @objc(bon_tintedImageWithColor:)
    func tintedImage(color theColor: BONColor) -> BONImage {
        let imageRect = CGRect(origin: .zero, size: size)

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

        let context = NSGraphicsContext.current!.cgContext

        context.setBlendMode(.normal)
        let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        context.draw(cgImage, in: imageRect)

        // .sourceIn: resulting color = source color * destination alpha
        context.setBlendMode(.sourceIn)
        context.setFillColor(theColor.cgColor)
        context.fill(imageRect)

        image.unlockFocus()

        // Prevent further tinting
        image.isTemplate = false

        // Transfer accessibility description
        image.accessibilityDescription = self.accessibilityDescription

        return image
    }
    #else
    /// Returns a copy of the receiver where the alpha channel is maintained,
    /// but every pixel's color is replaced with `color`.
    ///
    /// - note: The returned image does _not_ have the template flag set,
    ///         preventing further tinting.
    ///
    /// - Parameter theColor: The color to use to tint the receiver.
    /// - Returns: A tinted copy of the image.
    @objc(bon_tintedImageWithColor:)
    func tintedImage(color theColor: BONColor) -> BONImage {
        let imageRect = CGRect(origin: .zero, size: size)
        // Save original properties
        let originalCapInsets = capInsets
        let originalResizingMode = resizingMode
        let originalAlignmentRectInsets = alignmentRectInsets

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

        // Prevent further tinting
        image = image.withRenderingMode(.alwaysOriginal)

        // Restore original properties
        image = image.withAlignmentRectInsets(originalAlignmentRectInsets)
        if originalCapInsets != image.capInsets || originalResizingMode != image.resizingMode {
            image = image.resizableImage(withCapInsets: originalCapInsets, resizingMode: originalResizingMode)
        }

        // Transfer accessibility label (watchOS not included; does not have accessibilityLabel on UIImage).
        #if os(iOS) || os(tvOS)
            image.accessibilityLabel = self.accessibilityLabel
        #endif

        return image
    }
    #endif

}
