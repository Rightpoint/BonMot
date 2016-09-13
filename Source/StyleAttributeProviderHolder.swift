    //
//  StyleAttributeProviderHolder.swift
//
//  Created by Brian King on 8/23/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

/// Simple holder class so style objects can be held in Obj-C containers.
@objc(BONStyleAttributeProviderHolder)
public class StyleAttributeProviderHolder: NSObject {

    let style: StyleAttributeProvider
    init(style: StyleAttributeProvider) {
        self.style = style
    }

    public static var supportWarningClosure: () -> Void = {
        print("BonMot adaptive style does not support NSCoding. Reconfigure the attributed string programatically to restore adaptive style support.")
    }

    private static var supportWarning: Void = {
        return supportWarningClosure()
    }()

    public func encodeWithCoder(aCoder: NSCoder) {}
    required public init?(coder aDecoder: NSCoder) {
        self.style = BonMot()
        super.init()
        let _ = StyleAttributeProviderHolder.supportWarning
    }

}
