//
//  BONChain.h
//  BonMot
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

@import Foundation;

#import "BONCompatibility.h"
#import "BONTypes.h"

BON_ASSUME_NONNULL_BEGIN

@class BONChain;

typedef BONChain *BONCNonnull (^BONChainFontNameAndSize)(NSString *BONCNonnull fontName, CGFloat fontSize);
typedef BONChain *BONCNonnull (^BONChainFont)(UIFont *BONCNullable font);
typedef BONChain *BONCNonnull (^BONChainColor)(UIColor *BONCNullable color);
typedef BONChain *BONCNonnull (^BONChainAdobeTracking)(NSInteger adobeTracking);
typedef BONChain *BONCNonnull (^BONChainPointTracking)(CGFloat pointTracking);
typedef BONChain *BONCNonnull (^BONChainFirstLineHeadIndent)(CGFloat firstLineHeadIndent);
typedef BONChain *BONCNonnull (^BONChainHeadIndent)(CGFloat headIndent);
typedef BONChain *BONCNonnull (^BONChainTailIndent)(CGFloat tailIndent);
typedef BONChain *BONCNonnull (^BONChainLineHeight)(CGFloat lineHeightMultiple);
typedef BONChain *BONCNonnull (^BONChainMaximumLineHeight)(CGFloat maximumLineHeight);
typedef BONChain *BONCNonnull (^BONChainMinimumLineHeight)(CGFloat minimumLineHeight);
typedef BONChain *BONCNonnull (^BONChainLineSpacing)(CGFloat lineSpacing);
typedef BONChain *BONCNonnull (^BONChainLineBreakMode)(NSLineBreakMode lineBreakMode);
typedef BONChain *BONCNonnull (^BONChainParagraphSpacingAfter)(CGFloat paragraphSpacing);
typedef BONChain *BONCNonnull (^BONChainParagraphSpacingBefore)(CGFloat paragraphSpacingBefore);
typedef BONChain *BONCNonnull (^BONChainBaselineOffset)(CGFloat baselineOffset);
typedef BONChain *BONCNonnull (^BONChainAlignment)(NSTextAlignment alignment);
typedef BONChain *BONCNonnull (^BONChainFigureCase)(BONFigureCase figureCase);
typedef BONChain *BONCNonnull (^BONChainFigureSpacing)(BONFigureSpacing figureSpacing);
typedef BONChain *BONCNonnull (^BONChainIndentSpacer)(CGFloat indentSpacer);
typedef BONChain *BONCNonnull (^BONChainString)(NSString *BONCNullable string);
typedef BONChain *BONCNonnull (^BONChainImage)(UIImage *BONCNullable image);

typedef BONChain *BONCNonnull (^BONChainUnderlineStyle)(NSUnderlineStyle style);
typedef BONChain *BONCNonnull (^BONChainUnderlineColor)(UIColor *BONCNullable color);

typedef BONChain *BONCNonnull (^BONChainStrikethroughStyle)(NSUnderlineStyle style);
typedef BONChain *BONCNonnull (^BONChainStrikethroughColor)(UIColor *BONCNullable color);

@interface BONChain : NSObject

/**
 *  @c YES if and only if the resulting @c attributedString will be the empty attributed string.
 */
@property (nonatomic, readonly) BOOL generatesEmptyString;

@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) BONStringDict *attributes;

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
@property (copy, nonatomic, readonly) BONChainLineBreakMode lineBreakMode;
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
- (void)appendChain:(BONChain *)chain;
- (void)appendChain:(BONChain *)chain separator:(BONNullable NSString *)separator;

/**
 *  Constructs and returns an @c NSAttributedString object that is the result of interposing a given separator between the elements of the array.
 *
 *  @param chains    An array of @c BONChain objects to join.
 *  @param separator The @c BONChain to interpose between the elements of the array. May be @c nil.
 *
 *  @return An @c NSAttributedString object that is the result of interposing separator’s attributed string between the attributed strings of the elements of the array. If the array has no elements, returns an @c NSAttributedString object representing an empty string.
 */
+ (BONNonnull NSAttributedString *)joinChains:(BONNullable BONGeneric(NSArray, BONChain *) *)chains withSeparator:(BONNullable BONChain *)separator;

@end

BON_ASSUME_NONNULL_END
