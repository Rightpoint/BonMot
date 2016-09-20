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
    public convenience init(fromXML fragment: String, styles: TagStyles? = nil, insertions: TagInsertions? = nil, forTraitCollection traitCollection: UITraitCollection? = nil, options: XMLParsingOptions = []) throws {

        let builder = XMLTagStyleBuilder(
            string: fragment,
            namedStyles: styles ?? TagStyles.shared,
            tagInsertions: insertions ?? TagInsertions.shared,
            options: options,
            traitCollection: traitCollection
        )
        let attributedString = try builder.parseAttributedString()
        self.init(attributedString: attributedString)
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

public class TagInsertions {
    var entering: [String: NSAttributedString] = [:]
    var exiting: [String: NSAttributedString] = [:]
    func attributedString(forEnteringElement elementName: String) -> NSAttributedString? {
        return entering[elementName]
    }

    func attributedString(forExitingElement elementName: String) -> NSAttributedString? {
        return exiting[elementName]
    }

    public static var shared = TagInsertions()
    public init() {}
    public func insert(attributedString: NSAttributedString, whenEntering elementName: String) {
        entering[elementName] = attributedString
    }
    public func insert(attributedString: NSAttributedString, whenExiting elementName: String) {
        exiting[elementName] = attributedString
    }
}

private class XMLTagStyleBuilder: NSObject, XMLParserDelegate {
    static let internalTopLevelElement = "BonMotTopLevelContainer"

    let parser: XMLParser
    let namedStyles: TagStyles
    let tagInsertions: TagInsertions?
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
         tagInsertions: TagInsertions?,
         options: XMLParsingOptions,
         traitCollection: UITraitCollection? = nil,
         topStyle: AttributedStringStyle = AttributedStringStyle()) {
        let xml = (options.contains(.doNotWrapXML) ?
            string :
            "<\(XMLTagStyleBuilder.internalTopLevelElement)>\(string)</\(XMLTagStyleBuilder.internalTopLevelElement)>")

        guard let data = xml.data(using: String.Encoding.utf8) else {
            fatalError("Unable to convert to UTF8")
        }
        self.traitCollection = traitCollection
        self.attributedString = NSMutableAttributedString()
        self.parser = XMLParser(data: data)
        self.styles = [topStyle]
        self.options = options
        self.namedStyles = namedStyles
        self.tagInsertions = tagInsertions
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
            style.update(attributedStringStyle: namedStyle)
        }
        styles.append(style)
    }

    func enter(element elementName: String) {
        if let insertion = tagInsertions?.attributedString(forEnteringElement: elementName) {
            attributedString.extend(with: insertion, style: topStyle)
        }
    }

    func exit(element elementName: String) {
        if let insertion = tagInsertions?.attributedString(forExitingElement: elementName) {
            attributedString.extend(with: insertion, style: topStyle)
        }
    }

    #if swift(>=3.0)
    @objc fileprivate func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        parse(elementNamed: elementName, attributeDict: attributeDict)
        enter(element: elementName)
    }

    @objc fileprivate func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        guard elementName != XMLTagStyleBuilder.internalTopLevelElement else { return }
        exit(element: elementName)
        styles.removeLast()
    }

    @objc fileprivate func parser(_ parser: XMLParser, foundCharacters string: String) {
        attributedString.extend(with: string, style: topStyle, traitCollection: traitCollection)
    }
    #else
    typealias XMLParser = NSXMLParser
    typealias XMLParserDelegate = NSXMLParserDelegate

    @objc private func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        parse(elementNamed: elementName, attributeDict: attributeDict)
        enter(element: elementName)
    }

    @objc private func parser(parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        guard elementName != XMLTagStyleBuilder.internalTopLevelElement else { return }
        exit(element: elementName)
        styles.removeLast()
    }

    @objc private func parser(parser: XMLParser, foundCharacters string: String) {
        let newAttributedString = topStyle.attributedString(from: string, traitCollection: traitCollection)
        attributedString.append(newAttributedString)
    }
    #endif

}
