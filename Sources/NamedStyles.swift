//
//  NamedStyles.swift
//
//  Created by Brian King on 8/12/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

/// NamedStyles stores styles, and allows them to be looked up by name. This is primarily used for supporting
/// Interface builder and styling markup.
@objc(BONNamedStyles)
public class NamedStyles: NSObject {

    /// A shared repository of styles. The shared NamedStyles is used by the `bonMotStyleName` property in Interface Builder.
    /// This singleton is per-populated with 3 values for Dynamic Text. "control", "body", and "preferred"
    #if os(iOS) || os(tvOS)
    public static var shared = NamedStyles(
        styles: [
            "control": .style(.adapt(.control)),
            "body": .style(.adapt(.body)),
            "preferred": .style(.adapt(.preferred)) ,
        ]
    )
    #else
    public static var shared = NamedStyles()
    #endif

    /// Define a closure to be invoked when an unregistered style is requested. By default
    /// an error is printed.
    public static var unregisteredStyleClosure: (String) -> Void = { name in
        print("Requesting unregistered style \(name)")
    }

    /// Create a new NamedStyles object with the specified name to style mapping
    /// - parameter styles: A dictionary containing the name to style mapping
    public init(styles: [String: StringStyle] = [:]) {
        self.styles = styles
    }

    /// The contained name to style mapping
    public var styles: [String: StringStyle]

    public func registerStyle(forName name: String, style: StringStyle) {
        styles[name] = style
    }

    /// Lookup a style for the specified name. If no style is found `NamedStyles.unregisteredStyleClosure` is invoked.
    /// This is done for error reporting and safety. We don't want to crash if no style is found and we want to avoid
    /// adding throw everywhere. In general if a style is requested by name it will just log and be un-styled.
    ///
    /// - parameter forName: The name of the style to lookup
    /// - returns: the configured style, or nil if none is found
    public func style(forName name: String) -> StringStyle? {
        guard let style = styles[name] else {
            NamedStyles.unregisteredStyleClosure(name)
            return nil
        }
        return style
    }

}
