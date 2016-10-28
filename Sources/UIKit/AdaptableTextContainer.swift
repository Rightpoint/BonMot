//
//  AdaptableTextContainer.swift
//
//  Created by Brian King on 7/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

/// A protocol to update the text style contained by the object. This can be triggered manually in
/// traitCollectionDidChange(_:). Any UIViewController or UIView that conforms to this protocol will
/// be informed of content size category changes if `UIApplication.enableAdaptiveContentSizeMonitor` is called.
@objc(BONAdaptableTextContainer)
public protocol AdaptableTextContainer {

    /// Update the text style contained by the object in response to a trait collection change
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    func adaptText(forTraitCollection traitCollection: UITraitCollection)
}

extension UILabel: AdaptableTextContainer {

    /// Update the attributedText adapted to the specified UITraitCollection
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {

        // Update the font, then the attributed string. If the font doesn't keep in sync when
        // not using attributedText, weird things happen so update it first.
        // See UIKitTests.testLabelFontPropertyBehavior for interesting behavior.

        if let bonMotStyle = bonMotStyle {
            let attributes = NSAttributedString.adapt(attributes: bonMotStyle.attributes, to: traitCollection)
            font = attributes[NSFontAttributeName] as? BONFont
        }
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapt(to: traitCollection)
        }
    }

}

extension UITextView: AdaptableTextContainer {

    /// Update the attributedText and typingAttributes adapted to the specified UITraitCollection
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapt(to: traitCollection)
        }
        self.typingAttributes = NSAttributedString.adapt(attributes: typingAttributes, to: traitCollection)
    }

}

extension UITextField: AdaptableTextContainer {

    /// Update the attributedText, attributedPlaceholder and defaultTextAttributes adapted to the specified UITraitCollection
    ///
    /// NOTE: Do not modify typingAttributes, they are only relevant while the keyboard is open.
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        if let attributedText = attributedText?.adapt(to: traitCollection) {
            if attributedText.length > 0 {
                font = attributedText.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
            }
            self.attributedText = attributedText
        }
        if let attributedPlaceholder = attributedPlaceholder {
            self.attributedPlaceholder = attributedPlaceholder.adapt(to: traitCollection)
        }
        defaultTextAttributes = NSAttributedString.adapt(attributes: defaultTextAttributes, to: traitCollection)
        // Fix an issue where shrinking or growing text would stay the same width, but add whitespace.
        setNeedsDisplay()
    }

}

extension UIButton: AdaptableTextContainer {

    /// Update the attributedTitle in all control states, adapted to the specified UITraitCollection
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        for state in UIControlState.commonStates {
            #if swift(>=3.0)
                let attributedText = attributedTitle(for: state)?.adapt(to: traitCollection)
                setAttributedTitle(attributedText, for: state)
            #else
                let attributedText = attributedTitleForState(state)?.adapt(to: traitCollection)
                setAttributedTitle(attributedText, forState: state)
            #endif
        }
    }

}

extension UISegmentedControl: AdaptableTextContainer {

    // UISegmentedControl has terrible generics on titleTextAttributes so use a helper in Swift 3.0
    #if swift(>=3.0)
    @nonobjc final func bon_titleTextAttributes(for state: UIControlState) -> StyleAttributes {
        let attributes = titleTextAttributes(for: state) ?? [:]
        var result: StyleAttributes = [:]
        for value in attributes {
            guard let string = value.key as? String else {
                fatalError("Can not convert key \(value.key) to String")
            }
            result[string] = value
        }
        return result
    }
    #endif

    /// Update the attributedTitle in all control states, adapted to the specified UITraitCollection
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        for state in UIControlState.commonStates {
            #if swift(>=3.0)
                let attributes = bon_titleTextAttributes(for: state)
                let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
                setTitleTextAttributes(newAttributes, for: state)
            #else
                if let attributes = titleTextAttributesForState(state) as? StyleAttributes {
                    let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
                    setTitleTextAttributes(newAttributes, forState: state)
                }
            #endif
        }
    }

}

extension UINavigationBar: AdaptableTextContainer {

    /// Update the titleTextAttributes, adapted to the specified UITraitCollection
    ///
    /// NOTE: This does not update the bar button items. These should be updated through the containing view controller.
    ///
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        if let titleTextAttributes = titleTextAttributes {
            self.titleTextAttributes = NSAttributedString.adapt(attributes: titleTextAttributes, to: traitCollection)
        }
    }

}

#if os(tvOS)
#else
extension UIToolbar: AdaptableTextContainer {

    /// Update all bar items, adapted to the specified UITraitCollection.
    ///
    /// NOTE: This will only update bar items that are contained on the screen at the time.
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

extension UIViewController: AdaptableTextContainer {

    /// Update the bar items in the navigation item or in the toolbar, adapted to the specified UITraitCollection
    ///
    /// - parameter traitCollection: The updated trait collection
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

extension UIBarItem: AdaptableTextContainer {

    /// Update the `titleTextAttributes`, adapted to the specified `UITraitCollection`.
    ///
    /// - note: This extension does not conform to `AdaptableTextContainer` since `UIBarIterm` is not a view or view controller.
    /// - parameter forTraitCollection: the trait collection to use when updating the text
    @objc(bon_updateTextForTraitCollection:)
    public func adaptText(forTraitCollection traitCollection: UITraitCollection) {
        for state in UIControlState.commonStates {
            #if swift(>=3.0)
                let attributes = titleTextAttributes(for: state) ?? [:]
                let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
                setTitleTextAttributes(newAttributes, for: state)
            #else
                let attributes = titleTextAttributesForState(state) ?? [:]
                let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
                setTitleTextAttributes(newAttributes, forState: state)
            #endif
        }
    }

}

extension UIControlState {

    @nonobjc static var commonStates: [UIControlState] {
        #if swift(>=3.0)
            return [.normal, .highlighted, .disabled, .selected, [.highlighted, .selected]]
        #else
            return [.Normal, .Highlighted, .Disabled, .Selected, [.Highlighted, .Selected]]
        #endif
    }

}

extension UINavigationItem {

    final var allBarItems: [UIBarButtonItem] {
        var allBarItems = leftBarButtonItems ?? []
        allBarItems.append(contentsOf: rightBarButtonItems ?? [])
        return allBarItems
    }

}
