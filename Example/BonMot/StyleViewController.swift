//
//  StyleViewController.swift
//
//  Created by Brian King on 8/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

class StyleViewController: UITableViewController {
    var styles: [(String, [NSAttributedString])] = [
        ("Color", [DemoStrings.colorString]),
        ("Images", [DemoStrings.imageString, DemoStrings.noSpaceString, DemoStrings.heartsString]),
        ("Indentation", DemoStrings.indentationStrings),
        ("Figure Style", DemoStrings.proportionalStrings),
        ("Tracking", [DemoStrings.trackingString]),
        ("Line Height", [DemoStrings.lineHeightString]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
}

extension StyleViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return styles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles[section].1.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("StyleCell", forIndexPath: indexPath) as? MasterTableViewCell else {
            fatalError("Misconfigured VC")
        }
        let attributedText = styles[indexPath.section].1[indexPath.row]
        cell.titleLabel?.attributedText = attributedText
        print("[\(indexPath.section):\(indexPath.row)] = \(attributedText.debugRepresentation)")
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return styles[section].0
    }
}
