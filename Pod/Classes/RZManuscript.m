//
//  RZManuscript.m
//  Pods
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

#import "RZManuscript.h"

@import CoreText.SFNTLayoutTypes;

static const CGFloat kRZAdobeTrackingDivisor = 1000.0f;
static const CGFloat kRZDefaultFontSize = 15.0f; // per docs

@interface RZManuscript ()

@property (strong, nonatomic) UIFont *internalFont;
@property (nonatomic) NSInteger internalAdobeTracking;
@property (nonatomic) CGFloat internalPointTracking;
@property (nonatomic) CGFloat internalLineHeightMultiple;
@property (nonatomic) RZFigureCase internalFigureCase;
@property (nonatomic) RZFigureSpacing internalFigureSpacing;
@property (copy, nonatomic) NSString *internalString;

@end

@implementation RZManuscript

#pragma mark - Getting Values Out

- (NSAttributedString *)write
{
    NSString *stringToUse = @"";
    if ( self.internalString ) {
        stringToUse = self.internalString;
    }
    return [[NSAttributedString alloc] initWithString:stringToUse
                                           attributes:self.attributes];
}

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    // Figure Style

    NSMutableArray *featureSettings = [NSMutableArray array];

    // Figure Case

    if ( self.internalFigureCase != RZFigureCaseDefault ) {

        int figureCase = -1;
        switch ( self.internalFigureCase ) {
            case RZFigureCaseLining:
                figureCase = kUpperCaseNumbersSelector;
                break;
            case RZFigureCaseOldstyle:
                figureCase = kLowerCaseNumbersSelector;
                break;
            case RZFigureCaseDefault:
                [NSException raise:NSInternalInconsistencyException format:@"Logic error: we should not have RZFigureCaseDefault here."];
                break;
        }

        NSDictionary *figureCaseDictionary = @{
                                               UIFontFeatureTypeIdentifierKey: @(kNumberCaseType),
                                               UIFontFeatureSelectorIdentifierKey: @(figureCase),
                                               };

        [featureSettings addObject:figureCaseDictionary];
    }

    // Figure Spacing

    if ( self.internalFigureSpacing != RZFigureSpacingDefault ) {

        int figureSpacing = -1;
        switch ( self.internalFigureSpacing ) {
            case RZFigureSpacingTabular:
                figureSpacing = kMonospacedNumbersSelector;
                break;
            case RZFigureSpacingProportional:
                figureSpacing = kProportionalNumbersSelector;
                break;
            default:
                [NSException raise:NSInternalInconsistencyException format:@"Logic error: we should not have RZFigureSpacingDefault here."];
                break;
        }

        NSDictionary *figureSpacingDictionary = @{
                                                  UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                                                  UIFontFeatureSelectorIdentifierKey: @(figureSpacing),
                                                  };
        [featureSettings addObject:figureSpacingDictionary];

    }

    BOOL needToUseFontDescriptor = featureSettings.count > 0;

    UIFont *fontToUse = nil;

    if ( needToUseFontDescriptor ) {
        NSMutableDictionary *featureSettingsAttributes = [NSMutableDictionary dictionary];
        featureSettingsAttributes[UIFontDescriptorFeatureSettingsAttribute] = featureSettings;

        if ( self.internalFont ) {
            // get font descriptor from font
            UIFontDescriptor *descriptor = self.internalFont.fontDescriptor;
            UIFontDescriptor *descriptorToUse = [descriptor fontDescriptorByAddingAttributes:featureSettingsAttributes];
            fontToUse = [UIFont fontWithDescriptor:descriptorToUse size:self.internalFont.pointSize];
        }
        else {
            [NSException raise:NSInternalInconsistencyException format:@"If font attributes such as figure case or spacing are specified, a font must also be specified."];
        }
    }
    else {
        fontToUse = self.internalFont;
    }

    if ( fontToUse ) {
        attributes[NSFontAttributeName] = fontToUse;
    }

    // Tracking

    NSAssert(self.internalAdobeTracking == 0 || self.internalPointTracking == 0.0f, @"You may set Adobe tracking or point tracking to nonzero values, but not both");

    CGFloat trackingInPoints = 0.0f;
    if ( self.internalAdobeTracking > 0 ) {
        trackingInPoints = [self.class trackingValueFromAdobeTrackingValue:self.internalAdobeTracking forFont:fontToUse];
    }
    else if ( self.internalPointTracking > 0.0f ) {
        trackingInPoints = self.internalPointTracking;
    }

    if ( trackingInPoints > 0.0f ) {
        // TODO: look into tipoff from @infrasonick about leaving this off the last character
        attributes[NSKernAttributeName] = @(trackingInPoints);
    }
    
    // Line Height

    if ( self.internalLineHeightMultiple != 1.0f ) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = self.internalLineHeightMultiple;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }

    return attributes;
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) manuscript = [[self.class alloc] init];

    manuscript.internalFont = self.internalFont;
    manuscript.internalAdobeTracking = self.internalAdobeTracking;
    manuscript.internalPointTracking = self.internalPointTracking;
    manuscript.internalLineHeightMultiple = self.internalLineHeightMultiple;
    manuscript.internalFigureCase = self.internalFigureCase;
    manuscript.internalFigureSpacing = self.internalFigureSpacing;

    return manuscript;
}

#pragma mark - Class Chain Links

+ (RZManuscriptChainLinkFontNameAndSize)fontNameAndSize
{
    RZManuscriptChainLinkFontNameAndSize fontNameAndSizeBlock = ^(NSString *fontName, CGFloat fontSize) {
        RZManuscript *manuscript = [[RZManuscript alloc] init];
        manuscript.internalFont = [UIFont fontWithName:fontName size:fontSize];
        return manuscript;
    };
    return [fontNameAndSizeBlock copy];
}

+ (RZManuscriptChainLinkFont)font
{
    RZManuscriptChainLinkFont fontBlock = ^(UIFont *font) {
        RZManuscript *manuscript = [[RZManuscript alloc] init];
        manuscript.internalFont = font;
        return manuscript;
    };

    return [fontBlock copy];
}

+ (RZManuscriptChainLinkAdobeTracking)adobeTracking
{
    RZManuscriptChainLinkAdobeTracking adobeTrackingBlock = ^(NSInteger adobeTracking) {
        RZManuscript *manuscript = [[RZManuscript alloc] init];
        manuscript.internalAdobeTracking = adobeTracking;
        manuscript.internalPointTracking = 0.0f;
        return manuscript;
    };

    return [adobeTrackingBlock copy];
}

+ (RZManuscriptChainLinkPointTracking)pointTracking
{
    RZManuscriptChainLinkPointTracking pointTrackingBlock = ^(CGFloat pointTracking) {
        RZManuscript *manuscript = [[RZManuscript alloc] init];
        manuscript.internalPointTracking = pointTracking;
        manuscript.internalAdobeTracking = 0;
        return manuscript;
    };

    return [pointTrackingBlock copy];
}

+ (RZManuscriptChainLinkLineHeight)lineHeightMultiple
{
    RZManuscriptChainLinkLineHeight lineHeightMultipleBlock = ^(CGFloat lineHeightMultiple) {
        RZManuscript *manuscript = [[RZManuscript alloc] init];
        manuscript.internalLineHeightMultiple = lineHeightMultiple;
        return manuscript;
    };

    return [lineHeightMultipleBlock copy];
}

+ (RZManuscriptChainLinkFigureCase)figureCase
{
    RZManuscriptChainLinkFigureCase figureCaseBlock = ^(RZFigureCase figureCase) {
        RZManuscript *manuscript = [[RZManuscript alloc] init];
        manuscript.internalFigureCase = figureCase;
        return manuscript;
    };

    return [figureCaseBlock copy];
}

+ (RZManuscriptChainLinkFigureSpacing)figureSpacing
{
    RZManuscriptChainLinkFigureSpacing figureSpacingBlock = ^(RZFigureSpacing figureSpacing) {
        RZManuscript *manuscript = [[RZManuscript alloc] init];
        manuscript.internalFigureSpacing = figureSpacing;
        return manuscript;
    };

    return [figureSpacingBlock copy];
}

+ (RZManuscriptChainLinkString)string
{
    RZManuscriptChainLinkString stringBlock = ^(NSString *string) {
        RZManuscript *manuscript = [[RZManuscript alloc] init];
        manuscript.internalString = string;
        return manuscript;
    };

    return [stringBlock copy];
}

#pragma mark - Instance Chain Links

- (RZManuscriptChainLinkFontNameAndSize)fontNameAndSize
{
    RZManuscriptChainLinkFontNameAndSize fontNameAndSizeBlock = ^(NSString *fontName, CGFloat fontSize) {
        RZManuscript *newManuscript = self.copy;
        newManuscript.internalFont = [UIFont fontWithName:fontName size:fontSize];
        return self;
    };

    return [fontNameAndSizeBlock copy];
}

- (RZManuscriptChainLinkFont)font
{
    RZManuscriptChainLinkFont fontBlock = ^(UIFont *font) {
        NSParameterAssert(font);
        RZManuscript *newManuscript = self.copy;
        newManuscript.internalFont = font;
        return newManuscript;
    };

    return [fontBlock copy];
}

- (RZManuscriptChainLinkAdobeTracking)adobeTracking
{
    RZManuscriptChainLinkAdobeTracking adobeTrackingBlock = ^(NSInteger adobeTracking) {
        RZManuscript *newManuscript = self.copy;
        newManuscript.internalAdobeTracking = adobeTracking;
        newManuscript.internalPointTracking = 0.0f;
        return newManuscript;
    };

    return [adobeTrackingBlock copy];
}

- (RZManuscriptChainLinkPointTracking)pointTracking
{
    RZManuscriptChainLinkPointTracking pointTrackingBlock = ^(CGFloat pointTracking) {
        RZManuscript *newManuscript = self.copy;
        newManuscript.internalPointTracking = pointTracking;
        newManuscript.internalAdobeTracking = 0;
        return newManuscript;
    };

    return [pointTrackingBlock copy];
}

- (RZManuscriptChainLinkLineHeight)lineHeightMultiple
{
    RZManuscriptChainLinkLineHeight lineHeightMultipleBlock = ^(CGFloat lineHeightMultiple) {
        RZManuscript *newManuscript = self.copy;
        newManuscript.internalLineHeightMultiple = lineHeightMultiple;
        return newManuscript;
    };

    return [lineHeightMultipleBlock copy];
}

- (RZManuscriptChainLinkFigureCase)figureCase
{
    RZManuscriptChainLinkFigureCase figureCaseBlock = ^(RZFigureCase figureCase) {
        RZManuscript *newManuscript = self.copy;
        newManuscript.internalFigureCase = figureCase;
        return newManuscript;
    };

    return [figureCaseBlock copy];
}

- (RZManuscriptChainLinkFigureSpacing)figureSpacing
{
    RZManuscriptChainLinkFigureSpacing figureSpacingBlock = ^(RZFigureSpacing figureSpacing) {
        RZManuscript *newManuscript = self.copy;
        newManuscript.internalFigureSpacing = figureSpacing;
        return newManuscript;
    };

    return [figureSpacingBlock copy];
}

- (RZManuscriptChainLinkString)string
{
    RZManuscriptChainLinkString stringBlock = ^(NSString *string) {
        RZManuscript *newManuscript = self.copy;
        newManuscript.internalString = string;
        newManuscript.internalImage = nil;
        return newManuscript;
    };

    return [stringBlock copy];
}

#pragma mark - Private

/**
 *  Converts Adobe Illustrator/Photoshop Tracking values to a value that’s compatible with @c NSKernAttributeName. Adobe software measures tracking in thousandths of an em, where an em is the width of a capital letter M. @c NSAttributedString treats the point size of the font as 1 em.
 *
 *  @param adobeTrackingValue The tracking value as it is shown in Adobe design apps. Measured in thousandths of an em.
 *  @param font               The font whose point size to use in the calculation.
 *
 *  @return The converted tracking value.
 */
+ (CGFloat)trackingValueFromAdobeTrackingValue:(NSUInteger)adobeTrackingValue forFont:(UIFont *)font
{
    CGFloat pointSizeToUse = font ? font.pointSize : kRZDefaultFontSize;
    CGFloat convertedTracking = pointSizeToUse * (adobeTrackingValue / kRZAdobeTrackingDivisor);
    return convertedTracking;
}

@end
