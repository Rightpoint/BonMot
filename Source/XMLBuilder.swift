//
//  TagStyles+XML.swift
//
//  Created by Brian King on 8/29/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

extension NSAttributedString {

    /// Generate an attributedString by parsing `fromXML` and applying the style in the specified trait collection.
    /// The string `fromXML will be wrapped in `<?xml>` and a top level element to ensure it is valid XML, unless `doNotWrapXML` is specified as an option.
    /// If the XML is not valid an exception will be thrown.
    /// As the XML is parsed, an NSAttributedString can be specified to be inserted when entering or exiting the XML node using TagInsertions, and the style to apply to the content of the XML node can be specified using TagStyles.
    ///
    /// - parameter fromXML: The string containing the markup.
    /// - parameter styles: The TagStyles object to use to determine the style to apply to the content of an XML node
    /// - parameter insertions: The TagInsertions object to insert content when entering or exiting an XML node.
    /// - parameter traitCollection: The traitCollection to adapt the style to
    /// - parameter options: XML parsing options
    ///s
    /// - returns: An NSAttributedString
    public convenience init(fromXML fragment: String, styler: XMLStyler? = nil, options: XMLParsingOptions = []) throws {
        let builder = XMLBuilder(
            string: fragment,
            styler: styler ?? SimpleXMLStyler(tagStyles: TagStyles.shared),
            options: options
        )
        let attributedString = try builder.parseAttributedString()
        self.init(attributedString: attributedString)
    }
}

/// This contract is used to transform an XML string into an attributed string.
public protocol XMLStyler {
    /// Return the style to apply for to the contents of the element. The style is sadded onto the current style
    func style(forElement name: String, attributes: [String: String]) -> AttributedStringStyle?

    /// Return a string to extend into the string being built. This is done after the style for the element has been applied, but before the contents of the element.
    func prefix(forElement name: String, attributes: [String: String]) -> NSAttributedString?

    /// Return a string to extend into the string being built when leaving the element. This is done before the style of the element is removed.
    func suffix(forElement name: String) -> NSAttributedString?
}

/// This is a simple XMLStyler implementation
public struct SimpleXMLStyler: XMLStyler {
    let tagStyles: TagStyles
    var entering: [String: NSAttributedString] = [:]
    var exiting: [String: NSAttributedString] = [:]

    public init(tagStyles: TagStyles) {
        self.tagStyles = tagStyles
    }

    public mutating func add(prefix string: NSAttributedString, forElement elementName: String) {
        entering[elementName] = string
    }
    public mutating func add(suffix string: NSAttributedString, forElement elementName: String) {
        exiting[elementName] = string
    }

    public func style(forElement name: String, attributes: [String: String]) -> AttributedStringStyle? {
        return tagStyles.style(forName: name)
    }

    public func prefix(forElement name: String, attributes: [String: String]) -> NSAttributedString? {
        return entering[name]
    }
    public func suffix(forElement name: String) -> NSAttributedString? {
        return exiting[name]
    }
}

/// An option set to control the behavior of the XML parsing behavior
public struct XMLParsingOptions : OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    /// Do not wrap the fragment with `<?xml>` and a top level element
    public static let doNotWrapXML = XMLParsingOptions(rawValue: 1)

    /// Allow XML elements that are not registered. No style will be used for these elements.
    public static let allowUnregisteredElements = XMLParsingOptions(rawValue: 2)
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
         topStyle: AttributedStringStyle = AttributedStringStyle()) {
        let xml = (options.contains(.doNotWrapXML) ?
            string :
            "<\(XMLBuilder.internalTopLevelElement)>\(string)</\(XMLBuilder.internalTopLevelElement)>")

        guard let data = xml.data(using: String.Encoding.utf8) else {
            fatalError("Unable to convert to UTF8")
        }
        self.attributedString = NSMutableAttributedString()
        self.parser = XMLParser(data: data)
        self.styles = [topStyle]
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
            throw parser.parserError!
        }
        return attributedString
    }

    func parse(elementNamed elementName: String, attributeDict: [String: String]) {
        guard elementName != XMLBuilder.internalTopLevelElement else { return }
        let namedStyle = styler.style(forElement: elementName, attributes: attributeDict)
        if namedStyle == nil && !options.contains(.allowUnregisteredElements) {
            parser.abortParsing()
            print("No registered style name for element \(elementName)")
            return
        }

        var newStyle = self.topStyle
        if let namedStyle = namedStyle {
            newStyle.update(attributedStringStyle: namedStyle)
        }
        styles.append(newStyle)
    }

    func enter(element elementName: String, attributes: [String: String]) {
        if let prefix = styler.prefix(forElement: elementName, attributes: attributes) {
            attributedString.extend(with: prefix, style: topStyle)
        }
    }

    func exit(element elementName: String) {
        if let suffix = styler.suffix(forElement: elementName) {
            attributedString.extend(with: suffix, style: topStyle)
        }
    }

    #if swift(>=3.0)
    @objc fileprivate func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        parse(elementNamed: elementName, attributeDict: attributeDict)
        enter(element: elementName, attributes: attributeDict)
    }

    @objc fileprivate func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
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

    @objc private func parser(parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
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
