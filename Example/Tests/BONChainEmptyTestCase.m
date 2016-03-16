//
//  BONChainEmptyTestCase.m
//  BonMot
//
//  Created by Michael Skiba on 10/21/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;

@interface BONChainEmptyTestCase : BONBaseTestCase

@end

@implementation BONChainEmptyTestCase

- (void)testEmptyString
{
    XCTAssertNoThrow(BONChain.new.string(@"").attributedString);
}

- (void)testEmptyText
{
    BONChain *chain = BONChain.new.string(@"");
    XCTAssertTrue(chain.text.empty);

    BONText *text1 = [[BONText alloc] init];
    XCTAssertTrue(text1.empty);
    text1.string = @"";
    XCTAssertTrue(text1.empty);

    BONText *text2 = [[BONText alloc] init];
    text1.nextText = text2;
    XCTAssertTrue(text1.empty);

    text2.string = @"";
    text1.nextText = text2;
    XCTAssertTrue(text1.empty);

    text2.string = @"a";
    text1.nextText = text2;
    XCTAssertFalse(text1.empty);

    text1.nextText = nil;
    text1.string = @"b";
    XCTAssertFalse(text1.empty);
}

@end
