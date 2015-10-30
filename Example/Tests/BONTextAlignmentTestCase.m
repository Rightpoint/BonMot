//
//  BONTextAlignmentTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 10/30/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
#import <BONMot/BonMot.h>

@interface BONTextAlignmentTestCase : BONBaseTestCase

@end

@implementation BONTextAlignmentTestCase


- (void)testDefaultAlignmentOfText
{
    BONText *text = [[BONText alloc] init];
    XCTAssertEqual(text.alignment, NSTextAlignmentNatural);

    text = BONText.new;
    XCTAssertEqual(text.alignment, NSTextAlignmentNatural);

    text.alignment = NSTextAlignmentRight;
    XCTAssertEqual(text.alignment, NSTextAlignmentRight);
}

- (void)testDefaultAlignmentOfChain
{
    NSAttributedString *string = BONChain.new.string(@"E pur si muove").attributedString;

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 14): @{
                                                NSParagraphStyleAttributeName: defaultParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(string, controlAttributes);
}

- (void)testAdjustedAlignment
{
    BONChain *chain = BONChain.new.string(@"E pur si muove").alignment(NSTextAlignmentCenter);
    NSAttributedString *string = chain.attributedString;

    NSMutableParagraphStyle *controlParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    controlParagraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 14): @{
                                                NSParagraphStyleAttributeName: controlParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(string, controlAttributes);

    NSDictionary *testAttributes = chain.attributes;
    NSParagraphStyle *testParagraphStyle = testAttributes[NSParagraphStyleAttributeName];
    XCTAssertNotNil(testParagraphStyle);
    XCTAssertEqual(testParagraphStyle.alignment, NSTextAlignmentCenter);
}

// Test setting both line height multiple and alignment, since they both affect the paragraph style
- (void)testMixingAlignmentAndLineHeightMultiple
{
    BONChain *chain = BONChain.new.string(@"E pluribus unum").alignment(NSTextAlignmentCenter).lineHeightMultiple(3.14);
    NSAttributedString *string = chain.attributedString;

    NSMutableParagraphStyle *controlParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    controlParagraphStyle.alignment = NSTextAlignmentCenter;
    controlParagraphStyle.lineHeightMultiple = 3.14;

    NSDictionary *controlAttributes = @{
                                        BONValueFromRange(0, 15): @{
                                                NSParagraphStyleAttributeName: controlParagraphStyle,
                                                },
                                        };

    BONAssertAttributedStringHasAttributes(string, controlAttributes);

    NSDictionary *testAttributes = chain.attributes;
    NSParagraphStyle *testParagraphStyle = testAttributes[NSParagraphStyleAttributeName];
    XCTAssertNotNil(testParagraphStyle);
    XCTAssertEqual(testParagraphStyle.alignment, NSTextAlignmentCenter);
    XCTAssertEqualWithAccuracy(testParagraphStyle.lineHeightMultiple, 3.14, kBONCGFloatEpsilon);
}

@end
