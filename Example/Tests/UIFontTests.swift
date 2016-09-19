//
//  UIFontTests.swift
//
//  Created by Brian King on 7/20/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
@testable import BonMot

#if swift(>=3.0)
    let testTextStyle = UIFontTextStyle.title3
#else
    let testTextStyle = UIFontTextStyleTitle3
#endif

class UIFontTests: XCTestCase {

    /**
     * These tests explores how font attributes persist after construction
     *
     * Note that when a font is created, injected attributes are removed.
     * It appears that font attributes only describe, but can not modify a font.
     * UIFontDescriptorTextStyleAttribute is dropped if a new value is specified outside of the UIFontTextStyle values.
     *
     * An early version of the adaptive behavior used associated objects to associate a scaling function with a font. This turned out to not be a valid approach since
     * UIFont's are unique objects, and the swift API obscured that fact.
     */
    func testUIFont() {
        var attributes = UIFont(name: "Avenir-Roman", size: 10)!.fontDescriptor.fontAttributes
        attributes[UIFontDescriptorFeatureSettingsAttribute] = [
            [
                UIFontFeatureTypeIdentifierKey: 1,
                UIFontFeatureSelectorIdentifierKey: 1
            ],
        ]
        attributes[UIFontDescriptorTextStyleAttribute] = "Test"
        let newAttributes = UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: 0).fontDescriptor.fontAttributes
        XCTAssertEqual(newAttributes.count, 2)
        XCTAssertEqual(newAttributes["NSFontNameAttribute"] as? String, "Avenir-Roman")
        XCTAssertEqual(newAttributes["NSFontSizeAttribute"] as? Int, 10)
    }

    func testTextStyleWithOtherFont() {
        var attributes = UIFont(name: "Avenir-Roman", size: 10)!.fontDescriptor.fontAttributes
        attributes[UIFontDescriptorTextStyleAttribute] = testTextStyle
        let newAttributes = UIFont(descriptor: UIFontDescriptor(fontAttributes: attributes), size: 0).fontDescriptor.fontAttributes
        XCTAssertEqual(newAttributes.count, 2)
        XCTAssertEqual(newAttributes["NSCTFontUIUsageAttribute"] as? BonMotTextStyle, testTextStyle)
        XCTAssertEqual(newAttributes["NSFontSizeAttribute"] as? Int, 10)
    }


//    func testPreferredFont() {
//        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        let pointSize = font.pointSize
//        for size in UIApplication.contentSizeCategoriesToTest {
//            UIApplication.sharedApplication().fakeContentSizeCategory(size)
//            let newFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//            print("\(pointSize) = \(newFont.pointSize)")
//        }
//    }
}

// Some code to generate plots exploring UIFont.preferredFont
#if swift(>=3.0)
#else
extension UIFontTests {

    func testPreferredFontInfo() {
        UIFontTests.generateGNUPlots()
    }


    static func calculateDifference(preferredFont: UIFont, getter: (UIFont) -> CGFloat) -> String {
        let font = UIFont(name: preferredFont.fontName, size: preferredFont.pointSize)!
        let difference = getter(preferredFont) - getter(font)
        return "\(difference)"
    }

    static func generateGNUPlots() {
        let originalSize = UIApplication.sharedApplication().preferredContentSizeCategory

        let plots: [(String, (UIFont) -> String, [String])] = [
            ("Point Size", { "\($0.pointSize)" }, ["set yrange [5:60]"]),
            // This font name varies between SFUIText-XXX and SFUIDisplay-XXX. Nothing we can do to easily mimic this behavior.
            // Commented out because gnuplot-ing strings is a bit tricker, and the grunt work is not worth the chart.
            //
            //            ("Font Name", { "\($0.fontName.stringByReplacingOccurrencesOfString(".", withString: "").stringByReplacingOccurrencesOfString("-", withString: ""))" }, []),
            ("Ascender", { "\($0.ascender)" }, []),
            ("Descender", { "\($0.descender)" }, []),
            ("Cap Height", { "\($0.capHeight)" }, []),
            ("X-Height", { "\($0.xHeight)" }, []),
            ("Line Height", { "\($0.lineHeight)" }, []),
            ("Leading", { "\($0.leading)" }, []),
            ("Leading Difference", { calculateDifference($0) {$0.leading } }, []),
            // None of these attributes vary between the default font
            ("Ascender Difference", { calculateDifference($0) { $0.ascender } }, []),
            ("Descender Difference", { calculateDifference($0) {$0.descender } }, []),
            ("Cap Height Difference", { calculateDifference($0) {$0.capHeight } }, []),
            ("X-Height Difference", { calculateDifference($0) {$0.xHeight } }, []),
            ("Line Height Difference", { calculateDifference($0) { $0.lineHeight } }, []),

            ]
        for plot in plots {
            let filePrefix = plot.0.stringByReplacingOccurrencesOfString(" ", withString: "")
            print("cat > \(filePrefix).dat << EOF")
            print(dumpGNUPlotData(plot.1))
            print("EOF")

            print("gnuplot<<EOF")
            print(dumpGNUPlotPointScript(output: "Chart-\(filePrefix).png", data: "\(filePrefix).dat", title: plot.0, configuration: plot.2))
            print("EOF")

            print("open Chart-\(filePrefix).png")
        }

        UIApplication.sharedApplication().fakeContentSizeCategory(originalSize)
    }

    static func dumpGNUPlotPointScript(output output: String, data: String, title: String, configuration: [String]) -> String {
        var lines = [
            "set terminal png",
            "set key outside",
            "set output '\(output)'",
            "set xlabel 'Content Size Category'",
            "set ylabel '\(title)'",
            "set title  '\(title) by Content Size Category'",
            "set xtic rotate",
            ]
        lines.append(contentsOf: configuration)
        lines.append("")
        lines.append("plot \\")
        for (index, font) in UIFont.allStyleFonts.enumerated() {
            let line = "'\(data)' u 2:\(index + 3):xtic(1) w lp title '\(font.textStyleName)', \\"
            lines.append(line)
        }
        lines.append("")

        return lines.joinWithSeparator("\n")
    }

    static func dumpGNUPlotData(capture: (UIFont) -> String) -> String {
        // Generate Header
        var lines = ["# Content Size, \(UIFont.allStyleFonts.map() {$0.textStyleName }.joinWithSeparator(", "))"]
        for (index,size) in UIApplication.contentSizeCategoriesToTest.enumerate() {
            UIApplication.sharedApplication().fakeContentSizeCategory(size)

            var data = UIFont.allStyleFonts.map() { capture($0) }
            data.insert("\(index)", atIndex: 0)
            data.insert("\(displayName(contentSizeCategory: size))", atIndex: 0)

            lines.append(data.joinWithSeparator(", "))
        }

        return lines.joinWithSeparator("\n")
    }

    static func displayName(contentSizeCategory contentSizeCategory: String) -> String {
        let display = contentSizeCategory
            .stringByReplacingOccurrencesOfString("UICTContentSizeCategory", withString: "")
            .stringByReplacingOccurrencesOfString("Accessibility", withString: "A11Y-")
        
        return display
    }

}

#endif
