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
            font = StyleAttributeHelpers.font(from: bonMotStyle.attributes())
        }
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapt(to: traitCollection)
        }
    }

}

extension UITextView: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapt(to: traitCollection)
        }

        self.typingAttributes = NSAttributedString.adapt(attributes: typingAttributes, to: traitCollection)
        if let bonMotStyle = bonMotStyle {
            font = StyleAttributeHelpers.font(from: NSAttributedString.adapt(attributes: bonMotStyle.attributes(), to: traitCollection))
        }
    }

}

extension UITextField: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        if let bonMotStyle = bonMotStyle {
            font = StyleAttributeHelpers.font(from: bonMotStyle.attributes())
        }
        if let attributedText = attributedText {
            self.attributedText = attributedText.adapt(to: traitCollection)
        }
        if let attributedPlaceholder = attributedPlaceholder {
            self.attributedPlaceholder = attributedPlaceholder.adapt(to: traitCollection)
        }
        if let typingAttributes = typingAttributes {
            self.typingAttributes = NSAttributedString.adapt(attributes: typingAttributes, to: traitCollection)
        }
    }

}

extension UIButton: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        if let bonMotStyle = bonMotStyle, let titleLabel = titleLabel {
            titleLabel.font = StyleAttributeHelpers.font(from: bonMotStyle.attributes())
        }
        for state: UIControlState in UIControlState.allStates {
            #if swift(>=3.0)
                let attributedText = attributedTitle(for: state)?.adapt(to: traitCollection)
                setAttributedTitle(attributedText, for: state)
            #else
                let attributedText = attributedTitle(for: state)?.adapt(to: traitCollection)
                setAttributedTitle(attributedText, for: state)
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
                let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
                setTitleTextAttributes(newAttributes, for: state)
            #else
                if let attributes = titleTextAttributes(for: state) as? StyleAttributes {
                    let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
                    setTitleTextAttributes(newAttributes, for: state)
                }
            #endif
        }
    }

}

extension UINavigationBar: AdaptableTextContainer {

    @objc(bon_updateTextForTraitCollection:)
    public func updateText(forTraitCollection traitCollection: UITraitCollection) {
        if let titleTextAttributes = titleTextAttributes {
            self.titleTextAttributes = NSAttributedString.adapt(attributes: titleTextAttributes, to: traitCollection)
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
                let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
                setTitleTextAttributes(newAttributes, for: state)
            #else
                let attributes = titleTextAttributes(for: state) ?? [:]
                let newAttributes = NSAttributedString.adapt(attributes: attributes, to: traitCollection)
                setTitleTextAttributes(newAttributes, for: state)
            #endif
        }
    }

}

extension UIControlState {

    @nonobjc static var allStates: [UIControlState] {
        #if swift(>=3.0)
            return [.normal, .highlighted, .disabled]
        #else
            return [.highlighted, .disabled]
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
