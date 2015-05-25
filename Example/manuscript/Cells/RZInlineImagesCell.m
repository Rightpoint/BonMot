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

    // To be or not to be
    NSAttributedString *rebus = [RZManuscript joinManuscripts:@[
                                                                twoChainLink.manuscript,
                                                                beeChainLink.manuscript,
                                                                oarChainLink.manuscript,
                                                                knotChainLink.manuscript,
                                                                twoChainLink.manuscript,
                                                                beeChainLink.manuscript,
                                                                ]
                                                withSeparator:RZCursive.string(@" ").manuscript];

    self.label.attributedText = rebus;

    // TODO: replace this with concise appending DSL syntax

    twoChainLink.manuscript.nextManuscript = beeChainLink.manuscript.copy;
    twoChainLink.manuscript.nextManuscript.nextManuscript = oarChainLink.manuscript.copy;
    twoChainLink.manuscript.nextManuscript.nextManuscript.nextManuscript = knotChainLink.manuscript.copy;
    twoChainLink.manuscript.nextManuscript.nextManuscript.nextManuscript.nextManuscript = twoChainLink.manuscript.copy;
    twoChainLink.manuscript.nextManuscript.nextManuscript.nextManuscript.nextManuscript.nextManuscript = beeChainLink.manuscript.copy;

    NSLog(@"debug string:%@", twoChainLink.manuscript.debugDescription);
}

@end
