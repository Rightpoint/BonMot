//
//  BONTextTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 6/16/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
@import UIKit;

#import <BonMot/BONChain.h>

@interface BONTextTestCase : BONBaseTestCase

@end

@implementation BONTextTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testText
{
    NSAttributedString *attributedString =
    RZCursive
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
    RZCursive
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
    RZCursive
    .string(@"Tracking is awesome!")
    .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
    .adobeTracking(230)
    .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Tracking is awesome!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 19): @{
                                                NSKernAttributeName: @3.91,
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

- (void)testNegativePointTracking
{
    NSAttributedString *attributedString =
    RZCursive
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
    RZCursive
    .string(@"Tracking is awesome!")
    .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
    .adobeTracking(-230)
    .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Tracking is awesome!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 19): @{
                                                NSKernAttributeName: @-3.91,
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

@end
