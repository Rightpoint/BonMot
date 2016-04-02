//
//  BaselineOffsetCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BaselineOffsetCell.h"

@interface BaselineOffsetCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation BaselineOffsetCell

+ (NSString *)title
{
    return @"Baseline Offset";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    BONChain *baseChain = BONChain.new.string(@"❤️");

    BONGeneric(NSMutableArray, BONChain *)*wave = [NSMutableArray array];

    for (NSUInteger i = 0; i < 50; i++) {
        CGFloat offset = 15.0 * sin((i / 20.0) * 7.0 * M_PI);
        [wave addObject:baseChain.baselineOffset(offset)];
    };

    self.label.attributedText = [BONChain joinChains:wave withSeparator:nil];
}

@end
