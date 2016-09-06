//
//  DetailViewController.swift
//
//  Created by Brian King on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

class DetailViewController: UIViewController {

    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var commentary: Commentary? {
        didSet { configureView() }
    }

    func configureView() {
        guard let commentary = commentary else { return }

        // Update the user interface for the detail item.
        if case .Info(let body, _) = commentary.detail {
            if isViewLoaded() {
                titleDescriptionLabel.text = commentary.heading
                detailDescriptionLabel.text = body
            }
        }
    }

    // Configuring the transformation style outside of the storyboard
    override func viewDidLoad() {
        super.viewDidLoad()
        // When configuring the style name, the current font configured on the label is added to the style chain
        titleDescriptionLabel.bonMotStyleName = "control"
        detailDescriptionLabel.bonMotStyle = BonMot(.font(.systemFontOfSize(17)), .adapt(.body))

        configureView()
    }

}

