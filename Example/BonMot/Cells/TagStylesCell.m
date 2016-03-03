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
                              .tagStyles(@[ BONTagMake(@"bold", boldChain), BONTagMake(@"italic", italicChain) ])
                              .string(@"<bold>This text is wrapped in a \\<bold> tag.</bold>\n<italic>This text is wrapped in an \\<italic> tag.</italic>");

    self.label.attributedText = baseChain.attributedString;

    [self.label layoutIfNeeded]; // For auto-sizing cells
}

@end
