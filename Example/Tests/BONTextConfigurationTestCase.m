//
//  BONTextConfigurationTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 6/16/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
@import UIKit;

#import <BonMot/BONChainLink.h>

@interface BONTextConfigurationTestCase : BONBaseTestCase

@end

@implementation BONTextConfigurationTestCase

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

- (void)testTextConfiguration
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

@end
