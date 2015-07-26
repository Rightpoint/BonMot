//
//  BONTextTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 6/16/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

#import <BonMot/BonMot.h>

@interface BONTextTestCase : BONBaseTestCase

@end

@implementation BONTextTestCase

- (void)testText
{
    NSAttributedString *attributedString =
    BONChain.new
    .string(@"Hello, testing world")
    .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
    .textColor([UIColor redColor])
    .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, testing world");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 20): @{
                                                NSForegroundColorAttributeName: [UIColor redColor],
                                                NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testPositivePointTracking
{
    NSAttributedString *attributedString =
    BONChain.new
    .string(@"Tracking is awesome!")
    .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
    .pointTracking(3)
    .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Tracking is awesome!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 19): @{
                                                NSKernAttributeName: @3,
                                                NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },

                                        BONValueFromRange(19, 1): @{
                                                NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                }
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testPositiveAdobeTracking
{
    NSAttributedString *attributedString =
    BONChain.new
    .string(@"Tracking is awesome!")
    .font([UIFont systemFontOfSize:16.0f])
    .adobeTracking(230)
    .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Tracking is awesome!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 19): @{
                                                NSKernAttributeName: @3.68,
                                                NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },

                                        BONValueFromRange(19, 1): @{
                                                NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                }
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testNegativePointTracking
{
    NSAttributedString *attributedString =
    BONChain.new
    .string(@"Tracking is awesome!")
    .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
    .pointTracking(-3)
    .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Tracking is awesome!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 19): @{
                                                NSKernAttributeName: @-3,
                                                NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },

                                        BONValueFromRange(19, 1): @{
                                                NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                }
                                        };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testNegativeAdobeTracking
{
    NSAttributedString *attributedString =
    BONChain.new
    .string(@"Tracking is awesome!")
    .font([UIFont systemFontOfSize:16.0f])
    .adobeTracking(-230)
    .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Tracking is awesome!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 19): @{
                                                NSKernAttributeName: @-3.68,
                                                NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },

                                        BONValueFromRange(19, 1): @{
                                                NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                }
                                        };
    
    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

@end
