//
//  BONIndentSpacerTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 8/15/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;

@interface BONIndentSpacerTestCase : BONBaseTestCase

@end

@implementation BONIndentSpacerTestCase

- (void)testIndentingWithImages
{
    NSString *quote = [NSString stringWithFormat:@"“It’s OK to ask for help. When doing a final exam, all the work must be yours, but in engineering, the point is to get the job done, and people are happy to help. Corollaries: You should be generous with credit, and you should be happy to help others.”%@%@Radia Perlman.", BONSpecial.lineSeparator, BONSpecial.emDash];
    UIImage *image = [UIImage imageNamed:@"robot" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    BONChain *baseTextChain = BONChain.new.fontNameAndSize(@"AvenirNextCondensed-Medium", 18.0f);
    BONChain *imageChain = baseTextChain.image(image).indentSpacer(4.0f).baselineOffset(-6.0f);

    [imageChain appendLink:baseTextChain.string(quote)];

    NSAttributedString *attributedString = imageChain.attributedString;

    NSString *controlString = [NSString stringWithFormat:@"%@\t“It’s OK to ask for help. When doing a final exam, all the work must be yours, but in engineering, the point is to get the job done, and people are happy to help. Corollaries: You should be generous with credit, and you should be happy to help others.”%@%@Radia Perlman.", BONSpecial.objectReplacementCharacter, BONSpecial.lineSeparator, BONSpecial.emDash];
    XCTAssertEqualObjects(attributedString.string, controlString);
}

- (void)testIndentingWithText
{
    NSString *secondQuote = @"You can also use strings (including emoji) for bullets as well, and they will still properly indent the appended text by the right amount.";
    BONChain *baseTextChain = BONChain.new.fontNameAndSize(@"AvenirNextCondensed-Regular", 18.0f);
    BONChain *secondChain = baseTextChain.string(@"🍑 →").indentSpacer(4.0f).textColor([UIColor orangeColor]);
    [secondChain appendLink:baseTextChain.string(secondQuote).textColor([UIColor darkGrayColor])];

    NSAttributedString *attributedString = secondChain.attributedString;

    XCTAssertEqualObjects(attributedString.string, @"🍑 →\tYou can also use strings (including emoji) for bullets as well, and they will still properly indent the appended text by the right amount.");
}

- (void)testMultipleConcatenationIndentation
{
    NSString *string1 = [NSString stringWithFormat:@"string1"];
    NSString *string2 = [NSString stringWithFormat:@"string2"];
    UIImage *image = [UIImage imageNamed:@"robot" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    BONChain *firstBaseTextChain = BONChain.new.fontNameAndSize(@"AvenirNextCondensed-Medium", 18.0f);
    BONChain *imageChain = firstBaseTextChain.copy;
    [imageChain appendLink:firstBaseTextChain.image(image).indentSpacer(4.0f).baselineOffset(-6.0f)];
    [imageChain appendLink:firstBaseTextChain.string(string1)];
    [imageChain appendLink:firstBaseTextChain.string(string2)];

    NSAttributedString *attributedString = imageChain.attributedString;

    NSString *controlString = [NSString stringWithFormat:@"%@\tstring1string2", BONSpecial.objectReplacementCharacter];
    XCTAssertEqualObjects(attributedString.string, controlString);
}

@end
