//
//  DashedHairlineView.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/5/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "DashedHairlineView.h"

#define RAIZLABS_RED [UIColor colorWithRed:0.927 green:0.352 blue:0.303 alpha:1.0]

@implementation DashedHairlineView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    const CGFloat dash[2] = {5.0, 5.0}; // pattern 6 times “solid”, 5 times “empty”
    CGContextSetLineDash(ctx, 0, dash, 2);

    CGContextSetLineWidth(ctx, CGRectGetHeight(self.bounds));
    CGContextMoveToPoint(ctx, 0.0, CGRectGetHeight(self.bounds) / 2);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2);
    CGContextSetStrokeColorWithColor(ctx, RAIZLABS_RED.CGColor);
    CGContextStrokePath(ctx);
}

@end
