//
//  BONChain.h
//  Pods
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

@import Foundation;

#import "BONText.h"

@class BONChain;

typedef BONChain*(^BONChainFontNameAndSize)(NSString *fontName, CGFloat fontSize);
typedef BONChain*(^BONChainFont)(UIFont *font);
typedef BONChain*(^BONChainColor)(UIColor *color);
typedef BONChain*(^BONChainAdobeTracking)(NSInteger adobeTracking);
typedef BONChain*(^BONChainPointTracking)(CGFloat pointTracking);
typedef BONChain*(^BONChainLineHeight)(CGFloat lineHeightMultiple);
typedef BONChain*(^BONChainBaselineOffset)(CGFloat baselineOffset);
typedef BONChain*(^BONChainFigureCase)(BONFigureCase figureCase);
typedef BONChain*(^BONChainFigureSpacing)(BONFigureSpacing figureSpacing);
typedef BONChain*(^BONChainIndentSpacer)(CGFloat indentSpacer);
typedef BONChain*(^BONChainString)(NSString *string);
typedef BONChain*(^BONChainImage)(UIImage *image);

@interface BONChain : NSObject <NSCopying, BONChainable>

@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) NSDictionary *attributes;

// fontNameAndSize and font are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainFontNameAndSize fontNameAndSize;

@property (copy, nonatomic, readonly) BONChainFont font;

@property (copy, nonatomic, readonly) BONChainColor textColor;
@property (copy, nonatomic, readonly) BONChainColor backgroundColor;

// adobeTracking and pointTracking are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainAdobeTracking adobeTracking;
@property (copy, nonatomic, readonly) BONChainPointTracking pointTracking;

@property (copy, nonatomic, readonly) BONChainLineHeight lineHeightMultiple;

@property (copy, nonatomic, readonly) BONChainBaselineOffset baselineOffset;

@property (copy, nonatomic, readonly) BONChainFigureCase figureCase;
@property (copy, nonatomic, readonly) BONChainFigureSpacing figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainString string;
@property (copy, nonatomic, readonly) BONChainImage image;

/**
 *  Must be greater than 0.
 */
@property (copy, nonatomic, readonly) BONChainIndentSpacer indentSpacer;

// concatenation
- (void)appendLink:(id<BONChainable>)link;
- (void)appendLink:(id<BONChainable>)link separator:(NSString *)separator;

@end
