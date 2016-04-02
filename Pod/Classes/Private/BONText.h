//
//  BONText.h
//  BonMot
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

@import UIKit;

#import "BONCompatibility.h"
#import "BONTypes.h"

@class BONText;

@interface BONText : NSObject

// Appending

@property (copy, nonatomic, BONNullable) BONText *nextText;

// Font Properties

- (void)setFontName:(BONNonnull NSString *)fontName size:(CGFloat)fontSize;
@property (copy, nonatomic, readonly, BONNullable) NSString *fontName;
@property (nonatomic, readonly) CGFloat fontSize;

@property (strong, nonatomic, BONNullable) UIFont *font;

@property (strong, nonatomic, BONNullable) UIColor *textColor;
@property (strong, nonatomic, BONNullable) UIColor *backgroundColor;

// adobeTracking and pointTracking are two interpretations of the same unit. They cannot both be set - if one is set to any value, the other is set to 0.
@property (nonatomic) NSInteger adobeTracking;
@property (nonatomic) CGFloat pointTracking;

@property (nonatomic) CGFloat firstLineHeadIndent;
@property (nonatomic) CGFloat headIndent;
@property (nonatomic) CGFloat tailIndent;
@property (nonatomic) CGFloat lineHeightMultiple;
@property (nonatomic) CGFloat maximumLineHeight;
@property (nonatomic) CGFloat minimumLineHeight;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) NSLineBreakMode lineBreakMode;
@property (nonatomic) CGFloat paragraphSpacingAfter;
@property (nonatomic) CGFloat paragraphSpacingBefore;

@property (nonatomic) CGFloat baselineOffset;

/**
 *  Defaults to @c NSTextAlignmentNatural.
 */
@property (nonatomic) NSTextAlignment alignment;

@property (nonatomic) BONFigureCase figureCase;
@property (nonatomic) BONFigureSpacing figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, BONNullable) NSString *string;
@property (strong, nonatomic, BONNullable) UIImage *image;

/**
 *  Space, in points, to apply after a preceding image or string. A combination of @c headIndent and tab stops is used to indent the whole leading edge of the paragram, except for the preceding image or string, by the same amount, so they line up vertically. Must be greater than 0.
 *
 *  @note Using this property will overwrite the @c headIndent property for the paragraph.
 */
@property (nonatomic) CGFloat indentSpacer;

@property (nonatomic) NSUnderlineStyle underlineStyle;
@property (strong, nonatomic, BONNullable) UIColor *underlineColor;

@property (nonatomic) NSUnderlineStyle strikethroughStyle;
@property (strong, nonatomic, BONNullable) UIColor *strikethroughColor;

// Getting Values Out

@property (copy, nonatomic, readonly, BONNonnull) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly, BONNonnull) BONStringDict *attributes;

/**
 *  @c YES if and only if the resulting @c attributedString will be the empty attributed string.
 */
@property (nonatomic, readonly) BOOL generatesEmptyString;

// Utilities

/**
 *  Calls [self debugStringIncludeImageAddresses:YES]
 *
 *  @return The debug string, including pointer addresses of attached images.
 */
- (BONNonnull NSString *)debugString;

/**
 *  Returns a representation of the string that puts each character on a new line, and describes whitespace and other characters in a human-readable way. Pass @c NO if you are using this method to write unit tests or other cases where the string value must be deterministic.
 *
 *  @return The debug string.
 */
- (BONNonnull NSString *)debugStringIncludeImageAddresses:(BOOL)includeImageAddresses;

@end
