//
//  TagStyles+XML.swift
//
//  Created by Brian King on 8/29/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

extension NSAttributedString {

    /// Generate an attributedString by parsing `xml` using the `XMLStyler` protocol to provide style and string insertions to decorate the XML.
    /// As the XML fragment is traversed, the style of each node is provided by the `XMLStyler` protocol. This style, and the current style
    /// are combined to decorate the content of the node, and the added style is removed when the node is exited. The `XMLStyler` protocol
    /// can also insert `NSAttributedString`s when entering and exiting nodes to support more customized styling.
    ///
    /// The string `xml` will be wrapped in a top level element to ensure it is valid XML, unless `doNotWrapXML` is specified as an option.
    /// If the XML is not valid an exception will be thrown.
    ///
    /// - parameter xml: The string containing the markup.
    /// - parameter styler: A protocol to decorate the XML
    /// - parameter options: XML parsing options
    ///
    /// - returns: An NSAttributedString
    // swiftlint:disable:next valid_docs  (swiftlint issue jpsim/SourceKitten/issues/133)
    public static func composed(ofXML fragment: String, baseStyle: AttributedStringStyle? = nil, styler: XMLStyler? = nil, options: XMLParsingOptions = []) throws -> NSAttributedString {
        let builder = XMLBuilder(
            string: fragment,
            styler: styler ?? NSAttributedString.defaultXMLStyler,
            options: options,
            baseStyle: baseStyle ?? AttributedStringStyle()
        )
        let attributedString = try builder.parseAttributedString()
        return attributedString
    }

    /// Generate an attributedString by parsing `xml` using the collection of `XMLStyleRule`s to provide style and string insertions to decorate the XML.
    /// As the XML fragment is traversed, the style of each node is provided by the `StyleRule`s. This style, and the current style
    /// are combined to decorate the content of the node, and the added style is removed when the node is exited. The `XMLStyleRule`
    /// can also insert `NSAttributedString`s when entering and exiting nodes to support more customized styling.
    ///
    /// For more complex styling behavior, implement the `XMLStyler` protocol instead.
    ///
    /// The string `xml` will be wrapped in a top level element to ensure it is valid XML, unless `doNotWrapXML` is specified as an option.
    /// If the XML is not valid an exception will be thrown.
    ///
    /// - parameter xml: The string containing the markup.
    /// - parameter rules: A protocol to decorate the XML
    /// - parameter options: XML parsing options
    ///
    /// - returns: An NSAttributedString
    // swiftlint:disable:next valid_docs  (swiftlint issue jpsim/SourceKitten/issues/133)
    public static func composed(ofXML fragment: String, baseStyle: AttributedStringStyle? = nil, rules: [XMLStyleRule], options: XMLParsingOptions = []) throws -> NSAttributedString {
        let builder = XMLBuilder(
            string: fragment,
            styler: XMLRuleStyler(rules: rules),
            options: options,
            baseStyle: baseStyle ?? AttributedStringStyle()
        )
        let attributedString = try builder.parseAttributedString()
        return attributedString
    }

    /// The default XMLStyler to use. By default this styler will look element styles in the shared TagStyler and insert special characters when BON namespaced elements are encountered.
    @nonobjc public static var defaultXMLStyler: XMLStyler = {
        var rules = Special.insertionRules
        rules.append(.styles(TagStyles.shared))
        return XMLRuleStyler(rules: rules)
    }()

}

extension Special {
    static var insertionRules: [XMLStyleRule] {
        let rulePairs: [[XMLStyleRule]] = all.map() {
            let elementName = "BON:\($0.name)"
            // Add the insertion rule and a style rule so we don't lookup the style and generate a warning
            return [XMLStyleRule.enter(element: elementName, insert: $0), XMLStyleRule.style(elementName, AttributedStringStyle())]
        }
        return rulePairs.flatMap() { $0 }
    }
}

/// A simple set of styling rules for styling XML. If your needs are more complicated, use the XMLStyler protocol
public enum XMLStyleRule {
    case styles(TagStyles)
    case style(String, AttributedStringStyle)
    case enter(element: String, insert: Composable)
    case exit(element: String, insert: Composable)
}

/// This contract is used to transform an XML string into an attributed string.
public protocol XMLStyler {
    /// Return the style to apply for to the contents of the element. The style is sadded onto the current style
    func style(forElement name: String, attributes: [String: String]) -> AttributedStringStyle?

    /// Return a string to extend into the string being built. This is done after the style for the element has been applied, but before the contents of the element.
    func prefix(forElement name: String, attributes: [String: String]) -> Composable?

    /// Return a string to extend into the string being built when leaving the element. This is done before the style of the element is removed.
    func suffix(forElement name: String) -> Composable?
}

/// An option set to control the behavior of the XML parsing behavior
public struct XMLParsingOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    /// Do not wrap the fragment with a top level element. Wrapping the XML will cause a copy, for very large strings it is recommended that you include the root node an and pass this option.
    public static let doNotWrapXML = XMLParsingOptions(rawValue: 1)
}

/// Error wrapper that includes the line and column number of the error.
public struct XMLBuilderError: Error {
    /// The error generated by XMLParser
    public let parserError: Error
    /// The line number the error occurred on.
    public let line: Int
    /// The column the error occurred on.
    public let column: Int
}

/// This is a XMLStyler implementation for the StyleRules
private struct XMLRuleStyler: XMLStyler {
    let rules: [XMLStyleRule]

    func style(forElement name: String, attributes: [String: String]) -> AttributedStringStyle? {
        for rule in rules {
            switch rule {
            case let .style(string, style) where string == name:
                return style
            default:
                break
            }
        }
        for rule in rules {
            if case let .styles(tagStyles) = rule {
                return tagStyles.style(forName: name)
            }
        }
        return nil
    }

    func prefix(forElement name: String, attributes: [String: String]) -> Composable? {
        for rule in rules {
            switch rule {
            case let .enter(string, composable) where string == name:
                return composable
            default: break
            }
        }
        return nil
    }

    func suffix(forElement name: String) -> Composable? {
        for rule in rules {
            switch rule {
            case let .exit(string, composable) where string == name:
                return composable
            default: break
            }
        }
        return nil
    }

}

private class XMLBuilder: NSObject, XMLParserDelegate {
    static let internalTopLevelElement = "BonMotTopLevelContainer"

    let parser: XMLParser
    let styler: XMLStyler
    let options: XMLParsingOptions
    var attributedString: NSMutableAttributedString
    var styles: [AttributedStringStyle]

    var topStyle: AttributedStringStyle {
        guard let style = styles.last else { fatalError("Invalid Style Stack") }
        return style
    }

    init(string: String,
         styler: XMLStyler,
         options: XMLParsingOptions,
         baseStyle: AttributedStringStyle) {
        let xml = (options.contains(.doNotWrapXML) ?
            string :
            "<\(XMLBuilder.internalTopLevelElement)>\(string)</\(XMLBuilder.internalTopLevelElement)>")

        guard let data = xml.data(using: String.Encoding.utf8) else {
            fatalError("Unable to convert to UTF8")
        }
        self.attributedString = NSMutableAttributedString()
        self.parser = XMLParser(data: data)
        self.styles = [baseStyle]
        self.options = options
        self.styler = styler
        super.init()
        self.parser.shouldProcessNamespaces = false
        self.parser.shouldReportNamespacePrefixes = false
        self.parser.shouldResolveExternalEntities = false
        self.parser.delegate = self
    }

    func parseAttributedString() throws -> NSAttributedString {
        guard parser.parse() else {
            let line = parser.lineNumber
            let shiftColumn = (line == 1 && options.contains(.doNotWrapXML) == false)
            let shiftSize = XMLBuilder.internalTopLevelElement.lengthOfBytes(using: String.Encoding.utf8) + 2
            let column = parser.columnNumber - (shiftColumn ? shiftSize : 0)

            throw XMLBuilderError(parserError: parser.parserError!, line: line, column: column)
        }
        return attributedString
    }

    func parse(elementNamed elementName: String, attributeDict: [String: String]) {
        guard elementName != XMLBuilder.internalTopLevelElement else { return }
        let namedStyle = styler.style(forElement: elementName, attributes: attributeDict)
        var newStyle = self.topStyle
        if let namedStyle = namedStyle {
            newStyle.add(attributedStringStyle: namedStyle)
        }
        styles.append(newStyle)
    }

    func enter(element elementName: String, attributes: [String: String]) {
        if let prefix = styler.prefix(forElement: elementName, attributes: attributes) {
            prefix.append(to: attributedString, baseStyle: topStyle)
        }
    }

    func exit(element elementName: String) {
        if let suffix = styler.suffix(forElement: elementName) {
            suffix.append(to: attributedString, baseStyle: topStyle)
        }
    }

    #if swift(>=3.0)
    @objc fileprivate func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        parse(elementNamed: elementName, attributeDict: attributeDict)
        enter(element: elementName, attributes: attributeDict)
    }

    @objc fileprivate func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName != XMLBuilder.internalTopLevelElement else { return }
        exit(element: elementName)
        styles.removeLast()
    }

    @objc fileprivate func parser(_ parser: XMLParser, foundCharacters string: String) {
        let newAttributedString = topStyle.attributedString(from: string)
        attributedString.append(newAttributedString)
    }
    #else
    @objc private func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        parse(elementNamed: elementName, attributeDict: attributeDict)
        enter(element: elementName, attributes: attributeDict)
    }

    @objc private func parser(parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName != XMLBuilder.internalTopLevelElement else { return }
        exit(element: elementName)
        styles.removeLast()
    }

    @objc private func parser(parser: XMLParser, foundCharacters string: String) {
        let newAttributedString = topStyle.attributedString(from: string)
        attributedString.append(newAttributedString)
    }
    #endif

}
