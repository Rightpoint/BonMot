//
//  AppDelegate.swift
//
//  Created by Brian King on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : UIApplicationLaunchOptionsValue]? = nil) -> Bool {
        style()
        window?.makeKeyAndVisible()
        application.enableAdaptiveContentSizeMonitor()
        return true
    }

    func style() {
        guard let traitCollection = window?.traitCollection else {
            fatalError("There should be a traitCollection available before calling this method.")
        }
        let titleStyle = AttributedStringStyle.style(
            .font(UIFont.appFont(ofSize: 20)),
            .adapt(.control)
        )
        UINavigationBar.appearance().titleTextAttributes = titleStyle.attributes(adaptedTo: traitCollection)
        let barStyle = AttributedStringStyle.style(
            .font(UIFont.appFont(ofSize: 17)),
            .adapt(.control)
        )
        UIBarButtonItem.appearance().setTitleTextAttributes(barStyle.attributes(adaptedTo: traitCollection), for: .normal)
    }

}

extension UIColor {
    static var raizlabsRed: UIColor {
        return UIColor(red: 0.927, green: 0.352, blue: 0.303, alpha: 1.0)
    }
}

extension UIFont {

    static func appFont(ofSize pointSize: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Roman", size: pointSize)!
    }

}
