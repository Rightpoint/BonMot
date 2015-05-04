//
//  RZManuscript.h
//  Pods
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

@import Foundation;

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

@class RZManuscript;

@interface RZManuscript : NSObject <NSCopying>

// Getting Values Out

@property (copy, nonatomic, readonly) NSAttributedString *attributedString;
@property (copy, nonatomic, readonly) NSDictionary *attributes;

// Chain Links

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

- (void)setFontName:(NSString *)fontName size:(CGFloat)fontSize;

// Utilities

/**
 *  Constructs and returns an @c NSAttributedString object that is the result of interposing a given separator between the elements of the array.
 *
 *  @param manuscripts An array of @c RZManuscript objects to join.
 *  @param separator   The @c RZManuscript to interpose between the elements of the array. May be nil.
 *
 *  @return An @c NSAttributedString object that is the result of interposing separator’s attributed string between the attributed strings of the elements of the array. If the array has no elements, returns an @c NSAttributedString object representing an empty string.
 */
+ (NSAttributedString *)joinManuscripts:(NSArray *)manuscripts withSeparator:(RZManuscript *)separator;

@end
