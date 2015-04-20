//
//  RZTrackingCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/19/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZTrackingCell.h"

#import <manuscript/RZManuscript.h>

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

    NSString *quote = @"Outside of a dog, a book is a man’s best friend. Inside of a dog, it’s too dark to read.";
    NSAttributedString *attributedString = RZManuscript.adobeTracking(300).string(quote).write;

    self.label.attributedText = attributedString;

    [self.label layoutIfNeeded]; // For auto-sizing cells
}

@end
