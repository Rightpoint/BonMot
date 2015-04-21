//
//  RZInlineImagesCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZInlineImagesCell.h"

#import <manuscript/RZManuscript.h>

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

    RZManuscript *imageBaselineManuscript = RZManuscript.baselineOffset(-8.0f);

    RZManuscript *beeManuscript = imageBaselineManuscript.image(bee);
    RZManuscript *knotManuscript = imageBaselineManuscript.image(knot);
    RZManuscript *oarManuscript = imageBaselineManuscript.image(oar);

    RZManuscript *twoManuscript = RZManuscript.string(@"2").fontNameAndSize(@"HelveticaNeue-Bold", 24.0f);

    // To be or not to be
    NSAttributedString *rebus = [RZManuscript joinManuscripts:@[
                                                                twoManuscript,
                                                                beeManuscript,
                                                                oarManuscript,
                                                                knotManuscript,
                                                                twoManuscript,
                                                                beeManuscript,
                                                                ]
                                                withSeparator:RZManuscript.string(@" ")];
    self.label.attributedText = rebus;
}

@end
