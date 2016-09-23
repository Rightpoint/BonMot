//
//  StyleableTextContainer.swift
//
//  Created by Brian King on 8/11/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

/// A StyleableTextContainer is a protocol that a text container can conform to to represent text that can be styled. This is 
/// usually a UIView subclass or an "Item" view model.
public protocol StyleableTextContainer: AnyObject {

    /// The style to use for this container. The containers is updated when this property is set if the container conforms to AdaptableTextContainer
    var bonMotStyle: StyleAttributeTransformation? { get set }

}

/// Helper functionality for the BonMotStyle associated objects.
internal enum StyleableSupport {
    static var containerHandle: UInt8 = 0

    static func getStyle(object theObject: NSObject) -> StyleAttributeTransformation? {
        let adaptiveFunctionContainer = objc_getAssociatedObject(theObject, &containerHandle) as? StyleAttributeTransformationHolder
        return adaptiveFunctionContainer?.style
    }

    static func setStyle(object theObject: NSObject, bonMotStyle: StyleAttributeTransformation?) {
        var adaptiveFunction: StyleAttributeTransformationHolder? = nil
        if let bonMotStyle = bonMotStyle {
            adaptiveFunction = StyleAttributeTransformationHolder(style: bonMotStyle)
        }
        objc_setAssociatedObject(
            theObject, &containerHandle,
            adaptiveFunction,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        if let traitEnvironment = theObject as? UITraitEnvironment, let container = theObject as? AdaptableTextContainer {
            container.updateText(forTraitCollection: traitEnvironment.traitCollection)
        }
    }
}

@objc(BONStyleAttributeTransformationHolder)
internal class StyleAttributeTransformationHolder: NSObject {

    let style: StyleAttributeTransformation
    init(style: StyleAttributeTransformation) {
        self.style = style
    }
}

extension StyleableTextContainer {

    internal final func styledAttributedString(forText text: String?, traitCollection: UITraitCollection?) -> NSAttributedString? {
        if let text = text {
            let string = (bonMotStyle ?? BonMot()).attributedString(from: text)
            if let traitCollection = traitCollection {
                return string.adapt(to: traitCollection)
            }
            return string
        }
        else {
            return nil
        }
    }
    
}

extension UILabel: StyleableTextContainer {

    /// Specify the style to use for the UILabel. This will trigger AdaptableTextContainer.updateText(forTraitCollection:) to
    /// update the current state of the UILabel
    public final var bonMotStyle: StyleAttributeTransformation? {
        get { return StyleableSupport.getStyle(object: self) }
        set { StyleableSupport.setStyle(object: self, bonMotStyle: newValue) }
    }

    /// Create a new NSAttributedString using the specified string and the bonMotStyle property, and assign it to the attributedText property
    @objc(bon_styledText)
    public var styledText: String? {
        set { attributedText = styledAttributedString(forText: newValue, traitCollection: traitCollection) }
        get { return attributedText?.string }
    }
}

extension UITextField: StyleableTextContainer {

    /// Specify the style to use for text contained inside the view. This will trigger AdaptableTextContainer.updateText(forTraitCollection:) to
    /// update the current state of the view
    ///
    /// NOTE: This will update the typeAttributes, attributedPlaceholder, and attributedText. Use attributed strings for more control.
    public final var bonMotStyle: StyleAttributeTransformation? {
        get { return StyleableSupport.getStyle(object: self) }
        set { StyleableSupport.setStyle(object: self, bonMotStyle: newValue) }
    }

    /// Create a new NSAttributedString using the specified string and the bonMotStyle property, and assign it to the attributedText property
    @objc(bon_styledText)
    public var styledText: String? {
        set { attributedText = styledAttributedString(forText: newValue, traitCollection: traitCollection) }
        get { return attributedText?.string }
    }
}

extension UITextView: StyleableTextContainer {

    /// Specify the style to use for text contained inside the view. This will trigger AdaptableTextContainer.updateText(forTraitCollection:) to
    /// update the current state of the view
    ///
    /// NOTE: This will update the typeAttributes and attributedText. Use attributed strings for more control.
    public final var bonMotStyle: StyleAttributeTransformation? {
        get { return StyleableSupport.getStyle(object: self) }
        set { StyleableSupport.setStyle(object: self, bonMotStyle: newValue) }
    }

    /// Create a new NSAttributedString using the specified string and the bonMotStyle property, and assign it to the attributedText property
    @objc(bon_styledText)
    public var styledText: String? {
        set { attributedText = styledAttributedString(forText: newValue, traitCollection: traitCollection) }
        get { return attributedText?.string }
    }
}

extension UIButton: StyleableTextContainer {

    /// Specify the style to use for text contained inside the view. This will trigger AdaptableTextContainer.updateText(forTraitCollection:) to
    /// update the current state of the view
    public final var bonMotStyle: StyleAttributeTransformation? {
        get { return StyleableSupport.getStyle(object: self) }
        set { StyleableSupport.setStyle(object: self, bonMotStyle: newValue) }
    }

    /// Create a new NSAttributedString using the specified string and the bonMotStyle property, and set the attributed string for the specified state.
    #if swift(>=3.0)
    @objc(bon_setStyledText:for:)
    public func setStyledText(_ text: String, forState state: UIControlState) {
        setAttributedTitle(styledAttributedString(forText: text, traitCollection: traitCollection), for: state)
    }
    #else
    @objc(bon_setStyledText:forState:)
    public func setStyledText(text: String, forState state: UIControlState) {
        setAttributedTitle(styledAttributedString(forText: text, traitCollection: traitCollection), forState: state)
    }
    #endif

}

extension UISegmentedControl: StyleableTextContainer {

    /// Specify the style to use for text contained inside the view. This will trigger AdaptableTextContainer.updateText(forTraitCollection:) to
    /// update the current state of the view
    public final var bonMotStyle: StyleAttributeTransformation? {
        get { return StyleableSupport.getStyle(object: self) }
        set { StyleableSupport.setStyle(object: self, bonMotStyle: newValue) }
    }

}

extension UIBarItem: StyleableTextContainer {

    /// Specify the style to use for text contained inside the bar item. This will trigger AdaptableTextContainer.updateText(forTraitCollection:) to
    /// update the current state of the bar item
    public final var bonMotStyle: StyleAttributeTransformation? {
        get { return StyleableSupport.getStyle(object: self) }
        set { StyleableSupport.setStyle(object: self, bonMotStyle: newValue) }
    }

}

extension UINavigationBar: StyleableTextContainer {

    /// Specify the style to use for text contained inside the view. This will trigger AdaptableTextContainer.updateText(forTraitCollection:) to
    /// update the current state of the view
    public final var bonMotStyle: StyleAttributeTransformation? {
        get { return StyleableSupport.getStyle(object: self) }
        set { StyleableSupport.setStyle(object: self, bonMotStyle: newValue) }
    }

}
