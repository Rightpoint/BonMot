//
//  AppDelegate.swift
//
//  Created by Brian King on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        style()

        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        window?.makeKeyAndVisible()
        application.enableAdaptiveContentSizeMonitor()
// Uncomment to generate plots
//        Plotter.generateGNUPlots()
        return true
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.commentary == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

    func style() {
        let traitCollection = UIApplication.sharedApplication().keyWindow?.traitCollection
        // Use UIAppearance to configure the font scaling table approach showcased in WWDC 2016 Session 803

        UINavigationBar.appearance().titleTextAttributes = Style().styleAttributes(traitCollection: traitCollection)

        let barStyle = BonMot(.font(UIFont.appFontOfSize(17)), .adapt(.control))
        UIBarButtonItem.appearance().setTitleTextAttributes(barStyle.styleAttributes(traitCollection: traitCollection), forState: .Normal)
    }

}

