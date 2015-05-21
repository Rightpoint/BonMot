//
//  RZConcatenationCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZConcatenationCell.h"

#import <manuscript/RZChainLink.h>

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

    RZManuscript *centeredSmartTracking = RZCursive.string(@"CENTERED WITH TRACKING").adobeTracking(kRZTracking).backgroundColor([[UIColor redColor] colorWithAlphaComponent:kRZColorAlpha]).manuscript;

    RZManuscript *appended = RZCursive.string(@"APPENDED").adobeTracking(kRZTracking).backgroundColor([[UIColor greenColor] colorWithAlphaComponent:kRZColorAlpha]).manuscript;
    RZManuscript *smartTracking = RZCursive.string(@" SMART TRACKING").adobeTracking(kRZTracking).backgroundColor([[UIColor blueColor] colorWithAlphaComponent:kRZColorAlpha]).manuscript;
    appended.nextManuscript = smartTracking;

    self.centeredSmartTrackingLabel.attributedText = centeredSmartTracking.attributedString;
    self.appendedSmartTrackingLabel.attributedText = appended.attributedString;
}

@end
