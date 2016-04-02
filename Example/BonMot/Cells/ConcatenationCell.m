//
//  ConcatenationCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "ConcatenationCell.h"

static const CGFloat kColorAlpha = 0.3;
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

    BONChain *centeredSmartTracking = BONChain.new.string(@"CENTERED WITH TRACKING").adobeTracking(kTracking).backgroundColor([[UIColor redColor] colorWithAlphaComponent:kColorAlpha]);

    BONChain *appended = BONChain.new.string(@"APPENDED").adobeTracking(kTracking).backgroundColor([[UIColor greenColor] colorWithAlphaComponent:kColorAlpha]);
    BONChain *smartTracking = BONChain.new.string(@" SMART TRACKING").adobeTracking(kTracking).backgroundColor([[UIColor blueColor] colorWithAlphaComponent:kColorAlpha]);
    [appended appendChain:smartTracking];

    self.centeredSmartTrackingLabel.attributedText = centeredSmartTracking.attributedString;
    self.appendedSmartTrackingLabel.attributedText = appended.attributedString;
}

@end
