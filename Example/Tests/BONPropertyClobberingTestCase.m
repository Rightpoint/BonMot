//
//  BONPropertyClobberingTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 10/9/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

@import XCTest;

#import <BONMot/BonMot.h>

@interface BONPropertyClobberingTestCase : XCTestCase

@end

@implementation BONPropertyClobberingTestCase

- (void)testTrackingClobberingInBONText
{
    BONText *text = [BONText new];

    XCTAssertEqual(text.adobeTracking, 0);
    XCTAssertEqualWithAccuracy(text.pointTracking, 0.0f, 0.0001f);

    text.adobeTracking = 314;
    XCTAssertEqual(text.adobeTracking, 314);
    XCTAssertEqualWithAccuracy(text.pointTracking, 0.0f, 0.0001f);

    text.pointTracking = 2.718f;
    XCTAssertEqual(text.adobeTracking, 0);
    XCTAssertEqualWithAccuracy(text.pointTracking, 2.718f, 0.0001f);

    text.adobeTracking = 42;
    XCTAssertEqual(text.adobeTracking, 42);
    XCTAssertEqualWithAccuracy(text.pointTracking, 0.0f, 0.0001f);
}

- (void)testTrackingClobberingInBONChain
{
    BONChain *chain = [BONChain new];

    XCTAssertEqual(chain.text.adobeTracking, 0);
    XCTAssertEqualWithAccuracy(chain.text.pointTracking, 0.0f, 0.0001f);

    // Need to assing here because the chaining properties like .adobeTracking() copy, rather than mutating, the chain
    chain = chain.adobeTracking(314);
    XCTAssertEqual(chain.text.adobeTracking, 314);
    XCTAssertEqualWithAccuracy(chain.text.pointTracking, 0.0f, 0.0001f);

    chain = chain.pointTracking(2.718f);
    XCTAssertEqual(chain.text.adobeTracking, 0);
    XCTAssertEqualWithAccuracy(chain.text.pointTracking, 2.718f, 0.0001f);

    chain = chain.adobeTracking(42);
    XCTAssertEqual(chain.text.adobeTracking, 42);
    XCTAssertEqualWithAccuracy(chain.text.pointTracking, 0.0f, 0.0001f);
}

@end
