//
//  BONDictionaryEqualityTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 7/11/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
#import "NSDictionary+BONEquality.h"

@interface BONDictionaryEqualityTestCase : BONBaseTestCase

@end

@implementation BONDictionaryEqualityTestCase

- (void)testReflexivity
{
    NSDictionary *theDict = @{ @"asdf": @1.0f };
    XCTAssertTrue([theDict bon_isCloseEnoughEqualToDictionary:theDict]);

    NSDictionary *nilDict = nil;
    XCTAssertFalse([nilDict bon_isCloseEnoughEqualToDictionary:nilDict]);
}

- (void)testUnambiguouslyWrong
{
    NSDictionary *dict1 = @{ @"asdf": @1.0f };
    NSDictionary *dict2 = @{ @"jkl;": @"a string" };
    XCTAssertFalse([dict1 bon_isCloseEnoughEqualToDictionary:dict2]);

    NSDictionary *dict3 = @{ @"asdf": @1.0f, @"more keys": @"just stuff" };
    XCTAssertFalse([dict1 bon_isCloseEnoughEqualToDictionary:dict3]);
    XCTAssertFalse([dict3 bon_isCloseEnoughEqualToDictionary:dict1]);
}

- (void)testCloseFloats
{
    NSString *key = @"key";
    NSString *otherKey = @"otherKey";
    XCTAssertTrue([@{ key: @(1.0f / 3.0f) } bon_isCloseEnoughEqualToDictionary:@{ key: @( 1.0 / 3.0 ) }]);
    XCTAssertTrue([@{ key: @3.14000000001 } bon_isCloseEnoughEqualToDictionary:@{ key: @3.14000000002}]);

    NSDictionary *dict1 = @{ key: @3.14000000001 };
    NSDictionary *dict2 = @{ key: @3.14000000002, otherKey: @17 };
    XCTAssertFalse([dict1 bon_isCloseEnoughEqualToDictionary:dict2]);
}

- (void)testMutableDictionary
{
    NSMutableDictionary *dict1 = [@{ @"asdf": @1.0f } mutableCopy];
    NSMutableDictionary *dict2 = [@{ @"asdf": @1.0f } mutableCopy];
    NSDictionary *dict3 = @{ @"asdf": @1.0f };
    XCTAssertTrue([dict1 bon_isCloseEnoughEqualToDictionary:dict2]);
    XCTAssertTrue([dict2 bon_isCloseEnoughEqualToDictionary:dict1]);
    XCTAssertTrue([dict2 bon_isCloseEnoughEqualToDictionary:dict3]);
    XCTAssertTrue([dict3 bon_isCloseEnoughEqualToDictionary:dict2]);
    XCTAssertTrue([dict3 bon_isCloseEnoughEqualToDictionary:dict1]);
    XCTAssertTrue([dict1 bon_isCloseEnoughEqualToDictionary:dict3]);
}

- (void)testMacro
{
    NSMutableDictionary *dict1 = [@{ @"asdf": @1.000001f } mutableCopy];
    NSMutableDictionary *dict2 = [@{ @"asdf": @1.000002f } mutableCopy];
    NSDictionary *dict3 = @{ @"asdf": @1.000003f };
    BONAssertEqualDictionaries(dict1, dict2);
    BONAssertEqualDictionaries(dict2, dict1);
    BONAssertEqualDictionaries(dict2, dict3);
    BONAssertEqualDictionaries(dict3, dict2);
    BONAssertEqualDictionaries(dict1, dict3);
    BONAssertEqualDictionaries(dict3, dict1);
}

@end
