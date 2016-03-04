//
//  BONChain.h
//  Pods
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

@import Foundation;

#import "BONText.h"

NS_ASSUME_NONNULL_BEGIN

@class BONChain;

typedef BONChain *_Nonnull (^BONChainFontNameAndSize)(NSString *fontName, CGFloat fontSize);
typedef BONChain *_Nonnull (^BONChainFont)(UIFont *font);
typedef BONChain *_Nonnull (^BONChainColor)(UIColor *color);
typedef BONChain *_Nonnull (^BONChainAdobeTracking)(NSInteger adobeTracking);
typedef BONChain *_Nonnull (^BONChainPointTracking)(CGFloat pointTracking);
typedef BONChain *_Nonnull (^BONChainFirstLineHeadIndent)(CGFloat firstLineHeadIndent);
typedef BONChain *_Nonnull (^BONChainHeadIndent)(CGFloat headIndent);
typedef BONChain *_Nonnull (^BONChainTailIndent)(CGFloat tailIndent);
typedef BONChain *_Nonnull (^BONChainLineHeight)(CGFloat lineHeightMultiple);
typedef BONChain *_Nonnull (^BONChainMaximumLineHeight)(CGFloat maximumLineHeight);
typedef BONChain *_Nonnull (^BONChainMinimumLineHeight)(CGFloat minimumLineHeight);
typedef BONChain *_Nonnull (^BONChainLineSpacing)(CGFloat lineSpacing);
typedef BONChain *_Nonnull (^BONChainParagraphSpacingAfter)(CGFloat paragraphSpacing);
typedef BONChain *_Nonnull (^BONChainParagraphSpacingBefore)(CGFloat paragraphSpacingBefore);
typedef BONChain *_Nonnull (^BONChainBaselineOffset)(CGFloat baselineOffset);
typedef BONChain *_Nonnull (^BONChainAlignment)(NSTextAlignment alignment);
typedef BONChain *_Nonnull (^BONChainFigureCase)(BONFigureCase figureCase);
typedef BONChain *_Nonnull (^BONChainFigureSpacing)(BONFigureSpacing figureSpacing);
typedef BONChain *_Nonnull (^BONChainIndentSpacer)(CGFloat indentSpacer);
typedef BONChain *_Nonnull (^BONChainString)(NSString *string);
typedef BONChain *_Nonnull (^BONChainImage)(UIImage *image);

typedef BONChain *_Nonnull (^BONChainUnderlineStyle)(NSUnderlineStyle style);
typedef BONChain *_Nonnull (^BONChainUnderlineColor)(UIColor *color);

typedef BONChain *_Nonnull (^BONChainStrikethroughStyle)(NSUnderlineStyle style);
typedef BONChain *_Nonnull (^BONChainStrikethroughColor)(UIColor *color);

@interface BONChain : NSObject <NSCopying, BONChainable>

@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) NSDictionary<NSString *, id> *attributes;

// fontNameAndSize and font are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainFontNameAndSize fontNameAndSize;

@property (copy, nonatomic, readonly) BONChainFont font;

@property (copy, nonatomic, readonly) BONChainColor textColor;
@property (copy, nonatomic, readonly) BONChainColor backgroundColor;

// adobeTracking and pointTracking are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainAdobeTracking adobeTracking;
@property (copy, nonatomic, readonly) BONChainPointTracking pointTracking;

@property (copy, nonatomic, readonly) BONChainFirstLineHeadIndent firstLineHeadIndent;
@property (copy, nonatomic, readonly) BONChainHeadIndent headIndent;
@property (copy, nonatomic, readonly) BONChainTailIndent tailIndent;
@property (copy, nonatomic, readonly) BONChainLineHeight lineHeightMultiple;
@property (copy, nonatomic, readonly) BONChainMaximumLineHeight maximumLineHeight;
@property (copy, nonatomic, readonly) BONChainMinimumLineHeight minimumLineHeight;
@property (copy, nonatomic, readonly) BONChainLineSpacing lineSpacing;
@property (copy, nonatomic, readonly) BONChainParagraphSpacingAfter paragraphSpacingAfter;
@property (copy, nonatomic, readonly) BONChainParagraphSpacingBefore paragraphSpacingBefore;

@property (copy, nonatomic, readonly) BONChainBaselineOffset baselineOffset;

@property (copy, nonatomic, readonly) BONChainAlignment alignment;

@property (copy, nonatomic, readonly) BONChainFigureCase figureCase;
@property (copy, nonatomic, readonly) BONChainFigureSpacing figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainString string;
@property (copy, nonatomic, readonly) BONChainImage image;

/**
 *  Must be greater than 0.
 */
@property (copy, nonatomic, readonly) BONChainIndentSpacer indentSpacer;

@property (copy, nonatomic, readonly) BONChainUnderlineStyle underlineStyle;
@property (copy, nonatomic, readonly) BONChainUnderlineColor underlineColor;

@property (copy, nonatomic, readonly) BONChainStrikethroughStyle strikethroughStyle;
@property (copy, nonatomic, readonly) BONChainStrikethroughColor strikethroughColor;

// concatenation
- (void)appendLink:(id<BONChainable>)link;
- (void)appendLink:(id<BONChainable>)link separator:(NSString *_Nullable)separator;

@end

NS_ASSUME_NONNULL_END
