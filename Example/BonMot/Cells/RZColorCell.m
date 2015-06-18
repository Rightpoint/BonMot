//
//  RZColorCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/24/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZColorCell.h"

#import <BonMot/BONChainLink.h>

// Utilities
#import <BonMot/UIImage+BonMotUtilities.h>

@interface RZColorCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RZColorCell

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

    BONChainLink *baseLineHeight = RZCursive.lineHeightMultiple(1.2f);

    BONChainLink *grayFont = baseLineHeight.fontNameAndSize(@"GillSans-Light", 20.0f).textColor([UIColor darkGrayColor]);

    BONChainLink *fancyFont = baseLineHeight.fontNameAndSize(@"SuperClarendon-Black", 20.0f);

    BONChainLink *blackBackground = fancyFont.textColor([UIColor whiteColor]).backgroundColor([UIColor blackColor]);

    BONChainLink *redBackground = fancyFont.textColor([UIColor whiteColor]).backgroundColor([self.class raizlabsRed]);
    BONChainLink *redFont = fancyFont.textColor([self.class raizlabsRed]);

    NSArray *chainLinks = @[
                            grayFont,
                            blackBackground,
                            grayFont,
                            redBackground,
                            redFont,
                            ];

    NSAssert(strings.count == chainLinks.count, @"wrong count");

    NSMutableArray *textConfigurationsWithText = [NSMutableArray array];

    for ( NSUInteger i = 0; i < strings.count; i++ ) {
        NSString *string = strings[i];
        BONChainLink *link = chainLinks[i];
        BONChainLink *newLink = link.string(string);
        [textConfigurationsWithText addObject:newLink.textConfiguration];
    }

    NSAssert(textConfigurationsWithText.count == strings.count, @"wrong count");

    UIImage *tennisRacketImage = [UIImage imageNamed:@"Tennis Racket"];
    UIImage *tinted = [tennisRacketImage rz_tintedImageWithColor:[self.class raizlabsRed]];
    BONChainLink *tennisRacket = RZCursive.image(tinted).baselineOffset(-4.0f);

    [textConfigurationsWithText addObject:tennisRacket.textConfiguration];

    NSAttributedString *attributedString = [BONTextConfiguration joinTextConfigurations:textConfigurationsWithText withSeparator:nil];
    self.label.attributedText = attributedString;

    [self.label layoutIfNeeded];
}

@end
