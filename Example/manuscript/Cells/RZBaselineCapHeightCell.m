//
//  RZBaselineCapHeightCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZBaselineCapHeightCell.h"

#import <manuscript/RZManuscript.h>

static NSString* const kRZFontNameEBGaramond = @"EBGaramond12-Regular";

@interface RZBaselineCapHeightCell ()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *capHeightNumberLabels;

@property (weak, nonatomic) IBOutlet UILabel *labelAlignedToCapTops;
@property (weak, nonatomic) IBOutlet UILabel *labelAlignedToXHeight;

@property (weak, nonatomic) IBOutlet UILabel *numberCapHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberXHeightLabel;
@property (weak, nonatomic) IBOutlet UIView *capHeightBaselineHairline;
@property (weak, nonatomic) IBOutlet UIView *xHeightBaselineHairline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberCapHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberCapHeightHairlineConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberXHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberXHeightHairlineConstraint;

@end

@implementation RZBaselineCapHeightCell

+ (NSString *)title
{
    return @"Baseline, Cap Height, & X-Height";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    NSAttributedString *numberString = RZManuscript.fontNameAndSize(kRZFontNameEBGaramond, 100.0f).figureCase(RZFigureCaseOldstyle).string(@"160").write;

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

    // ******************
    // * Cap height
    // ******************

    // Number Label

    UIFont *capHeightNumberFont = self.numberCapHeightLabel.font;
    // Distance from baseline to top of label
    CGFloat capHeightNumberAscender = capHeightNumberFont.ascender;

    // Distance from baseline to top of typical capital letter.
    // Should be less than ascender.
    CGFloat numberCapHeight = capHeightNumberFont.capHeight;

    // Distance from top of label to top of typical capital letter (or number, in this case)
    CGFloat topOfNumberLabelToTopOfCaps = capHeightNumberAscender - numberCapHeight;

    // Accessory Label

    UIFont *capHeightAccessoryFont = self.labelAlignedToCapTops.font;

    // Distance from baseline to top of label
    CGFloat capHeightAccessoryDescender = capHeightAccessoryFont.ascender;

    // Distance from baseline to top of typical capital letter.
    // Should be less than ascender.
    CGFloat accessoryCapHeight = capHeightAccessoryFont.capHeight;

    // Distance from top of label to top of typical capital letter (or number, in this case)
    CGFloat topOfAccessoryLabelToTopOfCaps = capHeightAccessoryDescender - accessoryCapHeight;

    self.numberCapHeightConstraint.constant = topOfNumberLabelToTopOfCaps - topOfAccessoryLabelToTopOfCaps;
    self.numberCapHeightHairlineConstraint.constant = -topOfAccessoryLabelToTopOfCaps;

    // ******************
    // * X-height
    // ******************

    // Number Label

    UIFont *xHeightNumberFont = self.numberXHeightLabel.font;
    // Distance from baseline to top of label
    CGFloat xHeightNumberLabelAscender = xHeightNumberFont.ascender;

    // Distance from baseline to x-height.
    CGFloat numberXHeight = xHeightNumberFont.xHeight;

    // Distance from top of label to x-height
    CGFloat topOfNumberLabelToXHeight = xHeightNumberLabelAscender - numberXHeight;

    // Accessory Label

    UIFont *xHeightAccessoryFont = self.labelAlignedToXHeight.font;

    // Distance from baseline to top of label
    CGFloat xHeightAccessoryAscender = xHeightAccessoryFont.ascender;

    // Distance from baseline to x-height.
    CGFloat accessoryXHeight = xHeightAccessoryFont.xHeight;

    // Distance from top of label to x-height.
    CGFloat topOfAccessoryLabelToXHeight = xHeightAccessoryAscender - accessoryXHeight;

    self.numberXHeightConstraint.constant = topOfNumberLabelToXHeight - topOfAccessoryLabelToXHeight;
    self.numberXHeightHairlineConstraint.constant = -topOfAccessoryLabelToXHeight;

}


@end
