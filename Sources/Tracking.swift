//
//  Tracking.swift
//  BonMot
//
//  Created by Brian King on 9/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import CoreGraphics

/// An enumeration representing the tracking to be applied.
public enum Tracking {

    case point(CGFloat)
    case adobe(CGFloat)

    public func kerning(for font: BONFont?) -> CGFloat {
        switch self {
        case .point(let kernValue):
            return kernValue
        case .adobe(let adobeTracking):
            let AdobeTrackingDivisor: CGFloat = 1000.0
            if font == nil {
                print("Can not apply tracking to style when no font is defined, using 0 instead")
            }
            let pointSize = font?.pointSize ?? 0
            return pointSize * (adobeTracking / AdobeTrackingDivisor)
        }
    }

}
