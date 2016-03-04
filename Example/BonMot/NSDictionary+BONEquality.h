//
//  NSDictionary+BONEquality.h
//  BonMot
//
//  Created by Zev Eisenberg on 7/11/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

@import Foundation;

#import "BONCompatibility.h"

@import CoreGraphics.CGBase;

OBJC_EXTERN const CGFloat kBONCGFloatEpsilon;
OBJC_EXTERN BOOL BONCGFloatsCloseEnough(CGFloat float1, CGFloat float2);

// clang-format off
@interface BONGenericDict (BONEquality)

- (BOOL)bon_isCloseEnoughEqualToDictionary:(BONNullable BONGenericDict *)dictionary;

@end
// clang-format on
