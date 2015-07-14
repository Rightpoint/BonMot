//
//  RZBaselineCapHeightCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZBaselineCapHeightCell.h"

#import <BonMot/BONChain.h>
static NSString* const kRZFontNameEBGaramond = @"EBGaramond12-Regular";

@interface RZBaselineCapHeightCell ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *capHeightNumberLabels;

@property (weak, nonatomic) IBOutlet UILabel *numberCapHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberXHeightLabel;
@property (weak, nonatomic) IBOutlet UIView *capHeightBaselineHairline;
@property (weak, nonatomic) IBOutlet UIView *xHeightBaselineHairline;

@end

@implementation RZBaselineCapHeightCell

+ (NSString *)title
{
    return @"Baseline, Cap Height, & X-Height";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    NSAttributedString *numberString = BONChain.new.fontNameAndSize(kRZFontNameEBGaramond, 100.0f).figureCase(RZFigureCaseOldstyle).string(@"167").attributedString;

    for ( UILabel *label in self.capHeightNumberLabels ) {
        label.attributedText = numberString;
    }

    [NSLayoutConstraint constraintWithItem:self.numberCapHeightLabel
                                 attribute:NSLayoutAttributeBaseline
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.capHeightBaselineHairline
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:0.0f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.numberXHeightLabel
                                 attribute:NSLayoutAttributeBaseline
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.xHeightBaselineHairline
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:0.0f].active = YES;
}


@end
