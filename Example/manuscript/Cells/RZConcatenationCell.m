//
//  RZConcatenationCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZConcatenationCell.h"

#import <manuscript/RZChainLink.h>

@interface RZConcatenationCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RZConcatenationCell

+ (NSString *)title
{
    return @"Concatenation";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    
}

@end
