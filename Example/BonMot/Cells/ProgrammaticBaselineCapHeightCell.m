//
//  ProgrammaticBaselineCapHeightCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "ProgrammaticBaselineCapHeightCell.h"

static NSString* const kFontNameEBGaramond = @"EBGaramond12-Regular";

@interface ProgrammaticBaselineCapHeightCell ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *capHeightNumberLabels;

@property (weak, nonatomic) IBOutlet UILabel *numberCapHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberXHeightLabel;

@property (weak, nonatomic) IBOutlet UILabel *textCapHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *textXHeightLabel;

@property (weak, nonatomic) IBOutlet UIView *capHeightHairline;
@property (weak, nonatomic) IBOutlet UIView *xHeightHairline;

@property (weak, nonatomic) IBOutlet UIView *capHeightBaselineHairline;
@property (weak, nonatomic) IBOutlet UIView *xHeightBaselineHairline;

@end

@implementation ProgrammaticBaselineCapHeightCell

+ (NSString *)title
{
    return @"Programmatic Cap Height & X-Height";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    NSAttributedString *numberString = BONChain.new.fontNameAndSize(kFontNameEBGaramond, 100.0f).figureCase(BONFigureCaseOldstyle).string(@"167").attributedString;

    for ( UILabel *label in self.capHeightNumberLabels ) {
        label.attributedText = numberString;
    }

    // Constrain labels to each other
    [BONTextAlignmentConstraint constraintWithItem:self.numberCapHeightLabel
                                         attribute:BONConstraintAttributeCapHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.textCapHeightLabel
                                         attribute:BONConstraintAttributeCapHeight].active = YES;

    [BONTextAlignmentConstraint constraintWithItem:self.numberXHeightLabel
                                         attribute:BONConstraintAttributeXHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.textXHeightLabel
                                         attribute:BONConstraintAttributeXHeight].active = YES;

    // Constrain hairlines to labels
    [BONTextAlignmentConstraint constraintWithItem:self.capHeightHairline
                                         attribute:BONConstraintAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.numberCapHeightLabel
                                         attribute:BONConstraintAttributeCapHeight].active = YES;

    [BONTextAlignmentConstraint constraintWithItem:self.xHeightHairline
                                         attribute:BONConstraintAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.numberXHeightLabel
                                         attribute:BONConstraintAttributeXHeight].active = YES;

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
