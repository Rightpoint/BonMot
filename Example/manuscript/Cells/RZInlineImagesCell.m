//
//  RZInlineImagesCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZInlineImagesCell.h"

#import <manuscript/RZChainLink.h>

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

    RZChainLink *imageBaselineChainLink = RZCursive.baselineOffset(-8.0f);

    RZChainLink *beeChainLink = imageBaselineChainLink.image(bee);
    RZChainLink *knotChainLink = imageBaselineChainLink.image(knot);
    RZChainLink *oarChainLink = imageBaselineChainLink.image(oar);

    RZChainLink *twoChainLink = RZCursive.string(@"2").fontNameAndSize(@"HelveticaNeue-Bold", 24.0f);

    RZChainLink *space = RZCursive.string(@" ");

    twoChainLink
    .append(space)
    .append(beeChainLink)
    .append(space)
    .append(oarChainLink)
    .append(space)
    .append(knotChainLink)
    .append(space)
    .append(twoChainLink)
    .append(space)
    .append(beeChainLink);

    self.label.attributedText = twoChainLink.attributedString;

    NSLog(@"debug string:%@", twoChainLink.manuscript.debugDescription);
}

@end
