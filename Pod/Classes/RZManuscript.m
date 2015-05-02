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

@property (copy, nonatomic, readwrite) NSString *fontName;
@property (assign, nonatomic, readwrite) CGFloat fontSize;

@end

@implementation RZManuscript

- (NSAttributedString *)attributedString
{
    NSAttributedString *attributedString = nil;
    if ( self.string ) {
        attributedString = [[NSAttributedString alloc] initWithString:self.string
                                                           attributes:self.attributes];
    }
    else if ( self.image ) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = self.image;

        // Use the native size of the image instead of allowing it to be scaled
        attachment.bounds = CGRectMake(0.0f,
                                       self.baselineOffset, // images don’t respect attributed string’s baseline offset
                                       self.image.size.width,
                                       self.image.size.height);

        attributedString = [NSAttributedString attributedStringWithAttachment:attachment];
    }
    else {
        attributedString = [[NSAttributedString alloc] init];
    }
    
    return attributedString;
}

- (NSDictionary *)attributes
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    // Color

    if ( self.textColor ) {
        attributes[NSForegroundColorAttributeName] = self.textColor;
    }

    if ( self.backgroundColor ) {
        attributes[NSBackgroundColorAttributeName] = self.backgroundColor;
    }

    // Figure Style

    NSMutableArray *featureSettings = [NSMutableArray array];

    // Figure Case

    if ( self.figureCase != RZFigureCaseDefault ) {

        int figureCase = -1;
        switch ( self.figureCase ) {
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

    if ( self.figureSpacing != RZFigureSpacingDefault ) {

        int figureSpacing = -1;
        switch ( self.figureSpacing ) {
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

        if ( self.font ) {
            // get font descriptor from font
            UIFontDescriptor *descriptor = self.font.fontDescriptor;
            UIFontDescriptor *descriptorToUse = [descriptor fontDescriptorByAddingAttributes:featureSettingsAttributes];
            fontToUse = [UIFont fontWithDescriptor:descriptorToUse size:self.font.pointSize];
        }
        else {
            [NSException raise:NSInternalInconsistencyException format:@"If font attributes such as figure case or spacing are specified, a font must also be specified."];
        }
    }
    else {
        fontToUse = self.font;
    }

    if ( fontToUse ) {
        attributes[NSFontAttributeName] = fontToUse;
    }

    // Tracking

    NSAssert(self.adobeTracking == 0 || self.pointTracking == 0.0f, @"You may set Adobe tracking or point tracking to nonzero values, but not both");

    CGFloat trackingInPoints = 0.0f;
    if ( self.adobeTracking > 0 ) {
        trackingInPoints = [self.class pointTrackingValueFromAdobeTrackingValue:self.adobeTracking forFont:fontToUse];
    }
    else if ( self.pointTracking > 0.0f ) {
        trackingInPoints = self.pointTracking;
    }

    if ( trackingInPoints > 0.0f ) {
        // TODO: look into tipoff from @infrasonick about leaving this off the last character
        attributes[NSKernAttributeName] = @(trackingInPoints);
    }
    
    // Line Height

    if ( self.lineHeightMultiple != 1.0f ) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = self.lineHeightMultiple;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }

    // Baseline Offset

    if ( self.baselineOffset != 0.0f ) {
        attributes[NSBaselineOffsetAttributeName] = @(self.baselineOffset);
    }

    return attributes;
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) manuscript = [[self.class alloc] init];

    manuscript.font = self.font;
    manuscript.textColor = self.textColor;
    manuscript.backgroundColor = self.backgroundColor;
    manuscript.adobeTracking = self.adobeTracking;
    manuscript.pointTracking = self.pointTracking;
    manuscript.lineHeightMultiple = self.lineHeightMultiple;
    manuscript.baselineOffset = self.baselineOffset;
    manuscript.figureCase = self.figureCase;
    manuscript.figureSpacing = self.figureSpacing;
    manuscript.string = self.string;
    manuscript.image = self.image;

    return manuscript;
}

- (void)setFontName:(NSString *)fontName size:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    NSAssert(font, @"No font returned from [UIFont fontWithName:%@ size:%@]", fontName, @(fontSize));
    self.font = font;
    self.fontName = fontName;
    self.fontSize = fontSize;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.fontName = font.fontName;
    self.fontSize = font.pointSize;
}

- (void)setString:(NSString *)string
{
    if ( (_string || string) && ![_string isEqualToString:string] ) {
        _string = string.copy;
        self.image = nil;
    }
}

- (void)setImage:(UIImage *)image
{
    if ( (_image || image) && ![_image isEqual:image] ) {
        _image = image;
        self.string = nil;
    }
}

#pragma mark - Utilities

+ (NSAttributedString *)joinManuscripts:(NSArray *)manuscripts withSeparator:(RZManuscript *)separator
{
    NSParameterAssert(!separator || [separator isKindOfClass:[RZManuscript class]]);
    NSParameterAssert(!manuscripts || [manuscripts isKindOfClass:[NSArray class]]);

    NSAttributedString *resultString;

    if ( manuscripts.count == 0 ) {
        // do nothing, and return an empty attributed string
    }
    if ( manuscripts.count == 1 ) {
        NSAssert([manuscripts.firstObject isKindOfClass:[RZManuscript class]], @"Only item in manuscripts array is not an instance of %@. It is of type %@: %@", NSStringFromClass([RZManuscript class]), [manuscripts.firstObject class], manuscripts.firstObject);

        resultString = [manuscripts.firstObject attributedString];
    }
    else {
        NSMutableAttributedString *mutableResult = [[NSMutableAttributedString alloc] init];
        NSAttributedString *separatorAttributedString = separator.attributedString;
        // For each iteration, append the string and then the separator
        for ( NSUInteger manuscriptIndex = 0; manuscriptIndex < manuscripts.count; manuscriptIndex++ ) {
            RZManuscript *manuscript = manuscripts[manuscriptIndex];
            NSAssert([manuscript isKindOfClass:[RZManuscript class]], @"Item at index %@ is not an instance of %@. It is of type %@: %@", @(manuscriptIndex), NSStringFromClass([RZManuscript class]), [manuscripts.firstObject class], manuscripts.firstObject);

            [mutableResult appendAttributedString:manuscript.attributedString];

            // If the separator is not the empty string, append it,
            // unless this is the last component
            if ( separatorAttributedString.length > 0 && (manuscriptIndex != manuscripts.count - 1) ) {
                [mutableResult appendAttributedString:separatorAttributedString];
            }
        }
        resultString = mutableResult;
    }
    
    return resultString;
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
+ (CGFloat)pointTrackingValueFromAdobeTrackingValue:(NSUInteger)adobeTrackingValue forFont:(UIFont *)font
{
    CGFloat pointSizeToUse = font ? font.pointSize : kRZDefaultFontSize;
    CGFloat convertedTracking = pointSizeToUse * (adobeTrackingValue / kRZAdobeTrackingDivisor);
    return convertedTracking;
}

@end
