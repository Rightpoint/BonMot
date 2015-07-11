//
//  BONTextConfiguration.m
//  Pods
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

#import "BONTextConfiguration.h"

@import CoreText.SFNTLayoutTypes;

static const CGFloat kRZAdobeTrackingDivisor = 1000.0f;
static const CGFloat kRZDefaultFontSize = 15.0f; // per docs
static const unichar kRZSpaceCharacter = 32;

static NSString* const kRZAttachmentCharacterString = @"\uFFFC";

static inline BOOL BONCGFloatsCloseEnough(CGFloat float1, CGFloat float2)
{
    const CGFloat epsilon = 0.00001; // ought to be good enough
    return fabs(float1 - float2) < epsilon;
}

@interface BONTextConfiguration ()

@property (copy, nonatomic, readwrite) NSString *fontName;
@property (assign, nonatomic, readwrite) CGFloat fontSize;

@end

@implementation BONTextConfiguration

- (NSAttributedString *)attributedString
{
    NSArray *attributedStrings = self.attributedStrings;
    NSAttributedString *attributedString = [self.class joinAttributedStrings:attributedStrings withSeparator:nil];
    return attributedString;
}

- (NSArray *)attributedStrings
{
    NSMutableArray *attributedStrings = [NSMutableArray array];
    BONTextConfiguration *nextTextConfiguration = self;
    while ( nextTextConfiguration ) {
        BONTextConfiguration *nextnextTextConfiguration = nextTextConfiguration.nextTextConfiguration;
        BOOL lastConcatenant = ( nextnextTextConfiguration == nil );
        NSAttributedString *attributedString = [nextTextConfiguration attributedStringLastConcatenant:lastConcatenant];
        if ( attributedString ) {
            [attributedStrings addObject:attributedString];
        }

        nextTextConfiguration = nextnextTextConfiguration;
    }

    return attributedStrings;
}

- (NSAttributedString *)attributedStringLastConcatenant:(BOOL)lastConcatenant
{
    NSAttributedString *attributedString = nil;

    if ( self.image ) {
        NSAssert(!self.string, @"If self.image is non-nil, self.string must be nil");
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = self.image;

        // Use the native size of the image instead of allowing it to be scaled
        attachment.bounds = CGRectMake(0.0f,
                                       self.baselineOffset, // images don’t respect attributed string’s baseline offset
                                       self.image.size.width,
                                       self.image.size.height);

        attributedString = [NSAttributedString attributedStringWithAttachment:attachment];

        if ( self.trailingString ) {
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
            [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.trailingString attributes:self.attributes]];
            attributedString = mutableAttributedString;
        }
    }
    else if ( self.string ) {
        if ( lastConcatenant ) {
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self.string
                                                                                                        attributes:self.attributes];
            NSRange lastCharacterRange = NSMakeRange(self.string.length - 1, 1);
            [mutableAttributedString removeAttribute:NSKernAttributeName range:lastCharacterRange];
            attributedString = mutableAttributedString.copy;
        }
        else {
            // tracking all the way through
            NSString *stringToUse = self.string;

            // we aren't the last component, so append our trailing string using the same attributes as self
            if ( self.trailingString ) {
                stringToUse = [stringToUse stringByAppendingString:self.trailingString];
            }

            attributedString = [[NSAttributedString alloc] initWithString:stringToUse
                                                               attributes:self.attributes];
        }
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
    if ( !BONCGFloatsCloseEnough(self.adobeTracking, 0.0f) ) {
        trackingInPoints = [self.class pointTrackingValueFromAdobeTrackingValue:self.adobeTracking forFont:fontToUse];
    }
    else if ( !BONCGFloatsCloseEnough(self.pointTracking, 0.0f) ) {
        trackingInPoints = self.pointTracking;
    }

    if ( !BONCGFloatsCloseEnough(trackingInPoints, 0.0f) ) {
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
    __typeof(self) textConfiguration = [[self.class alloc] init];

    textConfiguration.font = self.font;
    textConfiguration.textColor = self.textColor;
    textConfiguration.backgroundColor = self.backgroundColor;
    textConfiguration.adobeTracking = self.adobeTracking;
    textConfiguration.pointTracking = self.pointTracking;
    textConfiguration.lineHeightMultiple = self.lineHeightMultiple;
    textConfiguration.baselineOffset = self.baselineOffset;
    textConfiguration.figureCase = self.figureCase;
    textConfiguration.figureSpacing = self.figureSpacing;
    textConfiguration.string = self.string;
    textConfiguration.image = self.image;
    textConfiguration.nextTextConfiguration = self.nextTextConfiguration;

    return textConfiguration;
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

+ (NSAttributedString *)joinAttributedStrings:(NSArray *)attributedStrings withSeparator:(BONTextConfiguration *)separator
{
    NSParameterAssert(!separator || [separator isKindOfClass:[BONTextConfiguration class]]);
    NSParameterAssert(!attributedStrings || [attributedStrings isKindOfClass:[NSArray class]]);

    NSAttributedString *resultsString;

    if ( attributedStrings.count == 0 ) {
        resultsString = [[NSAttributedString alloc] init];
    }
    else if ( attributedStrings.count == 1) {
        NSAssert([attributedStrings.firstObject isKindOfClass:[NSAttributedString class]], @"The only item in the attributedStrings array is not an instance of %@. It is of type %@: %@", NSStringFromClass([NSAttributedString class]), [attributedStrings.firstObject class], attributedStrings.firstObject);

        resultsString = attributedStrings.firstObject;
    }
    else {
        NSMutableAttributedString *mutableResult = [[NSMutableAttributedString alloc] init];
        NSAttributedString *separatorAttributedString = separator.attributedString;
        // For each iteration, append the string and then the separator
        for ( NSUInteger attributedStringIndex = 0; attributedStringIndex < attributedStrings.count; attributedStringIndex++ ) {
            NSAttributedString *attributedString = attributedStrings[attributedStringIndex];
            NSAssert([attributedString isKindOfClass:[NSAttributedString class]], @"Item at index %@ is not an instance of %@. It is of type %@: %@", @(attributedStringIndex), NSStringFromClass([NSAttributedString class]), [attributedString class], attributedString);

            [mutableResult appendAttributedString:attributedString];

            // If the separator is not the empty string, append it,
            // unless this is the last component
            if ( separatorAttributedString.length > 0 && (attributedStringIndex != attributedStrings.count - 1) ) {
                [mutableResult appendAttributedString:separatorAttributedString];
            }
        }
        resultsString = mutableResult;
    }

    return resultsString;
}

+ (NSAttributedString *)joinTextConfigurations:(NSArray *)textConfigurations withSeparator:(BONTextConfiguration *)separator
{
    NSParameterAssert(!separator || [separator isKindOfClass:[BONTextConfiguration class]]);
    NSParameterAssert(!textConfigurations || [textConfigurations isKindOfClass:[NSArray class]]);

    NSAttributedString *resultString;

    if ( textConfigurations.count == 0 ) {
        resultString = [[NSAttributedString alloc] init];
    }
    else if ( textConfigurations.count == 1 ) {
        NSAssert([textConfigurations.firstObject isKindOfClass:[BONTextConfiguration class]], @"The only item in the textConfigurations array is not an instance of %@. It is of type %@: %@", NSStringFromClass([BONTextConfiguration class]), [textConfigurations.firstObject class], textConfigurations.firstObject);

        resultString = [textConfigurations.firstObject attributedString];
    }
    else {
        NSMutableAttributedString *mutableResult = [[NSMutableAttributedString alloc] init];
        NSAttributedString *separatorAttributedString = separator.attributedString;
        // For each iteration, append the string and then the separator
        for ( NSUInteger textConfigurationIndex = 0; textConfigurationIndex < textConfigurations.count; textConfigurationIndex++ ) {
            BONTextConfiguration *textConfiguration = textConfigurations[textConfigurationIndex];
            NSAssert([textConfiguration isKindOfClass:[BONTextConfiguration class]], @"Item at index %@ is not an instance of %@. It is of type %@: %@", @(textConfigurationIndex), NSStringFromClass([BONTextConfiguration class]), [textConfiguration class], textConfiguration);

            [mutableResult appendAttributedString:textConfiguration.attributedString];

            // If the separator is not the empty string, append it,
            // unless this is the last component
            if ( separatorAttributedString.length > 0 && (textConfigurationIndex != textConfigurations.count - 1) ) {
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
+ (CGFloat)pointTrackingValueFromAdobeTrackingValue:(NSInteger)adobeTrackingValue forFont:(UIFont *)font
{
    CGFloat pointSizeToUse = font ? font.pointSize : kRZDefaultFontSize;
    CGFloat convertedTracking = pointSizeToUse * (adobeTrackingValue / kRZAdobeTrackingDivisor);
    return convertedTracking;
}

- (NSString *)debugDescriptionIncludeImageAddresses:(BOOL)includeImageAddresses
{
    NSAttributedString *originalAttributedString = self.attributedString;

    NSString *originalString = originalAttributedString.string;

    NSMutableString *debugString = [NSMutableString string];

    [originalString enumerateSubstringsInRange:NSMakeRange(0, originalString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        // New Line
        [debugString appendString:@"\n"];

        if ( [substring isEqualToString:kRZAttachmentCharacterString] ) {
            NSDictionary *attributes = [originalAttributedString attributesAtIndex:substringRange.location effectiveRange:NULL];
            NSTextAttachment *attachment = attributes[NSAttachmentAttributeName];
            UIImage *attachedImage = attachment.image;
            if ( includeImageAddresses ) {
                [debugString appendFormat:@"%@", attachedImage];
            }
            else {
                [debugString appendFormat:@"[attached image of size: %@]", NSStringFromCGSize(attachedImage.size)];
            }
        }
        else {
            static NSCharacterSet *s_newLineCharacterSet = nil;
            if ( !s_newLineCharacterSet ) {
                s_newLineCharacterSet = [NSCharacterSet newlineCharacterSet];
            }

            // If it's not a newline character, append it. Otherwise, append a space.
            if ( [substring rangeOfCharacterFromSet:s_newLineCharacterSet].location == NSNotFound ) {
                [debugString appendString:substring];
            }
            else {
                [debugString appendString:@" "];
            }

            NSMutableString *unicodeName = substring.mutableCopy;

            Boolean success = CFStringTransform((CFMutableStringRef)unicodeName, NULL, kCFStringTransformToUnicodeName, FALSE);

            if ( success ) {
                // Append name only if it is different from the string itself
                if ( ![unicodeName isEqualToString:substring] ) {
                    [debugString appendFormat:@"[%@]", unicodeName];
                }
                else {
                    // If it is a whitespace or new line string, describe it better than just appending it
                    NSCharacterSet *s_whiteSpaceAndNewLinesSet = nil;
                    if ( !s_whiteSpaceAndNewLinesSet ) {
                        s_whiteSpaceAndNewLinesSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                    }

                    if ( [unicodeName rangeOfCharacterFromSet:s_whiteSpaceAndNewLinesSet].location != NSNotFound ) {
                        unichar character = [unicodeName characterAtIndex:0];
                        if ( character == kRZSpaceCharacter ) {
                            [debugString appendString:@"[Space]"];
                        }
                        else {
                            [debugString appendFormat:@"Whitespace character: %02d, 0x%02X", character, character];
                        }
                    }
                }

            }
            else {
                unichar character = [substring characterAtIndex:0];
                [debugString appendFormat:@"[Unknown character: %02d, 0x%02X]", character, character];
            }
        }
    }];
    
    if ( debugString.length == 0 ) {
        [debugString appendString:@"[empty string]"];
    }
    
    return debugString.copy;
}

- (NSString *)debugDescription
{
    return [self debugDescriptionIncludeImageAddresses:YES];
}

@end
