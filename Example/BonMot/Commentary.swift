//
//  Commentary.swift
//
//  Created by Brian King on 7/25/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

class Commentary: NSObject {
    enum Detail {
        case Info(body: String, footnote: String)
        case Action(selector: Selector)
    }

    let heading: String
    let detail: Detail
    init(heading: String, body: String, footnote: String) {
        self.heading = heading
        self.detail = Detail.Info(body: body, footnote: footnote)
    }
    init(heading: String, action: Selector) {
        self.heading = heading
        self.detail = Detail.Action(selector: action)
    }
}

