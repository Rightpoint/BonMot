//
//  RZFigureStyleCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZFigureStyleCell.h"

#import <manuscript/RZChainLink.h>

static NSString* const kRZFontNameEBGaramond = @"EBGaramond12-Regular";

@interface RZFigureStyleCell ()

@property (weak, nonatomic) IBOutlet UILabel *proportionalLiningLabel;
@property (weak, nonatomic) IBOutlet UILabel *proportionalOldstyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabularLiningLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabularOldstyleLabel;

@end

@implementation RZFigureStyleCell

+ (NSString *)title
{
    return @"Figure Style";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    NSString *proportionalLiningString = self.proportionalLiningLabel.text;
    NSString *proportionalOldstyleString = self.proportionalOldstyleLabel.text;
    NSString *tabularLiningString = self.tabularLiningLabel.text;
    NSString *tabularOldstyleString = self.tabularOldstyleLabel.text;

    UIFont *ebGaramond = [UIFont fontWithName:kRZFontNameEBGaramond size:24.0f];

    RZChainLink *commonFont = RZCursive.font(ebGaramond);

    self.proportionalLiningLabel.attributedText = commonFont.string(proportionalLiningString).figureSpacing(RZFigureSpacingProportional).figureCase(RZFigureCaseLining).attributedString;

    self.proportionalOldstyleLabel.attributedText = commonFont.string(proportionalOldstyleString).figureSpacing(RZFigureSpacingProportional).figureCase(RZFigureCaseOldstyle).attributedString;

    self.tabularLiningLabel.attributedText = commonFont.string(tabularLiningString).figureSpacing(RZFigureSpacingTabular).figureCase(RZFigureCaseLining).attributedString;

    self.tabularOldstyleLabel.attributedText = commonFont.string(tabularOldstyleString).figureSpacing(RZFigureSpacingTabular).figureCase(RZFigureCaseOldstyle).attributedString;
}

@end
