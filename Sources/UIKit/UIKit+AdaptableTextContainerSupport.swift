//
//  UIKit+AdaptableTextContainerSupport.swift
//
//  Created by Brian King on 7/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

extension UIApplication {

    /// Support for the AdaptableTextContainer protocol is enabled with this method. This
    /// adds the application as an observer for UIContentSizeCategoryDidChangeNotification
    /// and floods the change notification to the UIViewController hierarchy, which by
    /// default floods the view managed by the UIViewController.
    ///
    /// The UIApplication delegate is also checked for conformance to AdaptableTextContainer,
    /// which can be a good place to update appearance proxies and invalidate any hard-wired
    /// caches that less responsive code may have.
    public final func enableAdaptiveContentSizeMonitor() {
        #if swift(>=3.0)
            let notificationCenter = NotificationCenter.default
            let notificationName = NSNotification.Name.UIContentSizeCategoryDidChange
        #else
            let notificationCenter = NSNotificationCenter.defaultCenter()
            let notificationName = UIContentSizeCategoryDidChangeNotification
        #endif
        notificationCenter.addObserver(
            self,
            selector: #selector(UIApplication.bon_notifyContainedAdaptiveContentSizeContainers(fromNotification:)),
            name: notificationName,
            object: nil)
    }

    // Notify the view controller hierarchy. This is an internal method.
    @objc func bon_notifyContainedAdaptiveContentSizeContainers(fromNotification notification: NSNotification) {
        // First notify the app delegate if it conforms to AdaptableTextContainer.
        if let container = self.delegate as? AdaptableTextContainer, let traitCollection = self.delegate?.window??.traitCollection {
            container.adaptText(forTraitCollection: traitCollection)
        }

        for window in self.windows {
            // Notify all views in the view hierarchy
            window.notifyContainedAdaptiveContentSizeContainers()
            // Notify all of the view controllers
            window.rootViewController?.notifyContainedAdaptiveContentSizeContainers()
        }
    }

}

extension UIViewController {

    /// If the view is loaded and not installed in the view hierarchy, notify the views.
    /// If the view is in the view hierarchy, it has already been notified, and do not notify again
    /// Then notify all child view controllers, then the presented view controller, if any.
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

    /// Notify any subviews, then notify the view if it conforms to AdaptableTextContainer
    final func notifyContainedAdaptiveContentSizeContainers() {
        for view in subviews {
            view.notifyContainedAdaptiveContentSizeContainers()
        }
        if let container = self as? AdaptableTextContainer {
            container.adaptText(forTraitCollection: traitCollection)
        }
    }
}
