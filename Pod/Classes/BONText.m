//
//  BONText.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/17/15.
//
//

#import "BONText.h"
#import "BONText_Private.h"
#import "BONSpecial.h"
#import "BONTag_Private.h"

@import CoreText.SFNTLayoutTypes;

static const CGFloat kBONAdobeTrackingDivisor = 1000.0;
static const CGFloat kBONDefaultFontSize = 15.0; // per docs

static inline BOOL BONDoublesCloseEnough(CGFloat float1, CGFloat float2)
{
    const CGFloat epsilon = 0.00001; // ought to be good enough
    return fabs(float1 - float2) < epsilon;
}

@interface BONText ()

@property (copy, nonatomic, readwrite) NSString *fontName;
@property (nonatomic, readwrite) CGFloat fontSize;

@end

@implementation BONText

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alignment = NSTextAlignmentNatural;
        self.underlineStyle = NSUnderlineStyleNone;
        self.strikethroughStyle = NSUnderlineStyleNone;
        self.lineBreakMode = NSLineBreakByWordWrapping;
    }

    return self;
}

- (NSAttributedString *)attributedString
{
    BONGeneric(NSArray, NSAttributedString *)*attributedStrings = self.attributedStrings;
    NSAttributedString *attributedString = [self.class joinAttributedStrings:attributedStrings withSeparator:nil];
    return attributedString;
}

- (BONGeneric(NSArray, NSAttributedString *) *)attributedStrings
{
    BONGeneric(NSMutableArray, NSAttributedString *)*attributedStrings = [NSMutableArray array];
    BONText *nextText = self;
    while (nextText) {
        BONText *nextnextText = nextText.nextText;
        BOOL lastConcatenant = (nextnextText == nil);
        NSAttributedString *attributedString = [nextText attributedStringLastConcatenant:lastConcatenant];
        if (attributedString) {
            [attributedStrings addObject:attributedString];
        }

        nextText = nextnextText;
    }

    return attributedStrings;
}

- (NSAttributedString *)attributedStringLastConcatenant:(BOOL)lastConcatenant
{
    NSMutableAttributedString *mutableAttributedString = nil;

    NSString *string = self.string;

    if (self.image) {
        NSAssert(!self.string, @"If self.image is non-nil, self.string must be nil");
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = self.image;

        // Use the native size of the image instead of allowing it to be scaled
        attachment.bounds = CGRectMake(0.0,
                                       self.baselineOffset, // images don’t respect attributed string’s baseline offset
                                       self.image.size.width,
                                       self.image.size.height);

        mutableAttributedString = [NSAttributedString attributedStringWithAttachment:attachment].mutableCopy;

        if (self.internalIndentSpacer && !lastConcatenant) {
            [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t" attributes:self.attributes]];
        }
    }
    else if (string) {
        // If there is tag styling applied, strip the tags from the string and identify the ranges to apply the tag-based chains to.
        BONGeneric(NSArray, BONTag *)*rangesPerTag = nil;

        if (self.tagStyles) {
            rangesPerTag = [BONTag rangesInString:&string betweenTags:self.tagStyles];
        }

        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string
                                                                         attributes:self.attributes];

        for (BONTag *tag in rangesPerTag) {
            BONStringDict *attributes = tag.textable.text.attributes;
            for (NSValue *value in tag.ranges) {
                [mutableAttributedString setAttributes:attributes range:value.rangeValue];
            }
        }

        if (lastConcatenant && string.length > 0) {
            NSRange lastCharacterRange = NSMakeRange(string.length - 1, 1);
            [mutableAttributedString removeAttribute:NSKernAttributeName range:lastCharacterRange];
        }
        else {
            // tracking all the way through
            NSMutableString *stringToAppend = [NSMutableString string];

            // we aren't the last component, so append a tab character if we have indent spacing
            if (self.internalIndentSpacer) {
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
        else if (string) {
            NSAttributedString *measurementString = [[NSAttributedString alloc] initWithString:string attributes:self.attributes];
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

- (BONStringDict *)attributes
{
    BONStringMutableDict *attributes = [NSMutableDictionary dictionary];

    __block NSMutableParagraphStyle *paragraphStyle = nil;

    void (^populateParagraphStyleIfNecessary)() = ^{
        if (!paragraphStyle) {
            paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        }
    };

    // Color

    if (self.color) {
        attributes[NSForegroundColorAttributeName] = self.color;
    }

    if (self.backgroundColor) {
        attributes[NSBackgroundColorAttributeName] = self.backgroundColor;
    }

    // Figure Style

    BONGeneric(NSMutableArray, BONStringDict *)*featureSettings = [NSMutableArray array];

    // Figure Case

    if (self.figureCase != BONFigureCaseDefault) {
        int figureCase = -1;
        switch (self.figureCase) {
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

        BONStringDict *figureCaseDictionary = @{
            UIFontFeatureTypeIdentifierKey : @(kNumberCaseType),
            UIFontFeatureSelectorIdentifierKey : @(figureCase),
        };

        [featureSettings addObject:figureCaseDictionary];
    }

    // Figure Spacing

    if (self.figureSpacing != BONFigureSpacingDefault) {
        int figureSpacing = -1;
        switch (self.figureSpacing) {
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

        BONStringDict *figureSpacingDictionary = @{
            UIFontFeatureTypeIdentifierKey : @(kNumberSpacingType),
            UIFontFeatureSelectorIdentifierKey : @(figureSpacing),
        };
        [featureSettings addObject:figureSpacingDictionary];
    }

    BOOL needToUseFontDescriptor = featureSettings.count > 0;

    UIFont *fontToUse = nil;

    if (needToUseFontDescriptor) {
        BONGeneric(NSMutableDictionary, NSString *, BONGeneric(NSArray, BONStringDict *)*)*featureSettingsAttributes = [NSMutableDictionary dictionary];
        featureSettingsAttributes[UIFontDescriptorFeatureSettingsAttribute] = featureSettings;

        if (self.font) {
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

    if (fontToUse) {
        attributes[NSFontAttributeName] = fontToUse;
    }

    // Tracking
    NSAssert(self.adobeTracking == 0 || BONDoublesCloseEnough(self.pointTracking, 0.0), @"You may set Adobe tracking or point tracking to nonzero values, but not both");

    CGFloat trackingInPoints = 0.0;
    if (self.adobeTracking != 0) {
        trackingInPoints = [self.class pointTrackingValueFromAdobeTrackingValue:self.adobeTracking forFont:fontToUse];
    }
    else if (!BONDoublesCloseEnough(self.pointTracking, 0.0)) {
        trackingInPoints = self.pointTracking;
    }

    if (!BONDoublesCloseEnough(trackingInPoints, 0.0)) {
        attributes[NSKernAttributeName] = @(trackingInPoints);
    }

    // First Line Head Indent

    if (self.firstLineHeadIndent != 0.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.firstLineHeadIndent = self.firstLineHeadIndent;
    }

    // Head Indent

    if (self.headIndent != 0.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.headIndent = self.headIndent;
    }

    // Head Indent

    if (self.tailIndent != 0.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.tailIndent = self.tailIndent;
    }

    // Line Height

    if (self.lineHeightMultiple != 1.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.lineHeightMultiple = self.lineHeightMultiple;
    }

    // Maximum Line Height

    if (self.maximumLineHeight != 1.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.maximumLineHeight = self.maximumLineHeight;
    }

    // Minimum Line Height

    if (self.minimumLineHeight != 1.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.minimumLineHeight = self.minimumLineHeight;
    }

    // Line Spacing

    if (self.lineSpacing != 0.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.lineSpacing = self.lineSpacing;
    }

    // Line Break Mode

    if (self.lineBreakMode != NSLineBreakByWordWrapping) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.lineBreakMode = self.lineBreakMode;
    }

    // Paragraph Spacing

    if (self.paragraphSpacingAfter != 0.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.paragraphSpacing = self.paragraphSpacingAfter;
    }

    // Paragraph Spacing Before

    if (self.paragraphSpacingBefore != 0.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.paragraphSpacingBefore = self.paragraphSpacingBefore;
    }

    // Baseline Offset

    if (self.baselineOffset != 0.0 && !self.image) {
        attributes[NSBaselineOffsetAttributeName] = @(self.baselineOffset);
    }

    // Hyphenation Factor

    if (self.hyphenationFactor != 0.0) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.hyphenationFactor = self.hyphenationFactor;
    }

    // Text Alignment

    if (self.alignment != NSTextAlignmentNatural) {
        populateParagraphStyleIfNecessary();
        paragraphStyle.alignment = self.alignment;
    }

    if (paragraphStyle) {
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }

    // Underlining

    if (self.underlineStyle != NSUnderlineStyleNone) {
        attributes[NSUnderlineStyleAttributeName] = @(self.underlineStyle);
    }

    if (self.underlineColor) {
        attributes[NSUnderlineColorAttributeName] = self.underlineColor;
    }

    // Strikethrough

    if (self.strikethroughStyle != NSUnderlineStyleNone) {
        attributes[NSStrikethroughStyleAttributeName] = @(self.strikethroughStyle);
    }

    if (self.strikethroughColor) {
        attributes[NSStrikethroughColorAttributeName] = self.strikethroughColor;
    }
    
    // URL
    
    if (self.url) {
        attributes[NSLinkAttributeName] = self.url;
    }
    
    return attributes;
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) text = [[self.class alloc] init];

    text.font = self.font;
    text.color = self.color;
    text.backgroundColor = self.backgroundColor;
    text.adobeTracking = self.adobeTracking;
    text.pointTracking = self.pointTracking;
    text.firstLineHeadIndent = self.firstLineHeadIndent;
    text.headIndent = self.headIndent;
    text.tailIndent = self.tailIndent;
    text.lineHeightMultiple = self.lineHeightMultiple;
    text.maximumLineHeight = self.maximumLineHeight;
    text.minimumLineHeight = self.minimumLineHeight;
    text.lineSpacing = self.lineSpacing;
    text.lineBreakMode = self.lineBreakMode;
    text.paragraphSpacingAfter = self.paragraphSpacingAfter;
    text.paragraphSpacingBefore = self.paragraphSpacingBefore;
    text.baselineOffset = self.baselineOffset;
    text.hyphenationFactor = self.hyphenationFactor;
    text.alignment = self.alignment;
    text.figureCase = self.figureCase;
    text.figureSpacing = self.figureSpacing;
    text.string = self.string;
    text.image = self.image;
    text.nextText = self.nextText;
    text.url = self.url;

    text.internalIndentSpacer = self.internalIndentSpacer;

    text.underlineStyle = self.underlineStyle;
    text.underlineColor = self.underlineColor;

    text.strikethroughStyle = self.strikethroughStyle;
    text.strikethroughColor = self.strikethroughColor;

    text.tagStyles = self.tagStyles;

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

- (void)setAdobeTracking:(NSInteger)adobeTracking
{
    if (_adobeTracking != adobeTracking) {
        _adobeTracking = adobeTracking;
        _pointTracking = 0.0;
    }
}

- (void)setPointTracking:(CGFloat)pointTracking
{
    if (_pointTracking != pointTracking) {
        _pointTracking = pointTracking;
        _adobeTracking = 0;
    }
}

- (void)setString:(NSString *)string
{
    if ((_string || string) && ![_string isEqualToString:string]) {
        _string = string.copy;
        _image = nil;
    }
}

- (void)setImage:(UIImage *)image
{
    if ((_image || image) && ![_image isEqual:image]) {
        _image = image;
        _string = nil;
    }
}

- (BOOL)generatesEmptyString
{
    return (self.string.length == 0 && !self.image && (!self.nextText || self.nextText.generatesEmptyString));
}

#pragma mark - BONTextable

- (BONText *)text
{
    return self;
}

#pragma mark - Utilities

+ (NSAttributedString *)joinAttributedStrings:(BONGeneric(NSArray, NSAttributedString *) *)attributedStrings withSeparator:(NSAttributedString *)separator
{
    NSParameterAssert(!attributedStrings || [attributedStrings isKindOfClass:[NSArray class]]);
    NSParameterAssert(!separator || [separator isKindOfClass:[NSAttributedString class]]);

    NSAttributedString *resultsString;

    if (attributedStrings.count == 0) {
        resultsString = [[NSAttributedString alloc] init];
    }
    else if (attributedStrings.count == 1) {
        NSAssert([attributedStrings.firstObject isKindOfClass:[NSAttributedString class]], @"The only item in the attributedStrings array is not an instance of %@. It is of type %@: %@", NSStringFromClass([NSAttributedString class]), [attributedStrings.firstObject class], attributedStrings.firstObject);

        resultsString = attributedStrings.firstObject;
    }
    else {
        NSMutableAttributedString *mutableResult = [[NSMutableAttributedString alloc] init];
        // For each iteration, append the string and then the separator
        for (NSUInteger attributedStringIndex = 0; attributedStringIndex < attributedStrings.count; attributedStringIndex++) {
            NSAttributedString *attributedString = attributedStrings[attributedStringIndex];
            NSAssert([attributedString isKindOfClass:[NSAttributedString class]], @"Item at index %@ is not an instance of %@. It is of type %@: %@", @(attributedStringIndex), NSStringFromClass([NSAttributedString class]), [attributedString class], attributedString);

            [mutableResult appendAttributedString:attributedString];

            // If the separator is not the empty string, append it,
            // unless this is the last component
            if (separator.length > 0 && (attributedStringIndex != attributedStrings.count - 1)) {
                [mutableResult appendAttributedString:separator];
            }
        }
        resultsString = mutableResult;
    }

    return resultsString;
}

+ (NSAttributedString *)joinTextables:(BONGeneric(NSArray, id<BONTextable>) *)textables withSeparator:(id<BONTextable>)separator
{
    BONGeneric(NSMutableArray, NSAttributedString *)*attributedStrings = [NSMutableArray array];

    for (id<BONTextable> textable in textables) {
        [attributedStrings addObject:textable.text.attributedString];
    }

    NSAttributedString *separatorAttributedString = separator.text.attributedString;

    return [self joinAttributedStrings:attributedStrings withSeparator:separatorAttributedString];
}

- (NSString *)debugString
{
    return [self debugStringIncludeImageAddresses:YES];
}

- (NSString *)debugStringIncludeImageAddresses:(BOOL)includeImageAddresses
{
    NSAttributedString *originalAttributedString = self.attributedString;

    NSString *originalString = originalAttributedString.string;

    NSMutableString *debugString = [NSMutableString string];

    [originalString enumerateSubstringsInRange:NSMakeRange(0, originalString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *BONCNullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *BONCNonnull stop) {
        if (substringRange.location != 0) {
            [debugString appendString:@"\n"];
        }

        if ([substring isEqualToString:BONSpecial.objectReplacementCharacter]) {
            BONStringDict *attributes = [originalAttributedString attributesAtIndex:substringRange.location effectiveRange:NULL];
            NSTextAttachment *attachment = attributes[NSAttachmentAttributeName];
            UIImage *attachedImage = attachment.image;
            if (includeImageAddresses) {
                [debugString appendFormat:@"(%@)", attachedImage];
            }
            else {
                [debugString appendFormat:@"(attached image of size: %@)", NSStringFromCGSize(attachedImage.size)];
            }
        }
        else {
            static NSCharacterSet *s_newLineCharacterSet = nil;
            if (!s_newLineCharacterSet) {
                s_newLineCharacterSet = [NSCharacterSet newlineCharacterSet];
            }

            // If it's not a newline character, append it. Otherwise, append a space.
            if ([substring rangeOfCharacterFromSet:s_newLineCharacterSet].location == NSNotFound) {
                [debugString appendString:substring];
            }
            else {
                [debugString appendString:BONSpecial.space];
            }

            // Find, derive, or invent the name/description, and append it

            unichar character = [substring characterAtIndex:0];
            BONGeneric(NSDictionary, NSNumber *, NSString *)*specialNames = @{
                @(BONCharacterSpace) : @"Space",
                @(BONCharacterLineFeed) : @"Line Feed",
                @(BONCharacterTab) : @"Tab",
            };

            NSString *name = specialNames[@(character)];

            if (name) {
                [debugString appendFormat:@"(%@)", name];
            }
            else {
                NSMutableString *mutableUnicodeName = substring.mutableCopy;

                // We can ignore the return value of this function,
                // because while in principle it can fail, in practice
                // it never fails with kCFStringTransformToUnicodeName
                CFStringTransform((CFMutableStringRef)mutableUnicodeName, NULL, kCFStringTransformToUnicodeName, FALSE);

                name = mutableUnicodeName;

                NSCharacterSet *s_whiteSpaceAndNewLinesSet = nil;
                if (!s_whiteSpaceAndNewLinesSet) {
                    s_whiteSpaceAndNewLinesSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                }

                BOOL isWhitespace = [substring rangeOfCharacterFromSet:s_whiteSpaceAndNewLinesSet].location != NSNotFound;

                if (isWhitespace) {
                    if (name) {
                        [debugString appendFormat:@"(%@)", name];
                    }
                    else {
                        [debugString appendFormat:@"(Whitespace character: %02d, 0x%02X)", character, character];
                    }
                }
                else {
                    // Append name only if it is different from the string itself
                    if (![mutableUnicodeName isEqualToString:substring]) {
                        [debugString appendFormat:@"(%@)", mutableUnicodeName];
                    }
                }
            }
        }
    }];

    if (debugString.length == 0) {
        [debugString appendString:@"(empty string)"];
    }

    return debugString;
}

- (NSString *)description
{
    NSString *debugString = [self debugStringIncludeImageAddresses:YES];
    NSString *realString = self.attributedString.string;
    __block NSUInteger composedCharacterCount = 0;

    [realString enumerateSubstringsInRange:NSMakeRange(0, realString.length)
                                   options:NSStringEnumerationByComposedCharacterSequences
                                usingBlock:^(NSString *BONCNullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *BONCNonnull stop) {
                                    composedCharacterCount++;
                                }];

    NSString *characterSuffix = (composedCharacterCount == 1) ? @"" : @"s"; // pluralization
    NSString *description = [NSString stringWithFormat:@"<%@: %p, %@ composed character%@:\n%@\n// end of %@: %p description>", NSStringFromClass(self.class), self, @(composedCharacterCount), characterSuffix, debugString, NSStringFromClass(self.class), self];
    return description;
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

@end

@implementation BONText (Deprecated)

- (UIColor *)textColor
{
    return self.color;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.color = textColor;
}

+ (NSAttributedString *)joinTexts:(BONGeneric(NSArray, BONText *) *)texts withSeparator:(BONText *)separator
{
    return [self joinTextables:texts withSeparator:separator];
}

@end
