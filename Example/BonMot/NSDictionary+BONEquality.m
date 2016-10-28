//
//  NSDictionary+BONEquality.m
//  BonMot
//
//  Created by Zev Eisenberg on 7/11/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "NSDictionary+BONEquality.h"

@import CoreGraphics.CGBase;
@import UIKit.UIFont;

const double kBONDoubleEpsilon = 0.0001;

BOOL BONDoublesCloseEnough(double float1, double float2)
{
    return fabs(float1 - float2) < kBONDoubleEpsilon;
}

static BOOL BONNumberIsFloaty(NSNumber *number)
{
    BOOL floaty = NO;
    const char *numberType = number.objCType;
    if (strcmp(numberType, @encode(float)) == 0 ||
        strcmp(numberType, @encode(double)) == 0 ||
        strcmp(numberType, @encode(long double)) == 0) {
        floaty = YES;
    }

    return floaty;
}

@implementation NSDictionary (BONEquality)

- (BOOL)bon_isCloseEnoughEqualToDictionary:(NSDictionary *)dictionary
{
    BOOL equal = YES;

    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        BOOL sameKeys = [self.class bon_dictionary:self hasSameKeysAsDictionary:dictionary];
        if (sameKeys) {
            for (NSString *key in self.allKeys) {
                id selfValue = self[key];
                id otherValue = dictionary[key];
                if (![selfValue isEqual:otherValue]) {
                    if ([selfValue isKindOfClass:[NSNumber class]] && [otherValue isKindOfClass:[NSNumber class]]) {
                        if (BONNumberIsFloaty(selfValue) && BONNumberIsFloaty(otherValue)) {
                            double selfDouble = [selfValue doubleValue];
                            double otherDouble = [otherValue doubleValue];
                            BOOL closeEnough = BONDoublesCloseEnough(selfDouble, otherDouble);
                            if (!closeEnough) {
                                equal = NO;
                                break;
                            }
                        }
                    }
                    else if ([selfValue isKindOfClass:[UIFont class]] && [otherValue isKindOfClass:[UIFont class]]) {
                        UIFont *selfFont = selfValue;
                        UIFont *otherFont = otherValue;
                        BOOL closeEnough = [selfFont.fontName isEqualToString:otherFont.fontName] && [selfFont.familyName isEqualToString:otherFont.familyName] && BONDoublesCloseEnough(selfFont.pointSize, otherFont.pointSize);
                        if (!closeEnough) {
                            equal = NO;
                            break;
                        }
                    }
                    else {
                        equal = NO;
                        break;
                    }
                }
            }
        }
        else {
            equal = NO;
        }
    }
    else {
        equal = NO;
    }

    return equal;
}

+ (BOOL)bon_dictionary:(NSDictionary *)dictionary1 hasSameKeysAsDictionary:(NSDictionary *)dictionary2
{
    NSSet *keys1 = [NSSet setWithArray:dictionary1.allKeys];
    NSSet *keys2 = [NSSet setWithArray:dictionary2.allKeys];
    return (!(keys1 || keys2) || [keys1 isEqualToSet:keys2]);
}

@end
