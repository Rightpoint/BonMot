//
//  RZLineHeightCell.m
//  manuscript
//
//  Created by Zev Eisenberg on 4/20/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "RZLineHeightCell.h"

#import <manuscript/RZChainLink.h>
@interface RZLineHeightCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RZLineHeightCell

+ (NSString *)title
{
    return @"Line Height";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    NSString *quote = @"Outside of a dog, a book is a man’s best friend. Inside of a dog, it’s too dark to read.";
    NSAttributedString *attributedString = RZCursive.lineHeightMultiple(1.8f).string(quote).attributedString;

    self.label.attributedText = attributedString;

    [self.label layoutIfNeeded]; // For auto-sizing cells
}

@end
