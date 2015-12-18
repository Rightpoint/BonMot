//
//  BONText.h
//  Pods
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

@import UIKit;

#import "BONChainable.h"

typedef NS_ENUM(NSUInteger, BONFigureCase) {
    BONFigureCaseDefault = 0,
    BONFigureCaseLining,
    BONFigureCaseOldstyle,
};

typedef NS_ENUM(NSUInteger, BONFigureSpacing) {
    BONFigureSpacingDefault = 0,
    BONFigureSpacingTabular,
    BONFigureSpacingProportional,
};

@class BONText;

@interface BONText : NSObject <NSCopying, BONChainable>

// Appending

@property (copy, nonatomic) BONText *nextText;

// Font Properties

- (void)setFontName:(NSString *)fontName size:(CGFloat)fontSize;
@property (copy, nonatomic, readonly) NSString *fontName;
@property (nonatomic, readonly) CGFloat fontSize;

@property (strong, nonatomic) UIFont *font;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *backgroundColor;

// adobeTracking and pointTracking are two interpretations of the same unit. They cannot both be set - if one is set to any value, the other is set to 0.
@property (nonatomic) NSInteger adobeTracking;
@property (nonatomic) CGFloat pointTracking;

@property (nonatomic) CGFloat lineHeightMultiple;
@property (nonatomic) CGFloat lineSpacing;

@property (nonatomic) CGFloat baselineOffset;

/**
 *  Defaults to @c NSTextAlignmentNatural.
 */
@property (nonatomic) NSTextAlignment alignment;

@property (nonatomic) BONFigureCase figureCase;
@property (nonatomic) BONFigureSpacing figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic) NSString *string;
@property (strong, nonatomic) UIImage *image;

/**
 *  Space, in points, to apply after a preceding image or string. A combination of @c headIndent and tab stops is used to indent the whole leading edge of the paragram, except for the preceding image or string, by the same amount, so they line up vertically. Must be greater than 0.
 */
@property (nonatomic) CGFloat indentSpacer;

@property (nonatomic) NSUnderlineStyle underlineStyle;
@property (strong, nonatomic) UIColor *underlineColor;

// Getting Values Out

@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) NSDictionary *attributes;

// Utilities

/**
 *  Constructs and returns an @c NSAttributedString object that is the result of interposing a given separator between the elements of the array.
 *
 *  @param texts     An array of @c BONText objects to join.
 *  @param separator The @c BONText to interpose between the elements of the array. May be @c nil.
 *
 *  @return An @c NSAttributedString object that is the result of interposing separator’s attributed string between the attributed strings of the elements of the array. If the array has no elements, returns an @c NSAttributedString object representing an empty string.
 */
+ (NSAttributedString *)joinTexts:(NSArray *)texts withSeparator:(BONText *)separator;

/**
 *  Calls [self debugStringIncludeImageAddresses:YES]
 *
 *  @return The debug string, including pointer addresses of attached images.
 */
- (NSString *)debugString;

/**
 *  Returns a representation of the string that puts each character on a new line, and describes whitespace and other characters in a human-readable way. Pass @c NO if you are using this method to write unit tests or other cases where the string value must be deterministic.
 *
 *  @return The debug string.
 */
- (NSString *)debugStringIncludeImageAddresses:(BOOL)includeImageAddresses;

@end

@interface BONText (BONDeprecated)

/**
 *  Formerly used by -debugDescription to print the attributed string, one character at a time, with special characters and image attachments described.
 *
 *  @param includeImageAddresses Whether to print the pointer addresses of attached images in the description. Pass @c NO if you are using this method to write unit tests or other cases where the string value must be deterministic.
 *
 *  @return The debug string, using the specified option for including image addresses.
 */
- (NSString *)debugDescriptionIncludeImageAddresses:(BOOL)includeImageAddresses __attribute((deprecated("use -debugStringIncludingImageAddresses:")));

@end
