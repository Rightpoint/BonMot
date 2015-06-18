//
//  BONChainLink.h
//  Pods
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

@import Foundation;

#import <BonMot/BONTextConfiguration.h>

#define RZCursive [[BONChainLink alloc] init]

@class BONChainLink;

typedef BONChainLink*(^BONChainLinkFontNameAndSize)(NSString *fontName, CGFloat fontSize);
typedef BONChainLink*(^BONChainLinkFont)(UIFont *font);
typedef BONChainLink*(^BONChainLinkColor)(UIColor *color);
typedef BONChainLink*(^BONChainLinkAdobeTracking)(NSInteger adobeTracking);
typedef BONChainLink*(^BONChainLinkPointTracking)(CGFloat pointTracking);
typedef BONChainLink*(^BONChainLinkLineHeight)(CGFloat lineHeightMultiple);
typedef BONChainLink*(^BONChainLinkBaselineOffset)(CGFloat baselineOffset);
typedef BONChainLink*(^BONChainLinkFigureCase)(RZFigureCase figureCase);
typedef BONChainLink*(^BONChainLinkFigureSpacing)(RZFigureSpacing figureSpacing);
typedef BONChainLink*(^BONChainLinkString)(NSString *string);
typedef BONChainLink*(^BONChainLinkImage)(UIImage *image);
typedef BONChainLink*(^BONChainLinkAppend)(id chainLinkOrTextConfiguration);
typedef BONChainLink*(^BONChainLinkAppendWithSeparator)(NSString *separator, id chainLinkOrTextConfiguration);

@interface BONChainLink : NSObject <NSCopying>

@property (strong, nonatomic, readonly) BONTextConfiguration *textConfiguration;
@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) NSDictionary *attributes;

// fontNameAndSize and font are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainLinkFontNameAndSize fontNameAndSize;

@property (copy, nonatomic, readonly) BONChainLinkFont font;

@property (copy, nonatomic, readonly) BONChainLinkColor textColor;
@property (copy, nonatomic, readonly) BONChainLinkColor backgroundColor;

// adobeTracking and pointTracking are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainLinkAdobeTracking adobeTracking;
@property (copy, nonatomic, readonly) BONChainLinkPointTracking pointTracking;

@property (copy, nonatomic, readonly) BONChainLinkLineHeight lineHeightMultiple;

@property (copy, nonatomic, readonly) BONChainLinkBaselineOffset baselineOffset;

@property (copy, nonatomic, readonly) BONChainLinkFigureCase figureCase;
@property (copy, nonatomic, readonly) BONChainLinkFigureSpacing figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainLinkString string;
@property (copy, nonatomic, readonly) BONChainLinkImage image;

// concatenation
@property (copy, nonatomic, readonly) BONChainLinkAppend append;
@property (copy, nonatomic, readonly) BONChainLinkAppendWithSeparator appendWithSeparator;

@end
