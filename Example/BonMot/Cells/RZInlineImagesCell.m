//
//  RZInlineImagesCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZInlineImagesCell.h"

#import <BonMot/BONChainLink.h>

@interface RZInlineImagesCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RZInlineImagesCell

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

    BONChainLink *imageBaselineChainLink = RZCursive.baselineOffset(-8.0f);

    BONChainLink *beeChainLink = imageBaselineChainLink.image(bee);
    BONChainLink *knotChainLink = imageBaselineChainLink.image(knot);
    BONChainLink *oarChainLink = imageBaselineChainLink.image(oar);

    BONChainLink *twoChainLink = RZCursive.string(@"2").fontNameAndSize(@"HelveticaNeue-Bold", 24.0f);

    BONChainLink *spaceChainLink = RZCursive.string(@" ");

    BONChainLink *wholeString = RZCursive;
    wholeString
    .append(twoChainLink)
    .appendWithSeparator(@" ", beeChainLink)
    .appendWithSeparator(@" ", oarChainLink)
    .appendWithSeparator(@" ", knotChainLink)
    // you can also append the space and the chain link separately if you prefer
    .append(spaceChainLink)
    .append(twoChainLink)
    .appendWithSeparator(@" ", beeChainLink);

    self.label.attributedText = wholeString.attributedString;

    NSLog(@"debug string:%@", wholeString.text.debugDescription);
}

@end
