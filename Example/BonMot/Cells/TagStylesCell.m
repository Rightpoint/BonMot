//
//  TagStylesCell.m
//  BonMot
//
//  Created by Nora Trapp on 3/3/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

#import "TagStylesCell.h"

@interface TagStylesCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TagStylesCell

+ (NSString *)title
{
    return @"Tag Styles";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    BONChain *boldChain = BONChain.new.fontNameAndSize(@"Baskerville-Bold", 15);
    BONChain *italicChain = BONChain.new.fontNameAndSize(@"Baskerville-Italic", 15);

    BONChain *baseChain = BONChain.new.fontNameAndSize(@"Baskerville", 17)
                              .tagStyles(@{ @"bold" : boldChain,
                                            @"italic" : italicChain })
                              .string(@"<bold>This text</bold> contains a \\<bold> tag.\n<italic>This text</italic> contains an \\<italic> tag.");

    self.label.attributedText = baseChain.attributedString;

    [self.label layoutIfNeeded]; // For auto-sizing cells
}

@end
