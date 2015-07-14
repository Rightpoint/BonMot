//
//  ColorCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/24/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
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

    NSArray *strings = @[
                         @"I want to be different. If everyone is wearing ",
                         @" black, ",
                         @" I want to be wearing ",
                         @" red. ",
                         @"\nMaria Sharapova ",
                         ];

    BONChain *baseLineHeight = BONChain.new.lineHeightMultiple(1.2f);

    BONChain *grayFont = baseLineHeight.fontNameAndSize(@"GillSans-Light", 20.0f).textColor([UIColor darkGrayColor]);

    BONChain *fancyFont = baseLineHeight.fontNameAndSize(@"SuperClarendon-Black", 20.0f);

    BONChain *blackBackground = fancyFont.textColor([UIColor whiteColor]).backgroundColor([UIColor blackColor]);

    BONChain *redBackground = fancyFont.textColor([UIColor whiteColor]).backgroundColor([self.class raizlabsRed]);
    BONChain *redFont = fancyFont.textColor([self.class raizlabsRed]);

    NSArray *chains = @[
                        grayFont,
                        blackBackground,
                        grayFont,
                        redBackground,
                        redFont,
                        ];

    NSAssert(strings.count == chains.count, @"wrong count");

    NSMutableArray *textsWithStrings = [NSMutableArray array];

    for ( NSUInteger i = 0; i < strings.count; i++ ) {
        NSString *string = strings[i];
        BONChain *chain = chains[i];
        BONChain *newChain = chain.string(string);
        [textsWithStrings addObject:newChain.text];
    }

    NSAssert(textsWithStrings.count == strings.count, @"wrong count");

    UIImage *tennisRacketImage = [UIImage imageNamed:@"Tennis Racket"];
    UIImage *tinted = [tennisRacketImage bon_tintedImageWithColor:[self.class raizlabsRed]];
    BONChain *tennisRacket = BONChain.new.image(tinted).baselineOffset(-4.0f);

    [textsWithStrings addObject:tennisRacket.text];

    NSAttributedString *attributedString = [BONText joinTexts:textsWithStrings withSeparator:nil];
    self.label.attributedText = attributedString;

    [self.label layoutIfNeeded];
}

@end
