//
//  NSAttributedString+BonMotUtilities.m
//  BonMot
//
//  Created by Eliot Williams on 3/9/16.
//
//

#import "NSAttributedString+BonMotUtilities.h"
#import "BONChain.h"
#import "BONSpecial.h"

static NSString *const kUnassignedCharacterNamePrefix = @"\\N{<unassigned-";
static NSString *const kUnassignedCharacterNameSuffix = @">}";

static const int kBONMaxRoundingDigits = 3;
static inline double BONEpsilon(void)
{
    return pow(10.0, -kBONMaxRoundingDigits) / 2.0; // half the smallest number representable with this many digits
}

NSString *BONDoubleRoundedString(double theDouble)
{
    BOOL integral = NO;
    if (fabs(theDouble - floor(theDouble)) < BONEpsilon()) {
        integral = YES;
    }

    BOOL multipleOfOneHalf = fabs(fmod(theDouble, 0.5)) < BONEpsilon();

    int numberOfDigits;
    if (integral) {
        numberOfDigits = 0;
    }
    else if (multipleOfOneHalf) {
        numberOfDigits = 1;
    }
    else {
        numberOfDigits = kBONMaxRoundingDigits;
    }

    NSString *string = [NSString stringWithFormat:@"%.*lf", numberOfDigits, theDouble];
    return string;
}

NSString *BONPrettyStringFromCGSize(CGSize size)
{
    NSString *string = [NSString stringWithFormat:@"%@x%@", BONDoubleRoundedString(size.width), BONDoubleRoundedString(size.height)];
    return string;
}

@implementation NSAttributedString (BonMotUtilities)

- (NSString *)bon_humanReadableString
{
    return [self bon_humanReadableStringIncludingImageSize:YES];
}

- (NSString *)bon_humanReadableStringIncludingImageSize:(BOOL)includeImageSize
{
    NSString *originalString = self.string;
    NSMutableString *composedHumanReadableString = [NSMutableString string];

    [originalString enumerateSubstringsInRange:NSMakeRange(0, originalString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *BONCNullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *BONCNonnull stop) {

        unichar character = [substring characterAtIndex:0];
        NSString *specialCharacterSubstitutionString = [BONSpecial humanReadableStringDictionary][@(character)];

        NSMutableString *mutableUnicodeName = substring.mutableCopy;
        CFStringTransform((CFMutableStringRef)mutableUnicodeName, NULL, kCFStringTransformToUnicodeName, FALSE);

        BONStringDict *attributes = [self attributesAtIndex:substringRange.location effectiveRange:NULL];
        NSTextAttachment *attachment = attributes[NSAttachmentAttributeName];
        UIImage *attachedImage = attachment.image;

        // Substitute attached images with @"{image<height>x<width>}"
        if (attachedImage) {
            NSString *sizeString = includeImageSize ? BONPrettyStringFromCGSize(attachedImage.size) : @"";
            NSString *imageSubstitutionString = [NSString stringWithFormat:@"{image%@}", sizeString];
            [composedHumanReadableString appendString:imageSubstitutionString];
        }
        // Swap applicable BONSpecial characters with @"{<camelCaseName>}"
        else if (specialCharacterSubstitutionString) {
            [composedHumanReadableString appendString:specialCharacterSubstitutionString];
        }
        // Substitute 򡌸 or similar with {unassignedUnicode<unicodeNumber>}
        else if ([mutableUnicodeName hasPrefix:kUnassignedCharacterNamePrefix] && [mutableUnicodeName hasSuffix:kUnassignedCharacterNameSuffix]) {
            NSString *unicodeNumber = [mutableUnicodeName substringWithRange:NSMakeRange(kUnassignedCharacterNamePrefix.length, mutableUnicodeName.length - kUnassignedCharacterNamePrefix.length - kUnassignedCharacterNameSuffix.length)];

            NSString *unassignedCharacterString = [NSString stringWithFormat:@"{unassignedUnicode%@}", unicodeNumber];
            [composedHumanReadableString appendString:unassignedCharacterString];
        }
        else {
            [composedHumanReadableString appendString:substring];
        }
    }];

    return composedHumanReadableString;
}

@end
