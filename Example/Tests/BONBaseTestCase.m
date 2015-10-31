//
//  BONBaseTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 7/10/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

NSValue *BONValueFromRange(NSUInteger location, NSUInteger length)
{
    NSRange range = NSMakeRange(location, length);
    NSValue *value = [NSValue valueWithRange:range];
    return value;
}

@implementation BONBaseTestCase : XCTestCase

@end
