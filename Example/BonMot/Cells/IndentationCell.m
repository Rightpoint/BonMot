//
//  IndentationCell.m
//  BonMot
//
//  Created by Zev Eisenberg on 8/15/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "IndentationCell.h"

@interface IndentationCell ()

@property (weak, nonatomic) IBOutlet UILabel *imagePrefixLabel;
@property (weak, nonatomic) IBOutlet UILabel *stringPrefixLabel;

@end

@implementation IndentationCell

+ (NSString *)title
{
    return @"Indentation";
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    // First Quote
    NSString *quote = @"“It’s OK to ask for help. When doing a final exam, all the work must be yours, but in engineering, the point is to get the job done, and people are happy to help. Corollaries: You should be generous with credit, and you should be happy to help others.”";
    NSString *attribution = [NSString stringWithFormat:@"%@%@Radia Perlman", BONSpecial.lineSeparator, BONSpecial.emDash];
    UIImage *image = [UIImage imageNamed:@"robot"];
    BONChain *firstBaseTextChain = BONChain.new.fontNameAndSize(@"AvenirNextCondensed-Medium", 18.0);
    BONChain *imageChain = firstBaseTextChain.image(image).indentSpacer(4.0).baselineOffset(-6.0);

    [imageChain appendLink:firstBaseTextChain.string(quote)];
    [imageChain appendLink:firstBaseTextChain.string(attribution)];

    NSAttributedString *imageAttributedString = imageChain.attributedString;

    self.imagePrefixLabel.attributedText = imageAttributedString;

    // Second Quote
    NSString *secondQuote = @"You can also use strings (including emoji) for bullets as well, and they will still properly indent the appended text by the right amount.";
    BONChain *secondBaseTextChain = BONChain.new.fontNameAndSize(@"AvenirNextCondensed-Regular", 18.0);
    BONChain *secondChain = secondBaseTextChain.string(@"🍑 →").indentSpacer(4.0).color([UIColor orangeColor]);
    [secondChain appendLink:secondBaseTextChain.string(secondQuote).color([UIColor darkGrayColor])];

    NSAttributedString *textAttributedString = secondChain.attributedString;
    self.stringPrefixLabel.attributedText = textAttributedString;

    [self.imagePrefixLabel layoutIfNeeded]; // For auto-sizing cells
    [self.stringPrefixLabel layoutIfNeeded];
}

@end
