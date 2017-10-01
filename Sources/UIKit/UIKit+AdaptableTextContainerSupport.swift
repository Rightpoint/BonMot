//
//  UIKit+AdaptableTextContainerSupport.swift
//  BonMot
//
//  Created by Brian King on 7/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

extension UIApplication {

    /// Support for the `AdaptableTextContainer` protocol is enabled with this
    /// method. It adds the application as an observer for `UIContentSizeCategoryDidChangeNotification`
    /// and floods the change notification to the `UIViewController` hierarchy,
    /// which by default floods the view managed by each `UIViewController`.
    ///
    /// The `UIApplication` delegate is also checked for conformance to
    /// `AdaptableTextContainer`, which can be a good place to update appearance
    /// proxies and invalidate any hard-wired caches that less responsive code may have.
    public final func enableAdaptiveContentSizeMonitor() {
        let notificationCenter = NotificationCenter.default
        let notificationName = NSNotification.Name.UIContentSizeCategoryDidChange
        notificationCenter.addObserver(
            self,
            selector: #selector(UIApplication.bon_notifyContainedAdaptiveContentSizeContainers(fromNotification:)),
            name: notificationName,
            object: nil)
    }

    // Notify the view controller hierarchy.
    @objc internal func bon_notifyContainedAdaptiveContentSizeContainers(fromNotification notification: NSNotification) {
        // First notify the app delegate if it conforms to AdaptableTextContainer.
        if let container = delegate, let traitCollection = container.window??.traitCollection {
            if container.responds(to: #selector(AdaptableTextContainer.adaptText(forTraitCollection:))) {
                container.perform(#selector(AdaptableTextContainer.adaptText(forTraitCollection:)), with: traitCollection)
            }
        }

        for window in windows {
            // Notify all views in the view hierarchy
            window.notifyContainedAdaptiveContentSizeContainers()
            // Notify all of the view controllers
            window.rootViewController?.notifyContainedAdaptiveContentSizeContainers()
        }
    }

}

extension UIViewController {

    /// 1. If the view is loaded and not installed in the view hierarchy, notify
    ///    the receiver's view and subviews. If the view is in the view hierarchy,
    ///    it has already been notified, so do not notify again.
    /// 2. Then notify all child view controllers, then the presented view controller, if any.
    final func notifyContainedAdaptiveContentSizeContainers() {
        if let view = viewIfLoaded {
            if view.window == nil {
                view.notifyContainedAdaptiveContentSizeContainers()
            }
        }
        for viewController in childViewControllers {
            viewController.notifyContainedAdaptiveContentSizeContainers()
        }
        presentedViewController?.notifyContainedAdaptiveContentSizeContainers()
        adaptText(forTraitCollection: traitCollection)
    }

}

extension UIView {

    /// Notify any subviews, then notify the receiver if it conforms to `AdaptableTextContainer`.
    final func notifyContainedAdaptiveContentSizeContainers() {
        for view in subviews {
            view.notifyContainedAdaptiveContentSizeContainers()
        }
        if responds(to: #selector(AdaptableTextContainer.adaptText(forTraitCollection:))) {
            perform(#selector(AdaptableTextContainer.adaptText(forTraitCollection:)), with: traitCollection)
        }
    }

}
