//
//  BONUnderlineAndStrikethroughTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 12/18/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;

@interface BONUnderlineAndStrikethroughTestCase : BONBaseTestCase

@end

@implementation BONUnderlineAndStrikethroughTestCase

- (void)testNeither
{
    NSString *quote = @"I’d just like to underline: if you strike me through, I shall become more powerfull than you can possibly imagine.";
    NSDictionary *attributes = BONChain.new.string(quote).attributes;

    XCTAssertNil(attributes[NSUnderlineStyleAttributeName]);
    XCTAssertNil(attributes[NSUnderlineColorAttributeName]);

    XCTAssertNil(attributes[NSStrikethroughStyleAttributeName]);
    XCTAssertNil(attributes[NSStrikethroughColorAttributeName]);
}

- (void)testSimpleUnderline
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"Hello, world")
            .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
            .color([UIColor redColor])
            .underlineStyle(NSUnderlineStyleSingle)
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 12) : @{
            NSForegroundColorAttributeName : [UIColor redColor],
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testSimpleStrikethrough
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"Hello, world")
            .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
            .color([UIColor redColor])
            .strikethroughStyle(NSUnderlineStyleSingle)
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 12) : @{
            NSForegroundColorAttributeName : [UIColor redColor],
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle),
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testColorfulUnderline
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"Hello, world")
            .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
            .color([UIColor redColor])
            .underlineStyle(NSUnderlineStyleSingle)
            .underlineColor([UIColor redColor])
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 12) : @{
            NSForegroundColorAttributeName : [UIColor redColor],
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
            NSUnderlineColorAttributeName : [UIColor redColor],
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testColorfulStrikethrough
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"Hello, world")
            .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
            .color([UIColor redColor])
            .strikethroughStyle(NSUnderlineStyleSingle)
            .strikethroughColor([UIColor greenColor])
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 12) : @{
            NSForegroundColorAttributeName : [UIColor redColor],
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle),
            NSStrikethroughColorAttributeName : [UIColor greenColor],
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testUnderlineAndStrikethrough
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"Hello, world")
            .font([UIFont preferredFontForTextStyle:UIFontTextStyleBody])
            .color([UIColor redColor])
            .underlineStyle(NSUnderlineStyleThick)
            .underlineColor([UIColor blueColor])
            .strikethroughStyle(NSUnderlineStyleDouble | NSUnderlinePatternDashDot)
            .strikethroughColor([UIColor greenColor])
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 12) : @{
            NSForegroundColorAttributeName : [UIColor redColor],
            NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
            NSUnderlineStyleAttributeName : @(NSUnderlineStyleThick),
            NSUnderlineColorAttributeName : [UIColor blueColor],
            NSStrikethroughStyleAttributeName : @(NSUnderlineStyleDouble | NSUnderlinePatternDashDot),
            NSStrikethroughColorAttributeName : [UIColor greenColor],
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

@end
