//
//  RZChainLink.h
//  Pods
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

@import Foundation;

#import <manuscript/RZManuscript.h>

#define RZCursive [[RZChainLink alloc] init]

@class RZChainLink;

typedef RZChainLink*(^RZChainLinkFontNameAndSize)(NSString *fontName, CGFloat fontSize);
typedef RZChainLink*(^RZChainLinkFont)(UIFont *font);
typedef RZChainLink*(^RZChainLinkColor)(UIColor *color);
typedef RZChainLink*(^RZChainLinkAdobeTracking)(NSInteger adobeTracking);
typedef RZChainLink*(^RZChainLinkPointTracking)(CGFloat pointTracking);
typedef RZChainLink*(^RZChainLinkLineHeight)(CGFloat lineHeightMultiple);
typedef RZChainLink*(^RZChainLinkBaselineOffset)(CGFloat baselineOffset);
typedef RZChainLink*(^RZChainLinkFigureCase)(RZFigureCase figureCase);
typedef RZChainLink*(^RZChainLinkFigureSpacing)(RZFigureSpacing figureSpacing);
typedef RZChainLink*(^RZChainLinkString)(NSString *string);
typedef RZChainLink*(^RZChainLinkImage)(UIImage *image);

@interface RZChainLink : NSObject <NSCopying>

@property (copy, nonatomic, readonly) RZManuscript *manuscript;
@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) NSDictionary *attributes;

// fontNameAndSize and font are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) RZChainLinkFontNameAndSize fontNameAndSize;

@property (copy, nonatomic, readonly) RZChainLinkFont font;

@property (copy, nonatomic, readonly) RZChainLinkColor textColor;
@property (copy, nonatomic, readonly) RZChainLinkColor backgroundColor;

// adobeTracking and pointTracking are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) RZChainLinkAdobeTracking adobeTracking;
@property (copy, nonatomic, readonly) RZChainLinkPointTracking pointTracking;

@property (copy, nonatomic, readonly) RZChainLinkLineHeight lineHeightMultiple;

@property (copy, nonatomic, readonly) RZChainLinkBaselineOffset baselineOffset;

@property (copy, nonatomic, readonly) RZChainLinkFigureCase figureCase;
@property (copy, nonatomic, readonly) RZChainLinkFigureSpacing figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) RZChainLinkString string;
@property (copy, nonatomic, readonly) RZChainLinkImage image;

@end
