//
//  ColorCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/24/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "ColorCell.h"

@interface ColorCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ColorCell

+ (NSString *)title
{
    return @"Color";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Quote to replicate:
    //    I want to be different. If everyone is wearing black, I want to be wearing red.
    //    Maria Sharapova [Tinted Tennis Racket Image]

    BONGeneric(NSArray, NSString *)*strings = @[
        @"I want to be different. If everyone is wearing ",
        @" black, ",
        @" I want to be wearing ",
        @" red. ",
        @"\nMaria Sharapova ",
    ];

    BONChain *baseLineHeight = BONChain.new.lineHeightMultiple(1.2);

    BONChain *grayFont = baseLineHeight.fontNameAndSize(@"GillSans-Light", 20.0).color([UIColor darkGrayColor]);

    BONChain *fancyFont = baseLineHeight.fontNameAndSize(@"SuperClarendon-Black", 20.0);

    BONChain *blackBackground = fancyFont.color([UIColor whiteColor]).backgroundColor([UIColor blackColor]);

    BONChain *redBackground = fancyFont.color([UIColor whiteColor]).backgroundColor([self.class raizlabsRed]);
    BONChain *redFont = fancyFont.color([self.class raizlabsRed]);

    BONGeneric(NSArray, BONChain *)*chains = @[
        grayFont,
        blackBackground,
        grayFont,
        redBackground,
        redFont,
    ];

    NSAssert(strings.count == chains.count, @"wrong count");

    BONGeneric(NSMutableArray, BONChain *)*chainsWithStrings = [NSMutableArray array];

    for (NSUInteger i = 0; i < strings.count; i++) {
        NSString *string = strings[i];
        BONChain *chain = chains[i];
        BONChain *newChain = chain.string(string);
        [chainsWithStrings addObject:newChain];
    }

    NSAssert(chainsWithStrings.count == strings.count, @"wrong count");

    UIImage *tennisRacketImage = [UIImage imageNamed:@"Tennis Racket"];
    UIImage *tinted = [tennisRacketImage bon_tintedImageWithColor:[self.class raizlabsRed]];
    BONChain *tennisRacket = BONChain.new.image(tinted).baselineOffset(-4.0);

    [chainsWithStrings addObject:tennisRacket];

    NSAttributedString *attributedString = [BONText joinTextables:chainsWithStrings withSeparator:nil];
    self.label.attributedText = attributedString;

    [self.label layoutIfNeeded];
}

@end
