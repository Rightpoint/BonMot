//
//  BONTagComplexMakeTestCase.m
//  BonMot
//
//  Created by Nora Trapp on 3/3/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;

@interface BONTagComplexMakeTestCase : BONBaseTestCase

@end

@implementation BONTagComplexMakeTestCase

- (void)testSingleTagSingleStyle
{
    BONChain *chain = BONChain.new.string(@"Hello, [i]world(i)!")
                          .tagComplexStyles(@[ BONTagComplexMake(@"[i]", @"(i)", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])) ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 7) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(7, 5) : @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(12, 1) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testMultipleTagsSingleStyle
{
    BONChain *chain = BONChain.new.string(@"[i]Hello(i), [i]world(i)!")
                          .tagComplexStyles(@[ BONTagComplexMake(@"[i]", @"(i)", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])) ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 5) : @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(5, 2) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(7, 5) : @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(12, 1) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testSingleTagMultipleStyles
{
    BONChain *chain = BONChain.new.string(@"Hello, >b<world>b<*!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"[i]", @"(i)", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@">b<", @">b<*", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 7) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(7, 5) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(12, 1) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testMultipleTagsMultipleStyles
{
    BONChain *chain = BONChain.new.string(@">b<Hello>b<*, [i]world(i)!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"[i]", @"(i)", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@">b<", @">b<*", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 5) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(5, 2) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(7, 5) : @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(12, 1) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testInterleavedTags
{
    BONChain *chain = BONChain.new.string(@">b<Hello[i]>b<*, world(i)!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"[i]", @"(i)", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@">b<", @">b<*", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello[i], world(i)!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 8) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(8, 11) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testNestedTags
{
    BONChain *chain = BONChain.new.string(@">b<[i]Hello(i)>b<*, world!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"[i]", @"(i)", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@">b<", @">b<*", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"[i]Hello(i), world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 11) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(11, 8) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testMixedOrdering
{
    BONChain *chain = BONChain.new.string(@">b<Hel>b<*[i]lo(i), >b<wor>b<*[i]ld!(i)")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"[i]", @"(i)", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@">b<", @">b<*", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 3) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(3, 2) : @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(5, 2) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(7, 3) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(10, 3) : @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testEscapedStartTag
{
    BONChain *chain = BONChain.new.string(@"qwerty(b)(b)Hello[/b], world!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"(i)", @"[/i]", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@"(b)", @"[/b]", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"(b)Hello, world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 3) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(3, 5) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(8, 8) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testMultipleEscapedStartTag
{
    BONChain *chain = BONChain.new.string(@"qwerty(b)(b)Hello[/b]qwerty(b), world!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"(i)", @"[/i]", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@"(b)", @"[/b]", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"(b)Hello(b), world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 3) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(3, 5) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(8, 11) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testMultipleEscapedEndTag
{
    BONChain *chain = BONChain.new.string(@"qwerty[/b](b)Hello[/b]qwerty[/b], world!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"(i)", @"[/i]", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@"(b)", @"[/b]", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"[/b]Hello[/b], world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 4) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(4, 5) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(9, 12) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testNestedEscapedEndTag
{
    BONChain *chain = BONChain.new.string(@"(b)Helloqwerty[/b][/b], world!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"(i)", @"[/i]", @"qwerty", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@"(b)", @"[/b]", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"Hello[/b], world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 9) : @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(9, 8) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testInterleavedEscapedEndTag
{
    BONChain *chain = BONChain.new.string(@"qwerty[/b]asdfgh[/i]qwerty[/b](i)Helloasdfgh[/i][/i], world!")
                          .tagComplexStyles(@[
                              BONTagComplexMake(@"(i)", @"[/i]", @"asdfgh", BONChain.new.font([UIFont italicSystemFontOfSize:16])),
                              BONTagComplexMake(@"(b)", @"[/b]", @"qwerty", BONChain.new.font([UIFont boldSystemFontOfSize:16])),
                          ]);

    NSAttributedString *attributedString = chain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"[/b][/i][/b]Hello[/i], world!");

    NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 12) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(12, 9) : @{
            NSFontAttributeName : [UIFont italicSystemFontOfSize:16],
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },

        BONValueFromRange(21, 8) : @{
            NSParagraphStyleAttributeName : defaultParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

@end
