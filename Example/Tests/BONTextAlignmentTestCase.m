//
//  BONTextAlignmentTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 10/30/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;

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
        BONValueFromRange(0, 14) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
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
        BONValueFromRange(0, 14) : @{
            NSParagraphStyleAttributeName : controlParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(string, controlAttributes);

    NSDictionary *testAttributes = chain.attributes;
    NSParagraphStyle *testParagraphStyle = testAttributes[NSParagraphStyleAttributeName];
    XCTAssertNotNil(testParagraphStyle);
    XCTAssertEqual(testParagraphStyle.alignment, NSTextAlignmentCenter);
}

// Test setting the various paragraph style attributes
- (void)testParagraphStyle
{
    BONChain *chain = BONChain.new
        .string(@"E pluribus unum")
        .alignment(NSTextAlignmentCenter)
        .firstLineHeadIndent(1.23)
        .headIndent(2.34)
        .tailIndent(3.45)
        .lineHeightMultiple(3.14)
        .maximumLineHeight(5.67)
        .minimumLineHeight(4.56)
        .lineSpacing(2.72)
        .paragraphSpacing(6.78)
        .paragraphSpacingBefore(7.89);
    NSAttributedString *string = chain.attributedString;

    NSMutableParagraphStyle *controlParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    controlParagraphStyle.alignment = NSTextAlignmentCenter;
    controlParagraphStyle.firstLineHeadIndent = 1.23;
    controlParagraphStyle.headIndent = 2.34;
    controlParagraphStyle.tailIndent = 3.45;
    controlParagraphStyle.lineHeightMultiple = 3.14;
    controlParagraphStyle.maximumLineHeight = 5.67;
    controlParagraphStyle.minimumLineHeight = 4.56;
    controlParagraphStyle.lineSpacing = 2.72;
    controlParagraphStyle.paragraphSpacing = 6.78;
    controlParagraphStyle.paragraphSpacingBefore = 7.89;

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 15) : @{
            NSParagraphStyleAttributeName : controlParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(string, controlAttributes);

    NSDictionary *testAttributes = chain.attributes;
    NSParagraphStyle *testParagraphStyle = testAttributes[NSParagraphStyleAttributeName];
    XCTAssertNotNil(testParagraphStyle);
    XCTAssertEqual(testParagraphStyle.alignment, NSTextAlignmentCenter);
    XCTAssertEqualWithAccuracy(testParagraphStyle.firstLineHeadIndent, 1.23, kBONCGFloatEpsilon);
    XCTAssertEqualWithAccuracy(testParagraphStyle.headIndent, 2.34, kBONCGFloatEpsilon);
    XCTAssertEqualWithAccuracy(testParagraphStyle.tailIndent, 3.45, kBONCGFloatEpsilon);
    XCTAssertEqualWithAccuracy(testParagraphStyle.lineHeightMultiple, 3.14, kBONCGFloatEpsilon);
    XCTAssertEqualWithAccuracy(testParagraphStyle.maximumLineHeight, 5.67, kBONCGFloatEpsilon);
    XCTAssertEqualWithAccuracy(testParagraphStyle.minimumLineHeight, 4.56, kBONCGFloatEpsilon);
    XCTAssertEqualWithAccuracy(testParagraphStyle.lineSpacing, 2.72, kBONCGFloatEpsilon);
    XCTAssertEqualWithAccuracy(testParagraphStyle.paragraphSpacing, 6.78, kBONCGFloatEpsilon);
    XCTAssertEqualWithAccuracy(testParagraphStyle.paragraphSpacingBefore, 7.89, kBONCGFloatEpsilon);
}

@end
