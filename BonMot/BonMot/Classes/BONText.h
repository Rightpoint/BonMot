//
//  BONText.h
//  Pods
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

@import UIKit;

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

@interface BONText : NSObject <NSCopying>

// Appending

@property (strong, nonatomic) BONText *nextText;

// Font Properties

- (void)setFontName:(NSString *)fontName size:(CGFloat)fontSize;
@property (copy, nonatomic, readonly) NSString *fontName;
@property (assign, nonatomic, readonly) CGFloat fontSize;

@property (strong, nonatomic) UIFont *font;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *backgroundColor;

// adobeTracking and pointTracking are two interpretations of the same unit. If both are nonzero, Adobe tracking takes precedence.
@property (assign, nonatomic) CGFloat adobeTracking;
@property (assign, nonatomic) CGFloat pointTracking;

@property (assign, nonatomic) CGFloat lineHeightMultiple;

@property (assign, nonatomic) CGFloat baselineOffset;

@property (assign, nonatomic) BONFigureCase figureCase;
@property (assign, nonatomic) BONFigureSpacing figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic) NSString *string;
@property (strong, nonatomic) UIImage *image;

/**
 *  This string is appended, using the same attributes as @c self, if this text has another text appended to it. If this value is set, @c indentSpacer is unset.
 */
@property (copy, nonatomic) NSString *trailingString;

/**
 *  Space, in points, to apply after a preceding image or string. A combination of @headIndent and tab stops is used to indent the whole leading edge of the paragram, except for the preceding image or string, by the same amount, so they line up vertically. Must be greater than 0. If this value is set, @c trailingString is unset.
 */
@property (assign, nonatomic) CGFloat indentSpacer;

// Getting Values Out

@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) NSDictionary *attributes;

// Utilities

/**
 *  Constructs and returns an @c NSAttributedString object that is the result of interposing a given separator between the elements of the array.
 *
 *  @param texts     An array of @c BONText objects to join.
 *  @param separator The @c BONText to interpose between the elements of the array. May be @c nil.
 *  @note the menuscripts’ @c trailingString property is ignored.
 *
 *  @return An @c NSAttributedString object that is the result of interposing separator’s attributed string between the attributed strings of the elements of the array. If the array has no elements, returns an @c NSAttributedString object representing an empty string.
 */
+ (NSAttributedString *)joinTexts:(NSArray *)texts withSeparator:(BONText *)separator;

/**
 *  Used by -debugDescription to print the attributed string, one character at a time, with special characters and image attachments described.
 *
 *  @param includeImageAddresses Whether to print the pointer addresses of attached images in the description. Pass @c NO if you are using this method to write unit tests or other cases where the string value must be deterministic.
 *
 *  @return The debug string, using the specified option for including image addresses.
 */
- (NSString *)debugDescriptionIncludeImageAddresses:(BOOL)includeImageAddresses;

/**
 *  Calls [self debugDescriptionIncludingImageAddresses:YES]
 *
 *  @return The debug string, including pointers of attached images.
 */
- (NSString *)debugDescription;

@end
