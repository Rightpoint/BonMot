//
//  InlineImagesCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "InlineImagesCell.h"

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
    [wholeString appendLink:twoChain];
    [wholeString appendLink:beeChain separator:@" "];
    [wholeString appendLink:oarChain separator:@" "];
    [wholeString appendLink:knotChain separator:@" "];

    // you can also append the space and the chain separately if you prefer
    [wholeString appendLink:spaceChain];
    [wholeString appendLink:twoChain];

    [wholeString appendLink:beeChain separator:@" "];

    self.label.attributedText = wholeString.attributedString;

    NSLog(@"Look at the bottom of %@ to see the code that led to this being printed:", @(__FILE__).lastPathComponent);
    NSLog(@"%@", wholeString.text);
}

@end
