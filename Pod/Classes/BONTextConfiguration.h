//
//  BONTextConfiguration.h
//  Pods
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

@import UIKit;

typedef NS_ENUM(NSUInteger, RZFigureCase) {
    RZFigureCaseDefault = 0,
    RZFigureCaseLining,
    RZFigureCaseOldstyle,
};

typedef NS_ENUM(NSUInteger, RZFigureSpacing) {
    RZFigureSpacingDefault = 0,
    RZFigureSpacingTabular,
    RZFigureSpacingProportional,
};

@class BONTextConfiguration;

@interface BONTextConfiguration : NSObject <NSCopying>

// Appending

@property (strong, nonatomic) BONTextConfiguration *nextTextConfiguration;

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

@property (assign, nonatomic) RZFigureCase figureCase;
@property (assign, nonatomic) RZFigureSpacing figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic) NSString *string;
@property (strong, nonatomic) UIImage *image;

/**
 *  This string is appended, using the same attributes as @c self, if this text configuration has another text configuration appended to it.
 */
@property (copy, nonatomic) NSString *trailingString;

// Getting Values Out

@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) NSDictionary *attributes;

// Utilities

/**
 *  Constructs and returns an @c NSAttributedString object that is the result of interposing a given separator between the elements of the array.
 *
 *  @param textConfiguration An array of @c BONTextConfiguration objects to join.
 *  @param separator         The @c BONTextConfiguration to interpose between the elements of the array. May be @c nil.
 *  @note the menuscripts’ @c trailingString property is ignored.
 *
 *  @return An @c NSAttributedString object that is the result of interposing separator’s attributed string between the attributed strings of the elements of the array. If the array has no elements, returns an @c NSAttributedString object representing an empty string.
 */
+ (NSAttributedString *)joinTextConfigurations:(NSArray *)textConfiguration withSeparator:(BONTextConfiguration *)separator;

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
