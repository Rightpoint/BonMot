//
//  BONText.h
//  BonMot
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

@import UIKit;

#import "BONTextable.h"
#import "BONCompatibility.h"

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
@class BONTag;

@interface BONText : NSObject <BONTextable>

// Appending

@property (copy, nonatomic, BONNullable) BONText *nextText;

// Font Properties

- (void)setFontName:(BONNonnull NSString *)fontName size:(CGFloat)fontSize;
@property (copy, nonatomic, readonly, BONNullable) NSString *fontName;
@property (nonatomic, readonly) CGFloat fontSize;

@property (strong, nonatomic, BONNullable) UIFont *font;

@property (strong, nonatomic, BONNullable) UIColor *color;
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
@property (copy, nonatomic, BONNullable) NSURL *url;

/**
 *  Hyphenation is attempted when the ratio of the text width (as broken without hyphenation) to the width of the line fragment is less than the hyphenation factor. When the paragraph’s hyphenation factor is 0.0, the layout manager’s hyphenation factor is used instead. When both are 0.0, hyphenation is disabled. Values from 0 to 1 will result in varying levels of hyphenation, with higher values resulting in more aggressive (i.e. more frequent) hyphenation.
 */
@property (nonatomic) CGFloat hyphenationFactor;

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

/**
 *  An array of @p BONTag objects to use in styling substrings.
 */
@property (strong, nonatomic, BONNullable) BONGeneric(NSArray, BONTag *) * tagStyles;

// Getting Values Out

@property (copy, nonatomic, readonly, BONNonnull) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly, BONNonnull) BONStringDict *attributes;

/**
 *  @c YES if and only if the resulting @c attributedString will be the empty attributed string.
 */
@property (nonatomic, readonly) BOOL generatesEmptyString;

// Utilities

/**
 *  Constructs and returns an @c NSAttributedString object that is the result of interposing a given separator between the elements of the array.
 *
 *  @param textables An array of @c id<BONTextable> objects to join. If this is @c nil or empty, the empty @c NSAttributedString is returned.
 *  @param separator The @c id<BONTextable> to interpose between the elements of the array. May be @c nil.
 *
 *  @return An @c NSAttributedString object that is the result of interposing separator’s attributed string between the attributed strings of the elements of the array. If the array has no elements, returns an @c NSAttributedString object representing an empty string.
 */
+ (BONNonnull NSAttributedString *)joinTextables:(BONNullable BONGeneric(NSArray, id<BONTextable>) *)textables withSeparator:(BONNullable id<BONTextable>)separator;

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

@interface BONText (Deprecated)

@property (strong, nonatomic, BONNullable) UIColor *textColor __attribute__((deprecated("use -color instead")));

+ (BONNonnull NSAttributedString *)joinTexts:(BONNullable BONGeneric(NSArray, BONText *) *)texts withSeparator:(BONNullable BONText *)separator __attribute__((deprecated("use +joinTextables:withSeparator: instead")));

@end
