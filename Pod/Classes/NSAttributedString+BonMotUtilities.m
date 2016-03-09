//
//  NSAttributedString+BonMotUtilities.m
//  Pods
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

        // Substitute Images with @"{image#heightx#width}"
        if ([substring isEqualToString:BONSpecial.objectReplacementCharacter]) {
            BONStringDict *attributes = [self attributesAtIndex:substringRange.location effectiveRange:NULL];
            NSTextAttachment *attachment = attributes[NSAttachmentAttributeName];
            UIImage *attachedImage = attachment.image;
            NSString *imageSubstitutionString = [NSString stringWithFormat:@"{image%.0fx%.0f}", attachedImage.size.height, attachedImage.size.width];
            [composedHumanReadableString appendString:imageSubstitutionString];
        }
        else {
            // Substitute BONSpecial Characters with @"{#name}"
            unichar character = [substring characterAtIndex:0];
            BONGeneric(NSDictionary, NSNumber *, NSString *)*specialNames = @{
                @(BONCharacterLineFeed) : @"{lineFeed}",
                @(BONCharacterTab) : @"{tab}",
                @(BONCharacterSpace) : @" ",
                @(BONCharacterNoBreakSpace) : @"{noBreakSpace}",
                @(BONCharacterEnSpace) : @"{enSpace}",
                @(BONCharacterEmSpace) : @"{emSpace}",
                @(BONCharacterFigureSpace) : @"{figureSpace}",
                @(BONCharacterThinSpace) : @"{thinSpace}",
                @(BONCharacterHairSpace) : @"{hairSpace}",
                @(BONCharacterZeroWidthSpace) : @"{zeroWidthSpace}",
                @(BONCharacterNonBreakingHyphen) : @"{nonBreakingHyphen}",
                @(BONCharacterFigureDash) : @"{figureDash}",
                @(BONCharacterEnDash) : @"{enDash}",
                @(BONCharacterEmDash) : @"{emDash}",
                @(BONCharacterHorizontalEllipsis) : @"{horizontalEllipsis}",
                @(BONCharacterLineSeparator) : @"{lineSeparator}",
                @(BONCharacterParagraphSeparator) : @"{paragraphSeparator}",
                @(BONCharacterNarrowNoBreakSpace) : @"{narrowNoBreakSpace}",
                @(BONCharacterWordJoiner) : @"{wordJoiner}",
                @(BONCharacterMinusSign) : @"{minusSign}"
            };

            NSString *specialCharacterReplacementName = specialNames[@(character)];

            if (specialCharacterReplacementName) {
                [composedHumanReadableString appendFormat:@"%@", specialCharacterReplacementName];
            }
            else if ([substring rangeOfCharacterFromSet:s_whiteSpaceAndNewLinesSet].location == NSNotFound) {
                // If not a newline or whitespace character, append it
                [composedHumanReadableString appendString:substring];
            }
            else if ([substring rangeOfCharacterFromSet:s_newLineCharacterSet].location != NSNotFound) {
                // If it's a newline character, append a @"{newline}".
                [composedHumanReadableString appendString:@"{newline}"];
            }
        }
    }];

    if (composedHumanReadableString.length == 0) {
        [composedHumanReadableString appendString:@""];
    }

    return composedHumanReadableString;
}

@end
