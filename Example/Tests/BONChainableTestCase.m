//
//  BONChainableTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 10/9/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
#import <BONMot/BonMot.h>

@interface BONChainableTestCase : BONBaseTestCase

@end

@implementation BONChainableTestCase

- (void)testConcatenation
{
    BONChain *chain = BONChain.new.string(@"Hello, ");
    [chain appendLink:BONChain.new.string(@"world!")];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 13): @{
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testConcatenationWithSeparator
{
    BONChain *chain = BONChain.new.string(@"Hello");
    [chain appendLink:BONChain.new.string(@"world!") separator:@", "];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 13): @{
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testConcatenationWithNilSeparator
{
    BONChain *chain = BONChain.new.string(@"Hello, ");
    [chain appendLink:BONChain.new.string(@"world!") separator:nil];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 13): @{
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testConcatenationWithEmptySeparator
{
    BONChain *chain = BONChain.new.string(@"Hello, ");
    [chain appendLink:BONChain.new.string(@"world!") separator:@""];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 13): @{
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testConcatenationWithDifferentAttributes
{
    BONChain *chain = BONChain.new.string(@"Hello").textColor([UIColor redColor]);
    [chain appendLink:BONChain.new.string(@"world!").textColor([UIColor blueColor]) separator:@", "];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 7): @{
                                                NSForegroundColorAttributeName: [UIColor redColor],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },
                                        BONValueFromRange(7, 6): @{
                                                NSForegroundColorAttributeName: [UIColor blueColor],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },

                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testMultipleConcatenations
{
    BONChain *chain = BONChain.new.string(@"Hello, ");
    [chain appendLink:BONChain.new.string(@"world!")];
    [chain appendLink:BONChain.new.string(@"It really is a lovely day today.") separator:@" "];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world! It really is a lovely day today.");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 46): @{
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

@end
