//
//  OptionalAsArray.swift
//  BonMot
//
//  Created by Zev Eisenberg on 11/3/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

internal extension Optional {

    /// If `self` is `.none`, returns the empty array. Otherwise, returns
    /// an array containing only the wrapped value.
    internal var asArray: [Wrapped] {
        #if swift(>=3.0)
            switch self {
            case .some(let wrapped): return [wrapped]
            case .none: return []
            }
        #else
            switch self {
            case .Some(let wrapped): return [wrapped]
            case .None: return []
            }
        #endif
    }
}
