//
//  BONPropertyClobberingTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 10/9/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;
#import "BONChain_Private.h"

@interface BONPropertyClobberingTestCase : BONBaseTestCase

@end

@implementation BONPropertyClobberingTestCase

- (void)testTrackingClobberingInBONText
{
    BONText *text = [BONText new];

    XCTAssertEqual(text.adobeTracking, 0);
    XCTAssertEqualWithAccuracy(text.pointTracking, 0.0, kBONDoubleEpsilon);

    text.adobeTracking = 314;
    XCTAssertEqual(text.adobeTracking, 314);
    XCTAssertEqualWithAccuracy(text.pointTracking, 0.0, kBONDoubleEpsilon);

    text.pointTracking = 2.718;
    XCTAssertEqual(text.adobeTracking, 0);
    XCTAssertEqualWithAccuracy(text.pointTracking, 2.718, kBONDoubleEpsilon);

    text.adobeTracking = 42;
    XCTAssertEqual(text.adobeTracking, 42);
    XCTAssertEqualWithAccuracy(text.pointTracking, 0.0, kBONDoubleEpsilon);
}

- (void)testTrackingClobberingInBONChain
{
    BONChain *chain = [BONChain new];

    XCTAssertEqual(chain.text.adobeTracking, 0);
    XCTAssertEqualWithAccuracy(chain.text.pointTracking, 0.0, kBONDoubleEpsilon);

    // Need to assing here because the chaining properties like .adobeTracking() copy, rather than mutating, the chain
    chain = chain.adobeTracking(314);
    XCTAssertEqual(chain.text.adobeTracking, 314);
    XCTAssertEqualWithAccuracy(chain.text.pointTracking, 0.0, kBONDoubleEpsilon);

    chain = chain.pointTracking(2.718);
    XCTAssertEqual(chain.text.adobeTracking, 0);
    XCTAssertEqualWithAccuracy(chain.text.pointTracking, 2.718, kBONDoubleEpsilon);

    chain = chain.adobeTracking(42);
    XCTAssertEqual(chain.text.adobeTracking, 42);
    XCTAssertEqualWithAccuracy(chain.text.pointTracking, 0.0, kBONDoubleEpsilon);
}

@end
