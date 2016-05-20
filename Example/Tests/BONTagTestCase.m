//
//  BONTagTestCase.m
//  BonMot
//
//  Created by Nora Trapp on 5/17/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
@import BonMot;

@interface BONTag ()

@property (strong, nonatomic, BONNonnull) BONGeneric(NSMutableArray, NSValue *) * ranges;

+ (BONNonnull BONGeneric(NSArray, NSValue *) *)escapedRangesInString:(NSString *BONCNonnull *BONCNonnull)string withTags:(BONNonnull BONGeneric(NSArray, BONTag *) *)tags;
+ (NSRange)firstOccurrenceOfString:(BONNonnull NSString *)string inString:(BONNonnull NSString *)stringToSearch ignoringRanges:(BONNonnull BONGeneric(NSArray, NSValue *) *)escapedRanges inRange:(NSRange)range;
+ (BONNonnull BONGeneric(NSArray, BONTag *) *)rangesInString:(NSString *BONCNonnull *BONCNonnull)string betweenTags:(BONNonnull BONGeneric(NSArray, BONTag *) *)tags;
@end

@import BonMot;

@interface BONTagTestCase : BONBaseTestCase

@end

@implementation BONTagTestCase

- (void)testEscapedRangesInString
{
    NSString *string = @"This is a \\<b> string that \\</b> has \\escaped characters.";
    NSArray *ranges = [BONTag escapedRangesInString:&string withTags:@[ BONTagMake(@"b", BONChain.new) ]];

    NSString *stringWithoutEscapes = @"This is a <b> string that </b> has \\escaped characters.";
    XCTAssertEqualObjects(string, stringWithoutEscapes);

    NSArray *escapedRanges = @[ [NSValue valueWithRange:NSMakeRange(10, 3)], [NSValue valueWithRange:NSMakeRange(26, 4)] ];
    XCTAssertEqualObjects(ranges, escapedRanges);
}

- (void)testMixedEscapeStrings
{
    NSString *string = @"This is a \\<b> string that \\</b> has \\escaped ~escaped characters.";
    NSArray *ranges = [BONTag escapedRangesInString:&string withTags:@[ BONTagMake(@"b", BONChain.new), BONTagComplexMake(@"escaped", @"escaped", @"~", BONChain.new) ]];

    NSString *stringWithoutEscapes = @"This is a <b> string that </b> has \\escaped escaped characters.";
    XCTAssertEqualObjects(string, stringWithoutEscapes);

    NSArray *escapedRanges = @[ [NSValue valueWithRange:NSMakeRange(10, 3)], [NSValue valueWithRange:NSMakeRange(26, 4)], [NSValue valueWithRange:NSMakeRange(44, 7)] ];
    XCTAssertEqualObjects(ranges, escapedRanges);
}

- (void)testFirstOccurenceOfString
{
    NSString *string = @"This is a \\<b> string that \\</b> has \\escaped characters.";
    NSRange range = [BONTag firstOccurrenceOfString:@"<b>" inString:string ignoringRanges:@[] inRange:NSMakeRange(0, string.length)];

    XCTAssertTrue(NSEqualRanges(range, NSMakeRange(11, 3)));
}

- (void)testFirstOccurenceOfStringWithIgnoredRange
{
    NSString *string = @"This is <b> a \\<b> string that \\</b> has \\escaped characters.";
    NSArray *ignoredRanges = @[ [NSValue valueWithRange:NSMakeRange(8, 3)] ];
    NSRange range = [BONTag firstOccurrenceOfString:@"<b>" inString:string ignoringRanges:ignoredRanges inRange:NSMakeRange(0, string.length)];

    XCTAssertTrue(NSEqualRanges(range, NSMakeRange(15, 3)));
}

- (void)testRangesBetweenTags
{
    NSString *string = @"This is a <b>tagged</b> string.";
    NSArray *tags = [BONTag rangesInString:&string betweenTags:@[ BONTagMake(@"b", BONChain.new) ]];

    NSString *stringWithoutTags = @"This is a tagged string.";
    XCTAssertEqualObjects(string, stringWithoutTags);

    NSArray *tagRanges = @[ [NSValue valueWithRange:NSMakeRange(10, 6)] ];
    BONTag *resultTag = tags.firstObject;
    XCTAssertEqualObjects(resultTag.ranges, tagRanges);
}

@end
