//
//  RZTrackingCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/19/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZTrackingCell.h"

#import <manuscript/RZChainLink.h>

@interface RZTrackingCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RZTrackingCell

+ (NSString *)title
{
    return @"Tracking";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    NSString *quote = @"Adults are always asking kids what they want to be when they grow up because they are looking for ideas.\n—Paula Poundstone";
    NSAttributedString *attributedString = RZCursive.adobeTracking(300).fontNameAndSize(@"Avenir-Book", 18.0f).string(quote).attributedString;

    self.label.attributedText = attributedString;

    [self.label layoutIfNeeded]; // For auto-sizing cells
}

@end
