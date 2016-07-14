//
//  BONURLTestCase.m
//  BonMot
//
//  Created by Phil Larson on 6/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;

@interface BONURLTestCase : BONBaseTestCase

@end

@implementation BONURLTestCase

- (void)testNeither
{
    NSString *quote = @"Hello, world";
    NSDictionary *attributes = BONChain.new.string(quote).attributes;

    XCTAssertNil(attributes[NSLinkAttributeName]);
}

- (void)testURL
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"Hello, world")
            .url([NSURL URLWithString:@"https://apple.com"])
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world");

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 12) : @{
            NSLinkAttributeName : [NSURL URLWithString:@"https://apple.com"],
            NSParagraphStyleAttributeName : [[NSParagraphStyle alloc] init]
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

@end
