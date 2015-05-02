//
//  RZAbstractCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZAbstractCell.h"

@implementation RZAbstractCell

+ (NSString *)title
{
    NSAssert(NO, @"Subclasses must override this method.");
    return nil;
}

+ (NSString *)reuseIdentifier
{
    return [NSString stringWithFormat:@"com.raizlabs.reuseIdentifier.%@", NSStringFromClass(self)];
}

- (NSString *)reuseIdentifier
{
    return self.class.reuseIdentifier;
}

+ (UIColor *)raizlabsRed
{
    return [UIColor colorWithRed:0.927f
                           green:0.352f
                            blue:0.303f
                           alpha:1.0f];
}

@end
