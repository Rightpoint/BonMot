//
//  InlineImagesCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "InlineImagesCell.h"

#import <BonMot/BONChain.h>

@interface InlineImagesCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation InlineImagesCell

+ (NSString *)title
{
    return @"Inline Images";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIImage *bee = [UIImage imageNamed:@"bee"];
    UIImage *knot = [UIImage imageNamed:@"knot"];
    UIImage *oar = [UIImage imageNamed:@"oar"];

    BONChain *imageBaselineChain = BONChain.new.baselineOffset(-8.0f);

    BONChain *beeChain = imageBaselineChain.image(bee);
    BONChain *knotChain = imageBaselineChain.image(knot);
    BONChain *oarChain = imageBaselineChain.image(oar);

    BONChain *twoChain = BONChain.new.string(@"2").fontNameAndSize(@"HelveticaNeue-Bold", 24.0f);

    BONChain *spaceChain = BONChain.new.string(@" ");

    BONChain *wholeString = BONChain.new;
    wholeString
    .append(twoChain)
    .appendWithSeparator(@" ", beeChain)
    .appendWithSeparator(@" ", oarChain)
    .appendWithSeparator(@" ", knotChain)
    // you can also append the space and the chain separately if you prefer
    .append(spaceChain)
    .append(twoChain)
    .appendWithSeparator(@" ", beeChain);

    self.label.attributedText = wholeString.attributedString;

    NSLog(@"debug string:%@", wholeString.text.debugDescription);
}

@end
