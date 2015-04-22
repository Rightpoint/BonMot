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

typedef RZManuscript*(^RZManuscriptChainLinkFontNameAndSize)(NSString *fontName, CGFloat fontSize);
typedef RZManuscript*(^RZManuscriptChainLinkFont)(UIFont *font);
typedef RZManuscript*(^RZManuscriptChainLinkAdobeTracking)(NSInteger adobeTracking);
typedef RZManuscript*(^RZManuscriptChainLinkPointTracking)(CGFloat pointTracking);
typedef RZManuscript*(^RZManuscriptChainLinkLineHeight)(CGFloat lineHeightMultiple);
typedef RZManuscript*(^RZManuscriptChainLinkBaselineOffset)(CGFloat baselineOffset);
typedef RZManuscript*(^RZManuscriptChainLinkFigureCase)(RZFigureCase figureCase);
typedef RZManuscript*(^RZManuscriptChainLinkFigureSpacing)(RZFigureSpacing figureSpacing);
typedef RZManuscript*(^RZManuscriptChainLinkString)(NSString *string);
typedef RZManuscript*(^RZManuscriptChainLinkImage)(UIImage *image);

@interface RZManuscript : NSObject <NSCopying>

// Getting Values Out

@property (copy, nonatomic, readonly) NSAttributedString *write;
@property (copy, nonatomic, readonly) NSDictionary *attributes;

// Chain Links

// fontNameAndSize and font are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) RZManuscriptChainLinkFontNameAndSize fontNameAndSize;
+ (RZManuscriptChainLinkFontNameAndSize)fontNameAndSize;

@property (copy, nonatomic, readonly) RZManuscriptChainLinkFont font;
+ (RZManuscriptChainLinkFont)font;

// adobeTracking and pointTracking are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) RZManuscriptChainLinkAdobeTracking adobeTracking;
+ (RZManuscriptChainLinkAdobeTracking)adobeTracking;
@property (copy, nonatomic, readonly) RZManuscriptChainLinkPointTracking pointTracking;
+ (RZManuscriptChainLinkPointTracking)pointTracking;

@property (copy, nonatomic, readonly) RZManuscriptChainLinkLineHeight lineHeightMultiple;
+ (RZManuscriptChainLinkLineHeight)lineHeightMultiple; // todo: also do line height in points

@property (copy, nonatomic, readonly) RZManuscriptChainLinkBaselineOffset baselineOffset;
+ (RZManuscriptChainLinkBaselineOffset)baselineOffset;

@property (copy, nonatomic, readonly) RZManuscriptChainLinkFigureCase figureCase;
+ (RZManuscriptChainLinkFigureCase)figureCase;
@property (copy, nonatomic, readonly) RZManuscriptChainLinkFigureSpacing figureSpacing;
+ (RZManuscriptChainLinkFigureSpacing)figureSpacing;

// string and image are mutually exclusive: setting one will unset the other
@property (copy, nonatomic, readonly) RZManuscriptChainLinkString string;
+ (RZManuscriptChainLinkString)string;
@property (copy, nonatomic, readonly) RZManuscriptChainLinkImage image;
+ (RZManuscriptChainLinkImage)image;

// Utilities

+ (NSAttributedString *)joinManuscripts:(NSArray *)manuscripts withSeparator:(RZManuscript *)separator;

@end
