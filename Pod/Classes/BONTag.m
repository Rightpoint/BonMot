//
//  BONTag.m
//  BonMot
//
//  Created by Nora Trapp on 5/11/16.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONTag_Private.h"
#import "BONMot.h"

static NSString *const kBONTagDefaultStartPrefix = @"<";
static NSString *const kBONTagDefaultStartSuffix = @">";
static NSString *const kBONTagDefaultEndPrefix = @"</";
static NSString *const kBONTagDefaultEndSuffix = @">";
static NSString *const kBONTagDefaultEscapeString = @"\\";

@interface BONTag ()

@property (copy, nonatomic) NSString *startTag;
@property (copy, nonatomic) NSString *endTag;
@property (copy, nonatomic) NSString *escapeString;
@property (copy, nonatomic) id<BONTextable> textable;

@end

@implementation BONTag

- (instancetype)initWithStartTag:(NSString *)startTag endTag:(NSString *)endTag escapeString:(NSString *)escapeString textable:(id<BONTextable>)textable
{
    self = [super init];
    if (self) {
        self.startTag = startTag;
        self.endTag = endTag;
        self.escapeString = escapeString;
        self.textable = textable;
        self.ranges = [NSMutableArray array];
    }

    return self;
}

- (instancetype)initWithTag:(NSString *)tag textable:(id<BONTextable>)textable
{
    NSString *startTag = [NSString stringWithFormat:@"%@%@%@", kBONTagDefaultStartPrefix, tag, kBONTagDefaultStartSuffix];
    NSString *endTag = [NSString stringWithFormat:@"%@%@%@", kBONTagDefaultEndPrefix, tag, kBONTagDefaultEndSuffix];

    return [self initWithStartTag:startTag endTag:endTag escapeString:(NSString *)kBONTagDefaultEscapeString textable:textable];
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) tag = [[self.class alloc] init];

    tag.startTag = self.startTag;
    tag.endTag = self.endTag;
    tag.escapeString = self.escapeString;
    tag.textable = self.textable;
    tag.ranges = self.ranges.mutableCopy;

    return tag;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<%@: %p, startTag: %@, endTag: %@, textable: <%@: %p>>", NSStringFromClass(self.class), self, self.startTag, self.endTag, NSStringFromClass(self.textable.class), self.textable];

    return description;
}

#pragma mark - Tag Matching

+ (BONGeneric(NSArray, NSValue *) *)escapedRangesInString:(NSString **)string withTags:(BONGeneric(NSArray, BONTag *) *)tags
{
    NSParameterAssert(string);
    NSParameterAssert(tags);

    NSMutableArray *escapedRanges = [NSMutableArray array];

    NSString *theString = *string;

    NSRange searchRange = NSMakeRange(0, theString.length);

    // Iterate over the string, finding each escape in order, until there are no more escape strings
    while (YES) {
        BONTag *nextTag;
        NSRange nextEscapeRange;
        NSRange nextEscapedTagRange;

        // Find the next escape string
        for (BONTag *tag in tags) {
            NSRange escapeRange = [theString rangeOfString:tag.escapeString options:0 range:searchRange];

            if (escapeRange.location != NSNotFound) {
                if (!nextTag || (escapeRange.location < nextEscapeRange.location)) {
                    // Check if this character is escaping a start or end tag
                    for (NSString *tagString in @[ tag.startTag, tag.endTag ]) {
                        // Check if there is room for this tag to exist after the escape character
                        if ((NSInteger)(NSMaxRange(escapeRange) + tagString.length) < theString.length) {
                            // Check if the following characters are actually the tag
                            NSRange potentialEscapedTagRange = NSMakeRange(NSMaxRange(escapeRange), tagString.length);
                            if ([[theString substringWithRange:potentialEscapedTagRange] isEqualToString:tagString]) {
                                nextTag = tag;
                                nextEscapeRange = escapeRange;
                                nextEscapedTagRange = potentialEscapedTagRange;
                            }
                        }
                    }
                }
            }
        }

        if (!nextTag) {
            break;
        }

        // Strip escape characters
        theString = [theString stringByReplacingOccurrencesOfString:nextTag.escapeString withString:@"" options:0 range:nextEscapeRange];
        NSRange range = NSMakeRange(nextEscapeRange.location, nextEscapedTagRange.length);

        [escapedRanges addObject:[NSValue valueWithRange:range]];

        searchRange = NSMakeRange(NSMaxRange(range), theString.length - NSMaxRange(range));
    }

    *string = theString;

    return escapedRanges;
}

+ (NSRange)firstOccurrenceOfString:(NSString *)string inString:(NSString *)stringToSearch ignoringRanges:(BONGeneric(NSArray, NSValue *) *)escapedRanges inRange:(NSRange)range
{
    NSParameterAssert(string);
    NSParameterAssert(stringToSearch);
    NSParameterAssert(escapedRanges);

    NSRange searchRange = range;

    while (YES) {
        NSRange stringRange = [stringToSearch rangeOfString:string options:0 range:searchRange];

        // Ignore this match
        if ([escapedRanges containsObject:[NSValue valueWithRange:stringRange]]) {
            searchRange = NSMakeRange(NSMaxRange(stringRange), stringToSearch.length - NSMaxRange(stringRange));
            continue;
        }

        return stringRange;
    }
}

+ (BONGeneric(NSArray, BONTag *) *)rangesInString:(NSString **)string betweenTags:(BONGeneric(NSArray, BONTag *) *)tags
{
    NSParameterAssert(string);
    NSParameterAssert(tags);

    BONGeneric(NSArray, NSValue *)*escapedRanges = [BONTag escapedRangesInString:string withTags:tags];

    BONGeneric(NSArray, BONTag *)*tagsWithRanges = [[NSArray alloc] initWithArray:tags copyItems:YES];

    NSString *theString = *string;

    NSRange searchRange = NSMakeRange(0, theString.length);

    // Iterate over the string, finding each tag in order, until there are no more tags
    while (YES) {
        BONTag *nextTag;
        NSRange nextStartTagRange;
        NSRange nextEndTagRange;

        // Find the next start tag
        for (BONTag *tag in tagsWithRanges) {
            NSRange startTagRange = [BONTag firstOccurrenceOfString:tag.startTag inString:theString ignoringRanges:escapedRanges inRange:searchRange];
            NSRange endTagRange = [BONTag firstOccurrenceOfString:tag.endTag inString:theString ignoringRanges:escapedRanges inRange:searchRange];
            if (startTagRange.location != NSNotFound && endTagRange.location != NSNotFound) {
                if (!nextTag || (startTagRange.location < nextStartTagRange.location)) {
                    nextTag = tag;
                    nextStartTagRange = startTagRange;
                    nextEndTagRange = endTagRange;
                }
            }
        }

        if (!nextTag) {
            break;
        }

        NSRange range = NSMakeRange(NSMaxRange(nextStartTagRange), nextEndTagRange.location - NSMaxRange(nextStartTagRange));

        // Strip valid tags
        range.location -= nextTag.startTag.length;

        theString = [theString stringByReplacingOccurrencesOfString:nextTag.startTag withString:@"" options:0 range:nextStartTagRange];
        nextStartTagRange.length = 0;

        nextEndTagRange.location -= nextTag.startTag.length;
        theString = [theString stringByReplacingOccurrencesOfString:nextTag.endTag withString:@"" options:0 range:nextEndTagRange];
        nextEndTagRange.length = 0;

        [nextTag.ranges addObject:[NSValue valueWithRange:range]];

        searchRange = NSMakeRange(NSMaxRange(nextEndTagRange), theString.length - NSMaxRange(nextEndTagRange));
    }

    *string = theString;

    return tagsWithRanges;
}

#pragma mark - Equality

- (BOOL)isEqualToTag:(BONTag *)tag
{
    return [tag.startTag isEqualToString:self.startTag] &&
           [tag.endTag isEqualToString:self.endTag] &&
           [tag.textable isEqual:self.textable] &&
           [tag.escapeString isEqualToString:self.escapeString] &&
           [tag.ranges isEqualToArray:self.ranges];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[BONTag class]]) {
        return NO;
    }

    return [self isEqualToTag:(BONTag *)object];
}

- (NSUInteger)hash
{
    return self.startTag.hash ^ self.endTag.hash ^ self.textable.hash ^ self.escapeString.hash ^ self.ranges.hash;
}

@end
