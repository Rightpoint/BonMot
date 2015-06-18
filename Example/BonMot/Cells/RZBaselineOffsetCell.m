//
//  RZBaselineOffsetCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZBaselineOffsetCell.h"

#import <BonMot/BONChainLink.h>

@interface RZBaselineOffsetCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RZBaselineOffsetCell

+ (NSString *)title
{
    return @"Baseline Offset";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    BONChainLink *baseChainLink = RZCursive.string(@"❤️");

    NSMutableArray *wave = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 50; i++ ) {
        CGFloat offset = 15.0f * sin((i / 20.0f) * 7.0f * M_PI);
        [wave addObject:baseChainLink.baselineOffset(offset).textConfiguration];
    };

    self.label.attributedText = [BONTextConfiguration joinTextConfigurations:wave withSeparator:nil];
}

@end
