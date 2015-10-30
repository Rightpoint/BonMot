//
//  BONChainEmptyStringTestCase.m
//  BonMot
//
//  Created by Michael Skiba on 10/21/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

#import <BonMot/BonMot.h>

@interface BONChainEmptyStringTestCase : BONBaseTestCase

@end

@implementation BONChainEmptyStringTestCase

- (void)testEmptyString
{
    XCTAssertNoThrow(BONChain.new.string(@"").attributedString);
}

@end
