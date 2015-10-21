//
//  BonChainCrashingTestCase.m
//  BonMot
//
//  Created by Michael Skiba on 10/21/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
#import "BONChain.h"

@interface BonChainCrashingTestCase : BONBaseTestCase

@end

@implementation BonChainCrashingTestCase

- (void)testExample {
    XCTAssertNoThrow(BONChain.new.string(@"").attributedString, @"Should not throw an error on creating an attributed string from empty strings");
}

@end
