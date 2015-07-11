//
//  NSDictionary+BONEquality.h
//  BonMot
//
//  Created by Zev Eisenberg on 7/11/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

@import Foundation;

@interface NSDictionary (BONEquality)

- (BOOL)bon_isCloseEnoughEqualToDictionary:(NSDictionary *)dictionary;

@end
