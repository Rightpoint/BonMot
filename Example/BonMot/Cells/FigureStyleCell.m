//
//  FigureStyleCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "FigureStyleCell.h"

static NSString* const kFontNameEBGaramond = @"EBGaramond12-Regular";

@interface FigureStyleCell ()

@property (weak, nonatomic) IBOutlet UILabel *proportionalLiningLabel;
@property (weak, nonatomic) IBOutlet UILabel *proportionalOldstyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabularLiningLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabularOldstyleLabel;

@end

@implementation FigureStyleCell

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

    UIFont *ebGaramond = [UIFont fontWithName:kFontNameEBGaramond size:24.0f];

    BONChain *commonFont = BONChain.new.font(ebGaramond);

    self.proportionalLiningLabel.attributedText = commonFont.string(proportionalLiningString).figureSpacing(BONFigureSpacingProportional).figureCase(BONFigureCaseLining).attributedString;

    self.proportionalOldstyleLabel.attributedText = commonFont.string(proportionalOldstyleString).figureSpacing(BONFigureSpacingProportional).figureCase(BONFigureCaseOldstyle).attributedString;

    self.tabularLiningLabel.attributedText = commonFont.string(tabularLiningString).figureSpacing(BONFigureSpacingTabular).figureCase(BONFigureCaseLining).attributedString;

    self.tabularOldstyleLabel.attributedText = commonFont.string(tabularOldstyleString).figureSpacing(BONFigureSpacingTabular).figureCase(BONFigureCaseOldstyle).attributedString;
}

@end
