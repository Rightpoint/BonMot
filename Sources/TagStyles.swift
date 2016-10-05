//
//  TagStyles.swift
//
//  Created by Brian King on 8/12/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

/// TagStyles stores styles, and allows them to be looked up by name. This is primarily used for supporting
/// Interface builder and styling markup.
@objc(BONTagStyles)
public class TagStyles: NSObject {

    /// A shared repository of styles. The shared TagStyle is used by the Interface Builder styleName property.
    /// This singleton is per-populated with 3 values for Dynamic Text. "control", "body", and "preferred"
    #if os(iOS) || os(tvOS)
    public static var shared = TagStyles(
        styles: [
            "control": .style(.adapt(.control)),
            "body": .style(.adapt(.body)),
            "preferred": .style(.adapt(.preferred)) ,
        ]
    )
    #else
    public static var shared = TagStyles()
    #endif

    /// Define a closure to be invoked when an unregistered style is requested. By default
    /// an error is printed.
    public static var unregisteredStyleClosure: (String) -> Void = { name in
        print("Requesting unregistered style \(name)")
    }

    /// Create a new TagStyles object with the specified name to style mapping
    /// - parameter styles: A dictionary containing the name to style mapping
    public init(styles: [String: AttributedStringStyle] = [:]) {
        self.styles = styles
    }

    /// The contained name to style mapping
    public var styles: [String: AttributedStringStyle]

    public func registerStyle(forName name: String, style: AttributedStringStyle) {
        styles[name] = style
    }

    /// Lookup a style for the specified name. If no style is found `TagStyles.unregisteredStyleClosure` is invoked.
    /// This is done for error reporting and safety. We don't want to crash if no style is found and we want to avoid
    /// adding throw everywhere. In general if a style is requested by name it will just log and be un-styled.
    ///
    /// - parameter forName: The name of the style to lookup
    /// - returns: the configured style, or nil if none is found
    public func style(forName name: String) -> AttributedStringStyle? {
        guard let style = styles[name] else {
            TagStyles.unregisteredStyleClosure(name)
            return nil
        }
        return style
    }

}
