//
//  BONTextableTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 10/9/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;

@interface BONTextableTestCase : BONBaseTestCase

@end

@implementation BONTextableTestCase

- (void)testAppending
{
    BONChain *chain = BONChain.new.string(@"Hello, ");
    [chain appendLink:BONChain.new.string(@"world!")];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testJoining
{
    BONChain *chain1 = BONChain.new.string(@"Hello, ");
    BONChain *chain2 = BONChain.new.string(@"world!");

    NSAttributedString *attributedString = [BONText joinTextables:@[ chain1, chain2 ] withSeparator:nil];

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testJoiningNil
{
    NSAttributedString *nilSeparatorString = [BONText joinTextables:nil withSeparator:nil];

    XCTAssertEqualObjects(nilSeparatorString, [[NSAttributedString alloc] init]);

    NSAttributedString *someSeparatorString = [BONText joinTextables:nil withSeparator:BONChain.new.string(@"ignore me")];

    XCTAssertEqualObjects(someSeparatorString, [[NSAttributedString alloc] init]);
}

- (void)testJoiningOne
{
    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 5) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    NSAttributedString *nilSeparatorString = [BONText joinTextables:@[ BONChain.new.string(@"hello") ] withSeparator:nil];

    BONAssertAttributedStringHasAttributes(nilSeparatorString, controlAttributes);

    NSAttributedString *someSeparatorString = [BONText joinTextables:@[ BONChain.new.string(@"hello") ] withSeparator:BONChain.new.string(@"im in ur tests, causin trouble")];

    BONAssertAttributedStringHasAttributes(someSeparatorString, controlAttributes);
}

- (void)testAppendingWithSeparator
{
    BONChain *chain = BONChain.new.string(@"Hello");
    [chain appendLink:BONChain.new.string(@"world!") separator:@", "];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testJoiningWithSeparator
{
    BONChain *chain1 = BONChain.new.string(@"Hello");
    BONChain *chain2 = BONChain.new.string(@"world!");

    NSAttributedString *attributedString = [BONText joinTextables:@[ chain1, chain2 ] withSeparator:BONChain.new.string(@", ")];

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testAppendingWithNilSeparator
{
    BONChain *chain = BONChain.new.string(@"Hello, ");
    [chain appendLink:BONChain.new.string(@"world!") separator:nil];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testAppendingWithEmptySeparator
{
    BONChain *chain = BONChain.new.string(@"Hello, ");
    [chain appendLink:BONChain.new.string(@"world!") separator:@""];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testJoiningWithEmptySeparator
{
    BONChain *chain1 = BONChain.new.string(@"Hello, ");
    BONChain *chain2 = BONChain.new.string(@"world!");

    NSAttributedString *attributedString = [BONText joinTextables:@[ chain1, chain2 ] withSeparator:BONChain.new.string(@"")];

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 13) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testAppendingWithDifferentAttributes
{
    BONChain *chain = BONChain.new.string(@"Hello").color([UIColor redColor]);
    [chain appendLink:BONChain.new.string(@"world!").color([UIColor blueColor]) separator:@", "];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 7) : @{
            NSForegroundColorAttributeName : [UIColor redColor],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
        BONValueFromRange(7, 6) : @{
            NSForegroundColorAttributeName : [UIColor blueColor],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testJoiningWithDifferentAttributes
{
    BONChain *chain1 = BONChain.new.string(@"Hello").textColor([UIColor redColor]);
    BONChain *chain2 = BONChain.new.string(@"world!").textColor([UIColor blueColor]);

    NSAttributedString *attributedString = [BONText joinTextables:@[ chain1, chain2 ] withSeparator:chain1.string(@", ")];

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 7) : @{
            NSForegroundColorAttributeName : [UIColor redColor],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
        BONValueFromRange(7, 6) : @{
            NSForegroundColorAttributeName : [UIColor blueColor],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testMultipleAppendings
{
    BONChain *chain = BONChain.new.string(@"Hello, ");
    [chain appendLink:BONChain.new.string(@"world!")];
    [chain appendLink:BONChain.new.string(@"It really is a lovely day today.") separator:@" "];

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world! It really is a lovely day today.");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 46) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testAppendingImages
{
    UIImage *barnImage = [UIImage imageNamed:@"barn" inBundle:[NSBundle bundleForClass:[DummyAssetClass class]] compatibleWithTraitCollection:nil];
    XCTAssertNotNil(barnImage);
    XCTAssertEqualWithAccuracy(barnImage.size.width, 36.0, kBONDoubleEpsilon);
    XCTAssertEqualWithAccuracy(barnImage.size.height, 36.0, kBONDoubleEpsilon);

    BONChain *imageChain = BONChain.new.image(barnImage);

    NSAttributedString *imageString = imageChain.attributedString;
    NSString *controlImageString = [NSString stringWithFormat:@"%C", (unichar)NSAttachmentCharacter];
    XCTAssertEqualObjects(imageString.string, controlImageString);

    BONChain *textChain = BONChain.new.string(@"concatenate me!");
    NSAttributedString *textString = textChain.attributedString;
    XCTAssertEqualObjects(textString.string, @"concatenate me!");

    [imageChain appendLink:textChain separator:BONSpecial.noBreakSpace];

    NSAttributedString *testString = imageChain.attributedString;

    NSString *controlString = [NSString stringWithFormat:@"%C%@concatenate me!", (unichar)NSAttachmentCharacter, BONSpecial.noBreakSpace];
    XCTAssertEqualObjects(testString.string, controlString);
}

- (void)testJoiningImages
{
    UIImage *barnImage = [UIImage imageNamed:@"barn" inBundle:[NSBundle bundleForClass:[DummyAssetClass class]] compatibleWithTraitCollection:nil];
    XCTAssertNotNil(barnImage);
    XCTAssertEqualWithAccuracy(barnImage.size.width, 36.0, kBONDoubleEpsilon);
    XCTAssertEqualWithAccuracy(barnImage.size.height, 36.0, kBONDoubleEpsilon);

    BONChain *imageChain = BONChain.new.image(barnImage);

    NSAttributedString *imageString = imageChain.attributedString;
    NSString *controlImageString = [NSString stringWithFormat:@"%C", (unichar)NSAttachmentCharacter];
    XCTAssertEqualObjects(imageString.string, controlImageString);

    BONChain *textChain = BONChain.new.string(@"concatenate me!");
    NSAttributedString *textString = textChain.attributedString;
    XCTAssertEqualObjects(textString.string, @"concatenate me!");

    NSAttributedString *testString = [BONText joinTextables:@[ imageChain, textChain ] withSeparator:imageChain.string(BONSpecial.noBreakSpace)];

    NSString *controlString = [NSString stringWithFormat:@"%C%@concatenate me!", (unichar)NSAttachmentCharacter, BONSpecial.noBreakSpace];
    XCTAssertEqualObjects(testString.string, controlString);
}

@end
