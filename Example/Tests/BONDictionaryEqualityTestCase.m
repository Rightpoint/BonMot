//
//  BONDictionaryEqualityTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 7/11/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
#import "NSDictionary+BONEquality.h"

@interface BONDictionaryEqualityTestCase : BONBaseTestCase

@end

@implementation BONDictionaryEqualityTestCase

- (void)testReflexivity
{
    NSDictionary *theDict = @{ @"asdf" : @1.0 };
    XCTAssertTrue([theDict bon_isCloseEnoughEqualToDictionary:theDict]);

    NSDictionary *nilDict = nil;
    XCTAssertFalse([nilDict bon_isCloseEnoughEqualToDictionary:nilDict]);
}

- (void)testUnambiguouslyWrong
{
    NSDictionary *dict1 = @{ @"asdf" : @1.0 };
    NSDictionary *dict2 = @{ @"jkl;" : @"a string" };
    XCTAssertFalse([dict1 bon_isCloseEnoughEqualToDictionary:dict2]);

    NSDictionary *dict3 = @{
        @"asdf" : @1.0,
        @"more keys" : @"just stuff",
    };
    XCTAssertFalse([dict1 bon_isCloseEnoughEqualToDictionary:dict3]);
    XCTAssertFalse([dict3 bon_isCloseEnoughEqualToDictionary:dict1]);

    NSDictionary *dict4 = @{ @"asdf" : @2.0 };
    XCTAssertFalse([dict1 bon_isCloseEnoughEqualToDictionary:dict4]);

    NSDictionary *dict5 = @{ @"asdf" : @"sike - not a number!" };
    XCTAssertFalse([dict1 bon_isCloseEnoughEqualToDictionary:dict5]);
}

- (void)testCloseFloats
{
    NSString *key = @"key";
    NSString *otherKey = @"otherKey";
    XCTAssertTrue([@{ key : @(1.0 / 3.0) } bon_isCloseEnoughEqualToDictionary:@{ key : @(1.0 / 3.0) }]);
    XCTAssertTrue([@{ key : @3.14000000001 } bon_isCloseEnoughEqualToDictionary:@{ key : @3.14000000002 }]);

    NSDictionary *dict1 = @{ key : @3.14000000001 };
    NSDictionary *dict2 = @{
        key : @3.14000000002,
        otherKey : @17,
    };
    XCTAssertFalse([dict1 bon_isCloseEnoughEqualToDictionary:dict2]);
}

- (void)testMutableDictionary
{
    NSMutableDictionary *dict1 = [@{ @"asdf" : @1.0 } mutableCopy];
    NSMutableDictionary *dict2 = [@{ @"asdf" : @1.0 } mutableCopy];
    NSDictionary *dict3 = @{ @"asdf" : @1.0 };
    XCTAssertTrue([dict1 bon_isCloseEnoughEqualToDictionary:dict2]);
    XCTAssertTrue([dict2 bon_isCloseEnoughEqualToDictionary:dict1]);
    XCTAssertTrue([dict2 bon_isCloseEnoughEqualToDictionary:dict3]);
    XCTAssertTrue([dict3 bon_isCloseEnoughEqualToDictionary:dict2]);
    XCTAssertTrue([dict3 bon_isCloseEnoughEqualToDictionary:dict1]);
    XCTAssertTrue([dict1 bon_isCloseEnoughEqualToDictionary:dict3]);
}

- (void)testBONAssertEqualDictionaries
{
    NSMutableDictionary *dict1 = [@{ @"asdf" : @1.000001 } mutableCopy];
    NSMutableDictionary *dict2 = [@{ @"asdf" : @1.000002 } mutableCopy];
    NSDictionary *dict3 = @{ @"asdf" : @1.000003 };
    BONAssertEqualDictionaries(dict1, dict2);
    BONAssertEqualDictionaries(dict2, dict1);
    BONAssertEqualDictionaries(dict2, dict3);
    BONAssertEqualDictionaries(dict3, dict2);
    BONAssertEqualDictionaries(dict1, dict3);
    BONAssertEqualDictionaries(dict3, dict1);
}

- (void)testBONDoublesCloseEnough
{
    XCTAssertTrue(BONDoublesCloseEnough(0.0, 0.0));
    XCTAssertTrue(BONDoublesCloseEnough(0.0, 0.0000000001));
    XCTAssertTrue(BONDoublesCloseEnough((1.0 - 0.9) - 0.1, 0.0));
    XCTAssertTrue(BONDoublesCloseEnough((1.0 - 0.9) - 0.1, 0.0));
    XCTAssertFalse(BONDoublesCloseEnough(0.0, 0.01));
}

@end
