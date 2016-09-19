//
//  TagStyles+XML.swift
//
//  Created by Brian King on 8/29/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

/// An extension to generate formatted markup based on the registered names
extension TagStyles {

    /// Generate an attributedString by parsing `fromXMLFragment` and applying the style in the specified trait collection.
    /// The string `fromXMLFragment will be wrapped in `<?xml>` and a top level element to ensure it is valid XML, unless `doNotWrapXML` is specified as an option.
    /// If the XML is not valid an exception will be thrown.
    /// Any XML element in the string will apply the style registered for the element name.
    ///
    /// - parameter fromXMLFragment: The string containing the markup.
    /// - parameter traitCollection: The traitCollection to adapt the style to
    /// - returns: An NSAttributedString
    public func attributedString(fromXMLFragment string: String, forTraitCollection traitCollection: UITraitCollection? = nil, options: XMLParsingOptions = []) throws -> NSAttributedString {
        let builder = XMLTagStyleBuilder(
            string: string,
            namedStyles: self,
            options: options,
            traitCollection: traitCollection
        )
        return try builder.parseAttributedString()
    }
}

/// An option set to control the behavior of the XML parsing behavior
public struct XMLParsingOptions : OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    /// Do not wrap the fragment with `<?xml>` and a top level element
    public static let doNotWrapXML = XMLParsingOptions(rawValue: 1)

    /// Adopt certain HTML behavior:
    /// - Lookup the style with `elementName:htmlClass`, then `elementName`
    /// - Add the NSLinkAttributeName key for `<a href=''></a>` tags.
    public static let HTMLish = XMLParsingOptions(rawValue: 2)

    /// Allow XML elements that are not registered. No style will be used for these elements.
    public static let allowUnregisteredElements = XMLParsingOptions(rawValue: 4)
}

private class XMLTagStyleBuilder: NSObject, XMLParserDelegate {
    static let xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    static let internalTopLevelElement = "XMLTagStyleBuilderElement"

    let parser: XMLParser
    let namedStyles: TagStyles
    let options: XMLParsingOptions
    let traitCollection: UITraitCollection?
    var attributedString: NSMutableAttributedString
    var styles: [AttributedStringStyle]

    var topStyle: AttributedStringStyle {
        guard let style = styles.last else { fatalError("Invalid Style Stack") }
        return style
    }

    init(string: String,
         namedStyles: TagStyles,
         options: XMLParsingOptions,
         traitCollection: UITraitCollection? = nil,
         topStyle: AttributedStringStyle = AttributedStringStyle()) {
        let xml = (options.contains(.doNotWrapXML) ?
            string :
            "\(XMLTagStyleBuilder.xmlHeader)<\(XMLTagStyleBuilder.internalTopLevelElement)>\(string)</\(XMLTagStyleBuilder.internalTopLevelElement)>")

        guard let data = xml.data(using: String.Encoding.utf8) else {
            fatalError("Unable to convert to UTF8")
        }
        self.traitCollection = traitCollection
        self.attributedString = NSMutableAttributedString()
        self.parser = XMLParser(data: data)
        self.styles = [topStyle]
        self.options = options
        self.namedStyles = namedStyles
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
        guard elementName != XMLTagStyleBuilder.internalTopLevelElement else { return }
        var namedStyle = namedStyles.style(forName: elementName)
        var style = self.topStyle
        if namedStyle == nil && !options.contains(.allowUnregisteredElements) {
            parser.abortParsing()
            print("No registered style name for element \(elementName)")
            return
        }

        if options.contains([.HTMLish]) {
            if let htmlClass = attributeDict["class"] {
                namedStyle = self.namedStyles.style(forName: "\(elementName):\(htmlClass)") ?? namedStyle
            }
            if elementName.lowercased() == "a" {
                if let href = attributeDict["href"], let url = NSURL(string: href) {
                    style.link = url
                }
                else {
                    print("Ignoring invalid <a href='\(attributeDict["href"])'>")
                }
            }
        }
        if let namedStyle = namedStyle {
            style.add(attributedStringStyle: namedStyle)
        }
        styles.append(style)
    }

    #if swift(>=3.0)
    @objc fileprivate func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        parse(elementNamed: elementName, attributeDict: attributeDict)
    }

    @objc fileprivate func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        guard elementName != XMLTagStyleBuilder.internalTopLevelElement else { return }
        styles.removeLast()
    }

    @objc fileprivate func parser(_ parser: XMLParser, foundCharacters string: String) {
        let newAttributedString = topStyle.attributedString(from: string, attributes: [:], traitCollection: traitCollection)
        attributedString.append(newAttributedString)
    }
    #else
    typealias XMLParser = NSXMLParser
    typealias XMLParserDelegate = NSXMLParserDelegate

    @objc private func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        parse(elementNamed: elementName, attributeDict: attributeDict)
    }

    @objc private func parser(parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        guard elementName != XMLTagStyleBuilder.internalTopLevelElement else { return }
        styles.removeLast()
    }

    @objc private func parser(parser: XMLParser, foundCharacters string: String) {
        let newAttributedString = topStyle.attributedString(from: string, traitCollection: traitCollection)
        attributedString.append(newAttributedString)
    }
    #endif

}
