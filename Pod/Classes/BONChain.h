//
//  BONChain.h
//  BonMot
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

@import Foundation;

#import "BONText.h"
#import "BONCompatibility.h"

BON_ASSUME_NONNULL_BEGIN

@class BONChain;
@class BONTag;

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
typedef BONChain *BONCNonnull (^BONChainHyphenationFactor)(CGFloat hyphenationFactor);
typedef BONChain *BONCNonnull (^BONChainAlignment)(NSTextAlignment alignment);
typedef BONChain *BONCNonnull (^BONChainFigureCase)(BONFigureCase figureCase);
typedef BONChain *BONCNonnull (^BONChainFigureSpacing)(BONFigureSpacing figureSpacing);
typedef BONChain *BONCNonnull (^BONChainIndentSpacer)(CGFloat indentSpacer);
typedef BONChain *BONCNonnull (^BONChainString)(NSString *BONCNullable string);
typedef BONChain *BONCNonnull (^BONChainImage)(UIImage *BONCNullable image);
typedef BONChain *BONCNonnull (^BONChainURL)(NSURL *BONCNullable url);

typedef BONChain *BONCNonnull (^BONChainUnderlineStyle)(NSUnderlineStyle style);
typedef BONChain *BONCNonnull (^BONChainUnderlineColor)(UIColor *BONCNullable color);

typedef BONChain *BONCNonnull (^BONChainStrikethroughStyle)(NSUnderlineStyle style);
typedef BONChain *BONCNonnull (^BONChainStrikethroughColor)(UIColor *BONCNullable color);

typedef BONChain *BONCNonnull (^BONTagStyles)(BONGeneric(NSDictionary, NSString *, id<BONTextable>) * BONCNullable styles);
typedef BONChain *BONCNonnull (^BONTagComplexStyles)(BONGeneric(NSArray, BONTag *) * BONCNullable styles);

@interface BONChain : NSObject <BONTextable>

@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) BONStringDict *attributes;

// fontNameAndSize and font are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) BONChainFontNameAndSize fontNameAndSize;

@property (copy, nonatomic, readonly) BONChainFont font;

@property (copy, nonatomic, readonly) BONChainColor color;
@property (copy, nonatomic, readonly) BONChainColor backgroundColor;
@property (copy, nonatomic, readonly) BONChainURL url;

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

/**
 *  Hyphenation is attempted when the ratio of the text width (as broken without hyphenation) to the width of the line fragment is less than the hyphenation factor. When the paragraph’s hyphenation factor is 0.0, the layout manager’s hyphenation factor is used instead. When both are 0.0, hyphenation is disabled. Values from 0 to 1 will result in varying levels of hyphenation, with higher values resulting in more aggressive (i.e. more frequent) hyphenation.
 */
@property (copy, nonatomic, readonly) BONChainHyphenationFactor hyphenationFactor;

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

/**
 *  Assign @p BONTextables to use in styling substrings surrounded by given tags.
 *  For example, ["b": boldChain] would apply the @p boldChain
 *  to any substring surrounded by <b></b> and remove the tags from the resulting
 *  attributed string. Nested tagging is not supported.
 */
@property (copy, nonatomic, readonly) BONTagStyles tagStyles;

/**
 *  Assign an array of @p BONTags to use in styling substrings.
 */
@property (copy, nonatomic, readonly) BONTagComplexStyles tagComplexStyles;

// concatenation
- (void)appendLink:(id<BONTextable>)link;
- (void)appendLink:(id<BONTextable>)link separatorTextable:(BONNullable id<BONTextable>)separator;

@end

@interface BONChain (Deprecated)

@property (copy, nonatomic, readonly) BONChainColor textColor __attribute__((deprecated("use -color instead")));

- (void)appendLink:(id<BONTextable>)link separator:(BONNullable NSString *)separator __attribute__((deprecated("use -appendLink:separatorTextable: instead")));

@end

BON_ASSUME_NONNULL_END
