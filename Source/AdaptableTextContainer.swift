//
//  AdaptableTextContainer.swift
//
//  Created by Brian King on 7/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

/// A protocol to update the text style contained by the object. This can be triggered manually in
/// traitCollectionDidChange(_:). Any UIViewController or UIView that conforms to this protocol will
/// be informed of content size category changes if `UIApplication.enableAdaptiveContentSizeMonitor` is called.
@objc(BONAdaptableTextContainer)
public protocol AdaptableTextContainer {

    /// Update any text style contained by the object.
    /// - parameter traitCollection: The updated trait collection
    @objc(bon_updateTextForTraitCollection:)
    func updateText(forTraitCollection traitCollection: UITraitCollection)
}

extension UILabel: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        
        // Update the font, then the attributed string. If the font doesn't keep in sync when
        // not using attributedText, weird things happen so update it first.
        // See UIKitTests.testLabelFontPropertyBehavior for interesting behavior.

        if let bonMotStyle = bonMotStyle {
            font = bonMotStyle.font(traitCollection: traitCollection)
        }
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapt(toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
        }
    }

}

extension UITextView: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapt(toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
        }
        self.typingAttributes = NSAttributedString.adapt(attributes: typingAttributes, toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
        if let bonMotStyle = bonMotStyle {
            font = bonMotStyle.font(traitCollection: traitCollection)
        }
    }

}

extension UITextField: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        if let bonMotStyle = bonMotStyle {
            font = bonMotStyle.font(traitCollection: traitCollection)
        }
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapt(toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
        }
        if let attributedPlaceholder = attributedPlaceholder {
            self.attributedPlaceholder = attributedPlaceholder.adapt(toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
        }
        if let typingAttributes = typingAttributes {
            self.typingAttributes = NSAttributedString.adapt(attributes: typingAttributes, toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
        }
    }

}

extension UIButton: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        if let bonMotStyle = bonMotStyle, let titleLabel = titleLabel {
            titleLabel.font = bonMotStyle.font(traitCollection: traitCollection)
        }
        for state: UIControlState in UIControlState.allStates {
            #if swift(>=3.0)
                let attributedText = attributedTitle(for: state)?.adapt(toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
                setAttributedTitle(attributedText, for: state)
            #else
                let attributedText = attributedTitleForState(state)?.adapt(toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
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

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        for state: UIControlState in UIControlState.allStates {
            #if swift(>=3.0)
                let attributes = bon_titleTextAttributes(for: state)
                let newAttributes = NSAttributedString.adapt(attributes: attributes, toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
                setTitleTextAttributes(newAttributes, for: state)
            #else
                if let attributes = titleTextAttributesForState(state) as? StyleAttributes {
                    let newAttributes = NSAttributedString.adapt(attributes: attributes, toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
                    setTitleTextAttributes(newAttributes, forState: state)
                }
            #endif
        }
    }

}

extension UINavigationBar: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        if let titleTextAttributes = titleTextAttributes {
            self.titleTextAttributes = NSAttributedString.adapt(attributes: titleTextAttributes, toTraitCollection: traitCollection)
        }
        for navigationItem in items ?? [] {
            for item in navigationItem.allBarItems {
                item.updateText(forTraitCollection: traitCollection)
            }
            if let backBarButtonItem = navigationItem.backBarButtonItem {
                backBarButtonItem.updateText(forTraitCollection: traitCollection)
            }
        }
    }

}

extension UIToolbar: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        for item in items ?? [] {
            item.updateText(forTraitCollection: traitCollection)
        }
    }

}

extension UIViewController: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        for item in navigationItem.allBarItems {
            item.updateText(forTraitCollection: traitCollection)
        }
        for item in toolbarItems ?? [] {
            item.updateText(forTraitCollection: traitCollection)
        }
        if let backBarButtonItem = navigationItem.backBarButtonItem {
            backBarButtonItem.updateText(forTraitCollection: traitCollection)
        }
    }

}

extension UIBarItem {

    // This does not conform to AdaptableTextContainer since it is not a view or view controller
    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        for state in UIControlState.allStates {
            #if swift(>=3.0)
                let attributes = titleTextAttributes(for: state) ?? [:]
                let newAttributes = NSAttributedString.adapt(attributes: attributes, toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
                setTitleTextAttributes(newAttributes, for: state)
            #else
                let attributes = titleTextAttributesForState(state) ?? [:]
                let newAttributes = NSAttributedString.adapt(attributes: attributes, toTraitCollection: traitCollection, defaultStyle: bonMotStyle)
                setTitleTextAttributes(newAttributes, forState: state)
            #endif
        }
    }

}

extension UIControlState {

    @nonobjc static var allStates: [UIControlState] {
        #if swift(>=3.0)
            return [.normal, .highlighted, .disabled]
        #else
            return [.Normal, .Highlighted, .Disabled]
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
