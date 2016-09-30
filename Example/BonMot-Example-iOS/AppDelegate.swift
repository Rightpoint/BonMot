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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : UIApplicationLaunchOptionsValue]? = nil) -> Bool {
        style()
        window?.makeKeyAndVisible()
        application.enableAdaptiveContentSizeMonitor()
        return true
    }

    func style() {
        // Use UIAppearance to configure the font scaling table approach showcased in WWDC 2016 Session 803

        UINavigationBar.appearance().titleTextAttributes = Style().attributes()

        let barStyle = BonMot(.font(UIFont.appFont(ofSize: 17)), .adapt(.control))
        UIBarButtonItem.appearance().setTitleTextAttributes(barStyle.attributes(), for: .normal)
    }

}
