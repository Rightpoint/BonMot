//
//  BONHumanReadableStringTestCase.m
//  BonMot
//
//  Created by Eliot Williams on 3/9/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
#import "NSAttributedString+BonMotUtilities.h"

@import BonMot;

@interface BONHumanReadableStringTestCase : BONBaseTestCase

@end

@implementation BONHumanReadableStringTestCase

- (void)test36x36ImageReplacementString
{
    UIImage *barnImage = [UIImage imageNamed:@"barn" inBundle:[NSBundle bundleForClass:[DummyAssetClass class]] compatibleWithTraitCollection:nil];
    BONChain *imageChain = BONChain.new.image(barnImage);
    BONChain *textChain = BONChain.new.string(@"concatenate me!");

    [imageChain appendLink:textChain];

    BONAssertEquivalentStrings(imageChain.attributedString, @"{image36x36}concatenate me!")
}

- (void)testBonMotLogoImageReplacementString
{
    UIImage *bonMotLogoImage = [UIImage imageNamed:@"BonMot-logo" inBundle:[NSBundle bundleForClass:[DummyAssetClass class]] compatibleWithTraitCollection:nil];
    BONChain *secondImageChain = BONChain.new.image(bonMotLogoImage);

    BONAssertEquivalentStrings(secondImageChain.attributedString, @"{image443x138}");
}

- (void)test1x2x3xAssets
{
    UIImage *bikeImage = [UIImage imageNamed:@"bicycle_sketch" inBundle:[NSBundle bundleForClass:[DummyAssetClass class]] compatibleWithTraitCollection:nil];
    BONChain *bikeImageChain = BONChain.new.image(bikeImage);

    BONAssertEquivalentStrings(bikeImageChain.attributedString, @"{image320x188}");
}

- (void)testSpecialCharacters
{
    BONChain *chain = BONChain.new.string(@"This");
    [chain appendLink:BONChain.new.string(@"string") separator:BONSpecial.tab];
    [chain appendLink:BONChain.new.string(@"is") separator:BONSpecial.lineFeed];
    [chain appendLink:BONChain.new.string(@"populated") separator:BONSpecial.space];
    [chain appendLink:BONChain.new.string(@"by") separator:BONSpecial.noBreakSpace];
    [chain appendLink:BONChain.new.string(@"BONSpecial") separator:BONSpecial.enSpace];
    [chain appendLink:BONChain.new.string(@"characters") separator:BONSpecial.figureSpace];
    [chain appendLink:BONChain.new.string(@"that") separator:BONSpecial.thinSpace];
    [chain appendLink:BONChain.new.string(@"will") separator:BONSpecial.hairSpace];
    [chain appendLink:BONChain.new.string(@"be") separator:BONSpecial.zeroWidthSpace];
    [chain appendLink:BONChain.new.string(@"replaced") separator:BONSpecial.nonBreakingHyphen];
    [chain appendLink:BONChain.new.string(@"by") separator:BONSpecial.figureDash];
    [chain appendLink:BONChain.new.string(@"simple") separator:BONSpecial.enDash];
    [chain appendLink:BONChain.new.string(@"human") separator:BONSpecial.emDash];
    [chain appendLink:BONChain.new.string(@"readable") separator:BONSpecial.horizontalEllipsis];
    [chain appendLink:BONChain.new.string(@"versions") separator:BONSpecial.lineSeparator];
    [chain appendLink:BONChain.new.string(@"of") separator:BONSpecial.paragraphSeparator];
    [chain appendLink:BONChain.new.string(@"their") separator:BONSpecial.narrowNoBreakSpace];
    [chain appendLink:BONChain.new.string(@"own") separator:BONSpecial.wordJoiner];
    [chain appendLink:BONChain.new.string(@"name") separator:BONSpecial.minusSign];

    NSString *expectedHumanReadableString = @"This{tab}string{lineFeed}is populated{noBreakSpace}by{enSpace}BONSpecial{figureSpace}characters{thinSpace}that{hairSpace}will{zeroWidthSpace}be{nonBreakingHyphen}replaced{figureDash}by{enDash}simple{emDash}human{horizontalEllipsis}readable{lineSeparator}versions{paragraphSeparator}of{narrowNoBreakSpace}their{wordJoiner}own{minusSign}name";
    NSAttributedString *testAttributedStringProperty = chain.attributedString;

    BONAssertEquivalentStrings(testAttributedStringProperty, expectedHumanReadableString);
}

- (void)testAllTheCharactersInTheKitchenSink
{
    BONChain *everything = BONChain.new;
    [everything appendLink:BONChain.new.string(@"neon")];
    [everything appendLink:BONChain.new.string(@"سلام")];
    [everything appendLink:BONChain.new.string(@"🚲")];
    [everything appendLink:BONChain.new.string(@"\U000A1338") separator:BONSpecial.figureDash];
    [everything appendLink:BONChain.new.string(@"\u20AB")];
    [everything appendLink:BONChain.new.string(@"\U000A1339")];

    NSAttributedString *kitchenSinkAttributedString = everything.attributedString;
    BONAssertEquivalentStrings(kitchenSinkAttributedString, @"neonسلام🚲{figureDash}{unassignedUnicodeA1338}₫{unassignedUnicodeA1339}");
}

- (void)testEmptyString
{
    BONChain *emptyChain = BONChain.new.string(@"");
    BONAssertEquivalentStrings(emptyChain.attributedString, @"");
}

- (void)testObjectReplacementCharacterWithoutAnImage
{
    BONChain *chain = BONChain.new.string(@"No image? ");
    [chain appendLink:BONChain.new.string(@" No problem.") separator:BONSpecial.objectReplacementCharacter];
    BONAssertEquivalentStrings(chain.attributedString, @"No image? {objectReplacementCharacter} No problem.");
}

@end
