//
//  StyleAttributeProviderHolder.swift
//
//  Created by Brian King on 8/23/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

/// Simple holder class so style objects can be held in Obj-C containers.
internal class StyleAttributeProviderHolder: NSObject {

    let style: StyleAttributeProvider
    init(style: StyleAttributeProvider) {
        self.style = style
    }
}
