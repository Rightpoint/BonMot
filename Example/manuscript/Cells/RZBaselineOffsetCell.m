//
//  RZBaselineOffsetCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZBaselineOffsetCell.h"

#import <manuscript/RZChainLink.h>

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

    RZChainLink *baseChainLink = RZCursive.string(@"❤️");

    NSMutableArray *wave = [NSMutableArray array];

    for ( NSUInteger i = 0; i < 50; i++ ) {
        CGFloat offset = 15.0f * sin((i / 20.0f) * 7.0f * M_PI);
        [wave addObject:baseChainLink.baselineOffset(offset).manuscript];
    };

    self.label.attributedText = [RZManuscript joinManuscripts:wave withSeparator:nil];
}

@end
