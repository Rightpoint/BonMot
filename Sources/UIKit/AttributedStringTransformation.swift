//
//  AttributedStringTransformation.swift
//  BonMot
//
//  Created by Brian King on 9/28/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

protocol AttributedStringTransformation {
    func update(string theString: NSMutableAttributedString, in range: NSRange)
}

extension Tab: AttributedStringTransformation {
    // Implementation is already defined and used even if the conformance is not needed.
}
