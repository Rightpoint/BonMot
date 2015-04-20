//
//  RZFigureStyleCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZFigureStyleCell.h"

#import <manuscript/RZManuscript.h>

@interface RZFigureStyleCell ()

@property (weak, nonatomic) IBOutlet UILabel *proportionalLiningLabel;
@property (weak, nonatomic) IBOutlet UILabel *proportionalOldstyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabularLiningLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabularOldstyleLabel;

@end

@implementation RZFigureStyleCell

+ (NSString *)title
{
    return @"Figure Style";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    
}

@end
