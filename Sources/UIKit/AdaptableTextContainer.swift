//
//  AdaptableTextContainer.swift
//  BonMot
//
//  Created by Brian King on 7/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

/// A protocol to update the text style contained by the object. This can be
/// triggered manually in `traitCollectionDidChange(_:)`. Any `UIViewController`
/// or `UIView` that conforms to this protocol will be informed of content size
/// category changes if `UIApplication.enableAdaptiveContentSizeMonitor()` is called.
/// - Note: We don't conform UI elements to this protocol due to a [bug in Xcode](http://www.openradar.me/30001713).
///         The protocol still exists as a container for selectors.
@objc(BONAdaptableTextContainer)
public protocol AdaptableTextContainer {

    /// Update the text style contained by the object in response to a trait
    /// collection change.
    ///
    /// - parameter traitCollection: The new trait collection.
    @objc(bon_updateTextForTraitCollection:)
    func adaptText(forTraitCollection traitCollection: UITraitCollection)

}

// MARK: - AdaptableTextContainer for UILabel
extension UILabel {

    /// Adapt `attributedText` to the specified trait collection.
    ///
    /// - parameter traitCollection: The new trait collection.
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {

        // Update the font, then the attributed string. If the font doesn't keep in sync when
        // not using attributedText, weird things happen so update it first.
        // See UIKitTests.testLabelFontPropertyBehavior for interesting behavior.

        if let bonMotStyle = bonMotStyle {
            let attributes = NSAttributedString.adapt(attributes: bonMotStyle.attributes, to: traitCollection)
            font = attributes[.font] as? BONFont
        }
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapted(to: traitCollection)
        }
    }

}

// MARK: - AdaptableTextContainer for UITextView
extension UITextView {

    /// Adapt `attributedText` and `typingAttributes` to the specified trait collection.
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapted(to: traitCollection)
        }
        typingAttributes = NSAttributedString.adapt(attributes: typingAttributes.withTypedKeys(), to: traitCollection).withStringKeys
    }

}

// MARK: - AdaptableTextContainer for UITextField
extension UITextField {

    /// Adapt `attributedText`, `attributedPlaceholder`, and
    /// `defaultTextAttributes` to the specified trait collection.
    ///
    /// - note: Do not modify `typingAttributes`, as they are relevant only 
    ///         while the text field has first responder status, and they are
    ///         reset as new text is entered.
    ///
    /// - parameter traitCollection: The new trait collection.
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        if let attributedText = attributedText?.adapted(to: traitCollection) {
            if attributedText.length > 0 {
                font = attributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont
            }
            self.attributedText = attributedText
        }
        if let attributedPlaceholder = attributedPlaceholder {
            self.attributedPlaceholder = attributedPlaceholder.adapted(to: traitCollection)
        }
        defaultTextAttributes = NSAttributedString.adapt(attributes: defaultTextAttributes.withTypedKeys(), to: traitCollection).withStringKeys
        // Fix an issue where shrinking or growing text would stay the same width, but add whitespace.
        setNeedsDisplay()
    }

}

// MARK: - AdaptableTextContainer for UIButton
extension UIButton {

    /// Adapt `attributedTitle`, for all control states, to the specified trait collection.
    ///
    /// - parameter traitCollection: The new trait collection.
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        for state in UIControlState.commonStates {
            let attributedText = attributedTitle(for: state)?.adapted(to: traitCollection)
            setAttributedTitle(attributedText, for: state)
        }
    }

}

// MARK: - AdaptableTextContainer for UISegmentedControl
extension UISegmentedControl {

    // `UISegmentedControl` has terrible generics ([NSObject: AnyObject]? or [AnyHashable: Any]?) on
    /// `titleTextAttributes`, so use a helper in Swift 3+
    @nonobjc final func bon_titleTextAttributes(for state: UIControlState) -> StyleAttributes {
        let attributes = titleTextAttributes(for: state) ?? [:]
        var result: StyleAttributes = [:]
        for value in attributes {
            guard let string = value.key as? StyleAttributes.Key else {
                fatalError("Can not convert key \(value.key) to String")
            }
            result[string] = value
        }
        return result
    }

    /// Adapt `attributedTitle`, for all control states, to the specified trait collection.
    ///
    /// - parameter traitCollection: The new trait collection.
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        for state in UIControlState.commonStates {
            let attributes = bon_titleTextAttributes(for: state)
            let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
            setTitleTextAttributes(newAttributes, for: state)
        }
    }

}

// MARK: - AdaptableTextContainer for UINavigationBar
extension UINavigationBar {

    /// Adapt `titleTextAttributes` to the specified trait collection.
    ///
    /// - note: This does not update the bar button items. These should be
    ///         updated by the containing view controller.
    ///
    /// - parameter traitCollection: The new trait collection.
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        if let titleTextAttributes = titleTextAttributes {
            self.titleTextAttributes = NSAttributedString.adapt(attributes: titleTextAttributes, to: traitCollection)
        }
    }

}

#if os(tvOS)
#else
// MARK: - AdaptableTextContainer for UIToolbar
extension UIToolbar {

    /// Adapt all bar items's attributed text to the specified trait collection.
    ///
    /// - note: This will update only bar items that are contained on the screen
    ///         at the time that it is called.
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        for item in items ?? [] {
            item.adaptText(forTraitCollection: traitCollection)
        }
    }

}
#endif

// MARK: - AdaptableTextContainer for UIViewController
extension UIViewController {

    /// Adapt the attributed text of teh bar items in the navigation item or in
    /// the toolbar to the specified trait collection.
    ///
    /// - parameter traitCollection: The new trait collection.
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        for item in navigationItem.allBarItems {
            item.adaptText(forTraitCollection: traitCollection)
        }
        #if os(tvOS)
        #else
            for item in toolbarItems ?? [] {
                item.adaptText(forTraitCollection: traitCollection)
            }
            if let backBarButtonItem = navigationItem.backBarButtonItem {
                backBarButtonItem.adaptText(forTraitCollection: traitCollection)
            }
        #endif
    }

}

// MARK: - AdaptableTextContainer for UIBarItem
extension UIBarItem {

    /// Adapt `titleTextAttributes` to the specified trait collection.
    ///
    /// - note: This extension does not conform to `AdaptableTextContainer`
    /// because `UIBarIterm` is not a view or view controller.
    /// - parameter traitCollection: the new trait collection.
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        for state in UIControlState.commonStates {
            let attributes = titleTextAttributes(for: state) ?? [:]
            let newAttributes = NSAttributedString.adapt(attributes: attributes.withTypedKeys(), to: traitCollection)
            setTitleTextAttributes(newAttributes, for: state)
        }
    }

}

extension UIControlState {

    /// The most common states that are used in apps. Using this defined set of
    /// attributes is far simpler than trying to build a system that will
    /// iterate through only the permutations that are currently configured. If
    /// you use a valid `UIControlState` in your app that is not represented
    /// here, please open a pull request to add it.
    @nonobjc static var commonStates: [UIControlState] {
        return [.normal, .highlighted, .disabled, .selected, [.highlighted, .selected]]
    }

}

extension UINavigationItem {

    /// Convenience getter comprising `leftBarButtonItems` and `rightBarButtonItems`.
    final var allBarItems: [UIBarButtonItem] {
        var allBarItems = leftBarButtonItems ?? []
        allBarItems.append(contentsOf: rightBarButtonItems ?? [])
        return allBarItems
    }

}
