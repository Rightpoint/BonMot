//
//  StyleViewController.swift
//
//  Created by Brian King on 8/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

// UITableViewCell built in labels are re-created when the content size category changes so we use a proper cell subclass.
class MasterTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel?
}

class StyleViewController: UITableViewController {
    var styles: [(String, [NSAttributedString])] = [
        ("Color", [DemoStrings.colorString]),
        ("Images", [DemoStrings.imageString, DemoStrings.noSpaceString, DemoStrings.heartsString]),
        ("Indentation", DemoStrings.indentationStrings),
        ("Figure Style", DemoStrings.proportionalStrings),
        ("Tracking", [DemoStrings.trackingString]),
        ("Line Height", [DemoStrings.lineHeightString]),
        ("Dynamic Type", [DemoStrings.dynamcTypeUIKit, DemoStrings.preferredFonts]),
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
        cell.accessoryType = attributedText.attribute("Storyboard", atIndex: 0, effectiveRange: nil) == nil ? .None : .DisclosureIndicator
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return styles[section].0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let attributedText = styles[indexPath.section].1[indexPath.row]
        if let storyboardIdentifier = attributedText.attribute("Storyboard", atIndex: 0, effectiveRange: nil) as? String {
            guard let nextVC = storyboard?.instantiateViewControllerWithIdentifier(storyboardIdentifier) else {
                fatalError("No Storyboard identifier \(storyboardIdentifier)")
            }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
