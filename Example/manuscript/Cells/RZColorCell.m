//
//  RZColorCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/24/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZColorCell.h"

#import <manuscript/RZChainLink.h>

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
    //    Maria Sharapova

    NSArray *strings = @[
                         @"I want to be different. If everyone is wearing ",
                         @" black, ",
                         @" I want to be wearing ",
                         @" red. ",
                         @"\nMaria Sharapova ",
                         ];

    RZChainLink *baseLineHeight = RZCursive.lineHeightMultiple(1.2f);

    RZChainLink *grayFont = baseLineHeight.fontNameAndSize(@"GillSans-Light", 20.0f).textColor([UIColor darkGrayColor]);

    RZChainLink *fancyFont = baseLineHeight.fontNameAndSize(@"SuperClarendon-Black", 20.0f);

    RZChainLink *blackBackground = fancyFont.textColor([UIColor whiteColor]).backgroundColor([UIColor blackColor]);

    RZChainLink *redBackground = fancyFont.textColor([UIColor whiteColor]).backgroundColor([self.class raizlabsRed]);
    RZChainLink *redFont = fancyFont.textColor([self.class raizlabsRed]);

    NSArray *chainLinks = @[
                            grayFont,
                            blackBackground,
                            grayFont,
                            redBackground,
                            redFont,
                            ];

    NSAssert(strings.count == chainLinks.count, @"wrong count");

    NSMutableArray *manuscriptsWithText = [NSMutableArray array];

    for ( NSUInteger i = 0; i < strings.count; i++ ) {
        NSString *string = strings[i];
        RZChainLink *link = chainLinks[i];
        RZChainLink *newLink = link.string(string);
        [manuscriptsWithText addObject:newLink.manuscript];
    }

    NSAssert(manuscriptsWithText.count == strings.count, @"wrong count");

    NSAttributedString *attributedString = [RZManuscript joinManuscripts:manuscriptsWithText withSeparator:nil];
    self.label.attributedText = attributedString;

    [self.label layoutIfNeeded];
}

@end
