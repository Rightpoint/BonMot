//
//  Compatibility+Tests.swift
//  BonMot
//
//  Created by Brian King on 9/13/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import BonMot

#if os(OSX)
    import AppKit
    let BONFontDescriptorFeatureSettingsAttribute = NSFontDescriptor.AttributeName.featureSettings
    let BONFontFeatureTypeIdentifierKey = NSFontDescriptor.FeatureKey.typeIdentifier
    let BONFontFeatureSelectorIdentifierKey = NSFontDescriptor.FeatureKey.selectorIdentifier
    typealias BONView = NSView
#else
    import UIKit
    let BONFontDescriptorFeatureSettingsAttribute = UIFontDescriptor.AttributeName.featureSettings
    let BONFontFeatureTypeIdentifierKey = UIFontDescriptor.FeatureKey.featureIdentifier
    let BONFontFeatureSelectorIdentifierKey = UIFontDescriptor.FeatureKey.typeIdentifier
    typealias BONView = UIView
#endif

extension NSAttributedString.Key: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value)
    }

}

extension BONFontDescriptor.AttributeName: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }

}

#if os(OSX)
    #if swift(>=4.2)
    #else
        extension NSImage.Name: ExpressibleByStringLiteral {

            public init(stringLiteral value: String) {
                self.init(value)
            }

        }

        extension Bundle {
            func image(forResource resource: String) -> NSImage? {
                return image(forResource: NSImage.Name(resource))
            }
        }
    #endif
#endif

#if SWIFT_PACKAGE
    extension Bundle {
        #if os(macOS)
            typealias UXImage = NSImage
        #else
            typealias UXImage = UIImage
        #endif
      
        var spmResourcesURL : URL {
            return URL(fileURLWithPath: #file)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("Resources")
        }
        
        func testImage(forResource resource: String) -> UXImage? {
            let imgsDir = spmResourcesURL.appendingPathComponent("Images.xcassets")
            let imgDir  = imgsDir.appendingPathComponent(resource)
                                 .appendingPathExtension("imageset")
            
            let pngFile = imgDir .appendingPathComponent(resource)
                                 .appendingPathExtension("png")
            let pdfFile = imgDir .appendingPathComponent(resource)
                                 .appendingPathExtension("pdf")
          
            if FileManager.default.fileExists(atPath: pngFile.path) {
              return UXImage(contentsOfFile: pngFile.path)
            }
            if FileManager.default.fileExists(atPath: pdfFile.path) {
              return UXImage(contentsOfFile: pdfFile.path)
            }
          
            if let data = try? Data(contentsOf:
                                 imgDir.appendingPathComponent("Contents.json")),
               let json = try? JSONSerialization.jsonObject(with: data, options: [])
                          as? [ String : Any ],
               let images = json["images"] as? [ [ String : Any ] ],
               let filename = images.first?["filename"] as? String
            {
              let someImage = imgDir.appendingPathComponent(filename)
              if FileManager.default.fileExists(atPath: someImage.path) {
                  return UXImage(contentsOfFile: someImage.path)
              }
            }
                      
            return image(forResource: resource)
        }
    }
#else // regular Xcode build
    extension Bundle {
        #if os(macOS)
            func testImage(forResource resource: String) -> NSImage? {
                return image(forResource: resource)
            }
        #else
            func testImage(forResource resource: String) -> UIImage? {
                return UIImage(named: resource, in: self, compatibleWith: nil)
            }
        #endif
    }
#endif
