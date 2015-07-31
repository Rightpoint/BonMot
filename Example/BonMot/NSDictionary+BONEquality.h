//
//  NSDictionary+BONEquality.h
//  BonMot
//
//  Created by Zev Eisenberg on 7/11/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

@import Foundation;

@import CoreGraphics.CGBase;

OBJC_EXTERN const CGFloat kBONCGFloatEpsilon;
OBJC_EXTERN BOOL BONCGFloatsCloseEnough(CGFloat float1, CGFloat float2);

@interface NSDictionary (BONEquality)

- (BOOL)bon_isCloseEnoughEqualToDictionary:(NSDictionary *)dictionary;

@end
