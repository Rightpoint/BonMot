//
//  RZConcatenationCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZConcatenationCell.h"

#import <BonMot/BONChain.h>

static const CGFloat kRZColorAlpha = 0.3f;
static const NSInteger kRZTracking = 200;

@interface RZConcatenationCell ()

@property (weak, nonatomic) IBOutlet UILabel *centeredSmartTrackingLabel;
@property (weak, nonatomic) IBOutlet UILabel *appendedSmartTrackingLabel;

@end

@implementation RZConcatenationCell

+ (NSString *)title
{
    return @"Concatenation";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    BONText *centeredSmartTracking = BONChain.new.string(@"CENTERED WITH TRACKING").adobeTracking(kRZTracking).backgroundColor([[UIColor redColor] colorWithAlphaComponent:kRZColorAlpha]).text;

    BONText *appended = BONChain.new.string(@"APPENDED").adobeTracking(kRZTracking).backgroundColor([[UIColor greenColor] colorWithAlphaComponent:kRZColorAlpha]).text;
    BONText *smartTracking = BONChain.new.string(@" SMART TRACKING").adobeTracking(kRZTracking).backgroundColor([[UIColor blueColor] colorWithAlphaComponent:kRZColorAlpha]).text;
    appended.nextText = smartTracking;

    self.centeredSmartTrackingLabel.attributedText = centeredSmartTracking.attributedString;
    self.appendedSmartTrackingLabel.attributedText = appended.attributedString;
}

@end
