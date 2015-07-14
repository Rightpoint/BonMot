//
//  ConcatenationCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "ConcatenationCell.h"

static const CGFloat kColorAlpha = 0.3f;
static const NSInteger kTracking = 200;

@interface ConcatenationCell ()

@property (weak, nonatomic) IBOutlet UILabel *centeredSmartTrackingLabel;
@property (weak, nonatomic) IBOutlet UILabel *appendedSmartTrackingLabel;

@end

@implementation ConcatenationCell

+ (NSString *)title
{
    return @"Concatenation";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    BONText *centeredSmartTracking = BONChain.new.string(@"CENTERED WITH TRACKING").adobeTracking(kTracking).backgroundColor([[UIColor redColor] colorWithAlphaComponent:kColorAlpha]).text;

    BONText *appended = BONChain.new.string(@"APPENDED").adobeTracking(kTracking).backgroundColor([[UIColor greenColor] colorWithAlphaComponent:kColorAlpha]).text;
    BONText *smartTracking = BONChain.new.string(@" SMART TRACKING").adobeTracking(kTracking).backgroundColor([[UIColor blueColor] colorWithAlphaComponent:kColorAlpha]).text;
    appended.nextText = smartTracking;

    self.centeredSmartTrackingLabel.attributedText = centeredSmartTracking.attributedString;
    self.appendedSmartTrackingLabel.attributedText = appended.attributedString;
}

@end
