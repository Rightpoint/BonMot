//
//  BONText.m
//  Pods
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

#import "BONText.h"
#import "BONText_Private.h"

@import CoreText.SFNTLayoutTypes;

static const CGFloat kBONAdobeTrackingDivisor = 1000.0f;
static const CGFloat kBONDefaultFontSize = 15.0f; // per docs
static const unichar kBONSpaceCharacter = 32;

static NSString* const kBONAttachmentCharacterString = @"\uFFFC";

static inline BOOL BONCGFloatsCloseEnough(CGFloat float1, CGFloat float2)
{
    const CGFloat epsilon = 0.00001; // ought to be good enough
    return fabs(float1 - float2) < epsilon;
}

@interface BONText ()

@property (copy, nonatomic, readwrite) NSString *fontName;
@property (assign, nonatomic, readwrite) CGFloat fontSize;

@end

@implementation BONText

- (NSAttributedString *)attributedString
{
    NSArray *attributedStrings = self.attributedStrings;
    NSAttributedString *attributedString = [self.class joinAttributedStrings:attributedStrings withSeparator:nil];
    return attributedString;
}

- (NSArray *)attributedStrings
{
    NSMutableArray *attributedStrings = [NSMutableArray array];
    BONText *nextText = self;
    while ( nextText ) {
        BONText *nextnextText = nextText.nextText;
        BOOL lastConcatenant = ( nextnextText == nil );
        NSAttributedString *attributedString = [nextText attributedStringLastConcatenant:lastConcatenant];
        if ( attributedString ) {
            [attributedStrings addObject:attributedString];
        }

        nextText = nextnextText;
    }

    return attributedStrings;
}

- (NSAttributedString *)attributedStringLastConcatenant:(BOOL)lastConcatenant
{
    NSMutableAttributedString *mutableAttributedString = nil;

    if ( self.image ) {
        NSAssert(!self.string, @"If self.image is non-nil, self.string must be nil");
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = self.image;

        // Use the native size of the image instead of allowing it to be scaled
        attachment.bounds = CGRectMake(0.0f,
                                       self.baselineOffset, // images don’t respect attributed string’s baseline offset
                                       self.image.size.width,
                                       self.image.size.height);

        mutableAttributedString = [NSAttributedString attributedStringWithAttachment:attachment].mutableCopy;

        if (!lastConcatenant) {
            if ( self.trailingString) {
                [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.trailingString attributes:self.attributes]];
            }
            else if ( self.internalIndentSpacer ) {
                [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t" attributes:self.attributes]];
            }
        }

    }
    else if ( self.string ) {
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self.string
                                                                         attributes:self.attributes];
        if ( lastConcatenant ) {
            NSRange lastCharacterRange = NSMakeRange(self.string.length - 1, 1);
            [mutableAttributedString removeAttribute:NSKernAttributeName range:lastCharacterRange];
        }
        else {
            // tracking all the way through
            NSMutableString *stringToAppend = [NSMutableString string];

            // we aren't the last component, so append our trailing string using the same attributes as self
            if ( self.trailingString ) {
                [stringToAppend appendString:self.trailingString];
            }
            else if ( self.internalIndentSpacer ) {
                [stringToAppend appendString:@"\t"];
            }

            [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:stringToAppend attributes:self.attributes]];
        }
    }

    if (!lastConcatenant && self.internalIndentSpacer) {
        CGFloat indentation = self.internalIndentSpacer.doubleValue;
        if (self.image) {
            indentation += self.image.size.width;
        }
        else if ( self.string ) {
            NSAttributedString *measurementString = [[NSAttributedString alloc] initWithString:self.string attributes:self.attributes];
            CGRect boundingRect = [measurementString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                                  context:nil];
            CGFloat width = ceil(CGRectGetWidth(boundingRect));
            indentation += width;
        }

        NSRangePointer longestEffectiveRange = NULL;
        NSRange fullRange = NSMakeRange(0, mutableAttributedString.length);
        NSMutableParagraphStyle *paragraphStyle = [[mutableAttributedString attribute:NSParagraphStyleAttributeName
                                                                             atIndex:0
                                                               longestEffectiveRange:longestEffectiveRange
                                                                             inRange:fullRange] mutableCopy];

        if (!paragraphStyle) {
            paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        }

        if (!longestEffectiveRange) {
            longestEffectiveRange = &fullRange;
        }

        NSTextTab *tab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentNatural location:indentation options:@{}];
        paragraphStyle.tabStops = @[ tab ];
        paragraphStyle.headIndent = indentation;

        [mutableAttributedString addAttribute:NSParagraphStyleAttributeName
                                        value:paragraphStyle
                                        range:*longestEffectiveRange];
    }

    return mutableAttributedString;
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

    if ( self.figureCase != BONFigureCaseDefault ) {

        int figureCase = -1;
        switch ( self.figureCase ) {
            case BONFigureCaseLining:
                figureCase = kUpperCaseNumbersSelector;
                break;
            case BONFigureCaseOldstyle:
                figureCase = kLowerCaseNumbersSelector;
                break;
            case BONFigureCaseDefault:
                [NSException raise:NSInternalInconsistencyException format:@"Logic error: we should not have BONFigureCaseDefault here."];
                break;
        }

        NSDictionary *figureCaseDictionary = @{
                                               UIFontFeatureTypeIdentifierKey: @(kNumberCaseType),
                                               UIFontFeatureSelectorIdentifierKey: @(figureCase),
                                               };

        [featureSettings addObject:figureCaseDictionary];
    }

    // Figure Spacing

    if ( self.figureSpacing != BONFigureSpacingDefault ) {

        int figureSpacing = -1;
        switch ( self.figureSpacing ) {
            case BONFigureSpacingTabular:
                figureSpacing = kMonospacedNumbersSelector;
                break;
            case BONFigureSpacingProportional:
                figureSpacing = kProportionalNumbersSelector;
                break;
            default:
                [NSException raise:NSInternalInconsistencyException format:@"Logic error: we should not have BONFigureSpacingDefault here."];
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
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; \
        paragraphStyle.lineHeightMultiple = self.lineHeightMultiple;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }

    // Baseline Offset

    if ( self.baselineOffset != 0.0f && !self.image ) {
        attributes[NSBaselineOffsetAttributeName] = @(self.baselineOffset);
    }

    return attributes;
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) text = [[self.class alloc] init];

    text.font = self.font;
    text.textColor = self.textColor;
    text.backgroundColor = self.backgroundColor;
    text.adobeTracking = self.adobeTracking;
    text.pointTracking = self.pointTracking;
    text.lineHeightMultiple = self.lineHeightMultiple;
    text.baselineOffset = self.baselineOffset;
    text.figureCase = self.figureCase;
    text.figureSpacing = self.figureSpacing;
    text.string = self.string;
    text.image = self.image;
    text.nextText = self.nextText;
    text.internalIndentSpacer = self.internalIndentSpacer;

    return text;
}

#pragma mark - Properties

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

- (CGFloat)indentSpacer
{
    return self.internalIndentSpacer.doubleValue;
}

- (void)setIndentSpacer:(CGFloat)indentSpacer
{
    self.internalIndentSpacer = @(indentSpacer);
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

+ (NSAttributedString *)joinAttributedStrings:(NSArray *)attributedStrings withSeparator:(BONText *)separator
{
    NSParameterAssert(!separator || [separator isKindOfClass:[BONText class]]);
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

+ (NSAttributedString *)joinTexts:(NSArray *)texts withSeparator:(BONText *)separator
{
    NSParameterAssert(!separator || [separator isKindOfClass:[BONText class]]);
    NSParameterAssert(!texts || [texts isKindOfClass:[NSArray class]]);

    NSAttributedString *resultString;

    if ( texts.count == 0 ) {
        resultString = [[NSAttributedString alloc] init];
    }
    else if ( texts.count == 1 ) {
        NSAssert([texts.firstObject isKindOfClass:[BONText class]], @"The only item in the texts array is not an instance of %@. It is of type %@: %@", NSStringFromClass([BONText class]), [texts.firstObject class], texts.firstObject);

        resultString = [texts.firstObject attributedString];
    }
    else {
        NSMutableAttributedString *mutableResult = [[NSMutableAttributedString alloc] init];
        NSAttributedString *separatorAttributedString = separator.attributedString;
        // For each iteration, append the string and then the separator
        for ( NSUInteger textIndex = 0; textIndex < texts.count; textIndex++ ) {
            BONText *text = texts[textIndex];
            NSAssert([text isKindOfClass:[BONText class]], @"Item at index %@ is not an instance of %@. It is of type %@: %@", @(textIndex), NSStringFromClass([BONText class]), [text class], text);

            [mutableResult appendAttributedString:text.attributedString];

            // If the separator is not the empty string, append it,
            // unless this is the last component
            if ( separatorAttributedString.length > 0 && (textIndex != texts.count - 1) ) {
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
    CGFloat pointSizeToUse = font ? font.pointSize : kBONDefaultFontSize;
    CGFloat convertedTracking = pointSizeToUse * (adobeTrackingValue / kBONAdobeTrackingDivisor);
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

        if ( [substring isEqualToString:kBONAttachmentCharacterString] ) {
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
                        if ( character == kBONSpaceCharacter ) {
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
