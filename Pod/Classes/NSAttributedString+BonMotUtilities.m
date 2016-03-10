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

@implementation NSAttributedString (BonMotUtilities)

- (NSString *)humanReadableString
{
    NSString *originalString = self.string;
    NSMutableString *composedHumanReadableString = [NSMutableString string];

    [originalString enumerateSubstringsInRange:NSMakeRange(0, originalString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *BONCNullable substring, NSRange substringRange, NSRange enclosingRange, BOOL *BONCNonnull stop) {

        static NSCharacterSet *s_newLineCharacterSet = nil;
        if (!s_newLineCharacterSet) {
            s_newLineCharacterSet = [NSCharacterSet newlineCharacterSet];
        }
        NSCharacterSet *s_whiteSpaceAndNewLinesSet = nil;
        if (!s_whiteSpaceAndNewLinesSet) {
            s_whiteSpaceAndNewLinesSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        }

        BONGeneric(NSDictionary, NSNumber *, NSString *)*specialCharacterSubstitutionNameDictionary = [BONSpecial humanReadableStringDictionary];
        unichar character = [substring characterAtIndex:0];
        NSString *specialCharacterSubstitutionString = specialCharacterSubstitutionNameDictionary[@(character)];

        // Substitute BONSpecial Characters with @"{#name}"
        if (specialCharacterSubstitutionString) {
            [composedHumanReadableString appendFormat:@"%@", specialCharacterSubstitutionString];
        }

        // Substitute Images with @"{image#heightx#width}"
        else if ([substring isEqualToString:BONSpecial.objectReplacementCharacter]) {
            BONStringDict *attributes = [self attributesAtIndex:substringRange.location effectiveRange:NULL];
            NSTextAttachment *attachment = attributes[NSAttachmentAttributeName];
            UIImage *attachedImage = attachment.image;
            NSString *imageSubstitutionString = [NSString stringWithFormat:@"{image%.0fx%.0f}", attachedImage.size.height, attachedImage.size.width];
            [composedHumanReadableString appendString:imageSubstitutionString];
        }

        // Substitute Newline character with  @"{newline}"
        else if ([substring rangeOfCharacterFromSet:s_newLineCharacterSet].location != NSNotFound) {
            [composedHumanReadableString appendString:@"{newline}"];
        }
        else {
            [composedHumanReadableString appendString:substring];
        }
    }];

    return composedHumanReadableString;
}

@end
