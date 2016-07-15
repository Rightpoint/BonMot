//
//  SpecialCharactersCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 7/17/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "SpecialCharactersCell.h"

@interface SpecialCharactersCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SpecialCharactersCell

+ (NSString *)title
{
    return @"Special Characters";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    BONGeneric(NSArray, NSString *)*imageNames = @[
        @"barn",
        @"bee",
        @"bug",
        @"circuit",
        @"cut",
        @"discount",
        @"gift",
        @"pin",
        @"robot",
    ];

    NSString *text = @"This string is separated by images and no-break spaces.";
    BONGeneric(NSArray, NSString *)*words = [text componentsSeparatedByString:@" "];

    NSAssert(imageNames.count == words.count, @"We must have the same number of words as images");

    BONChain *baseTextChain = BONChain.new.color([UIColor darkGrayColor]);
    BONChain *baseImageChain = BONChain.new.baselineOffset(-10.0);
    BONGeneric(NSMutableArray, BONChain *)*chains = [NSMutableArray array];

    for (NSUInteger theIndex = 0; theIndex < imageNames.count; theIndex++) {
        UIImage *image = [UIImage imageNamed:imageNames[theIndex]];
        NSAssert(image, @"Image must not be nil");
        BONChain *chunk = baseImageChain.image(image);
        BONChain *noBreakSpace = BONChain.new.string(BONSpecial.noBreakSpace);
        [chunk appendLink:baseTextChain.string(words[theIndex]) separatorTextable:noBreakSpace];

        [chains addObject:chunk];
    }

    NSAttributedString *finalString = [BONText joinTextables:chains
                                               withSeparator:BONChain.new.string(BONSpecial.emSpace)];

    self.label.attributedText = finalString;

    [self.label layoutIfNeeded]; // For auto-sizing cells
}

@end
