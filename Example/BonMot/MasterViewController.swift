//
//  MasterViewController.swift
//
//  Created by Brian King on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

// UITableViewCell built in labels are re-created when the content size category changes so we use a proper cell subclass.
class MasterTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel?
}

class MasterViewController: UITableViewController {

    weak var timer: NSTimer? {
        didSet {
            timerItem.title = timer == nil ? "Repeat" : "Stop"
        }
    }
    lazy var timerItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Repeat", style: .Plain, target: self, action: #selector(MasterViewController.continuallyChangeContentSizeCategory))
    }()
    override var toolbarItems: [UIBarButtonItem]? {
        get {
            return [
                UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(MasterViewController.nextContentSizeCategory)),
                UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
                timerItem
            ]
        }
        set {}
    }
    var detailViewController: DetailViewController? = nil
    var commentaries: [Commentary] = [
        Commentary(
            heading: "UIKit Catalog (Avenir Fonts)",
            action: #selector(MasterViewController.showCatalog)),
        Commentary(
            heading: "Default Preferred Fonts",
            action: #selector(MasterViewController.showPreferred)),
        Commentary(
            heading: "Style",
            action: #selector(MasterViewController.showStyle)),
        Commentary(
            heading: "All text should scale",
            body: "All text in the application should get larger and smaller when dynamic type changes. Remember to test various sizes on occasion!",
            footnote: "Even if the code is old uses fixed heights"),
        Commentary(
            heading: "Primary Text",
            body: "The primary text that the user is reading should continue to scale into the accessibility ranges. This can look a little rediculous on the 4s, but it's better than zooming.",
            footnote: "As a developer, you can also chose not to."),
        Commentary(
            heading: "Control Text",
            body: "Text used for buttons and other controls do not need to scale in the accessibility ranges. The back button isn't expected to get",
            footnote: ""),
        Commentary(
            heading: "When the height can not change",
            body: "If you have a UI element where the height of the element can not change, use adjustsFontSizeToFitWidth or other tricks to ensure the text remains legible",
            footnote: ""),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    func showCatalog() {
        guard let catalog = storyboard?.instantiateViewControllerWithIdentifier("CatalogViewController") else { fatalError("No CatalogViewController") }
        self.navigationController?.pushViewController(catalog, animated: true)
    }

    func showPreferred() {
        guard let catalog = storyboard?.instantiateViewControllerWithIdentifier("PreferredFonts") else { fatalError("No PreferredFonts") }
        self.navigationController?.pushViewController(catalog, animated: true)
    }

    func showStyle() {
        guard let catalog = storyboard?.instantiateViewControllerWithIdentifier("StyleViewController") else { fatalError("No PreferredFonts") }
        self.navigationController?.pushViewController(catalog, animated: true)
    }

    func showInfo(commentary: Commentary) {
        guard let detail = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController else { fatalError("No DetailViewController") }
        detail.commentary = commentary
        self.navigationController?.pushViewController(detail, animated: true)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentaries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MasterTableViewCell

        cell.titleLabel?.text = commentaries[indexPath.row].heading
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let commentary = commentaries[indexPath.row]
        switch commentary.detail {
        case .Info:
            showInfo(commentary)
        case let .Action(selector):
            self.performSelector(selector)
        }
    }

    @IBAction func nextContentSizeCategory() {
        self.timer?.invalidate()
        self.timer = nil
        UIApplication.sharedApplication().selectNextContentSizeCategory()
    }

    @IBAction func continuallyChangeContentSizeCategory() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        else {
            timer = NSTimer.scheduledTimerWithTimeInterval(
                0.5,
                target: UIApplication.sharedApplication(),
                selector: #selector(UIApplication.selectNextContentSizeCategory),
                userInfo: nil,
                repeats: true
            )
        }
    }

}
