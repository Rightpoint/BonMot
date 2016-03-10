//
//  BONHumanReadableStringTestCase.m
//  BonMot
//
//  Created by Eliot Williams on 3/9/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import BonMot;

@interface BONHumanReadableStringTestCase : BONBaseTestCase

@end

@implementation BONHumanReadableStringTestCase

- (void)testImageReplacementString
{
    UIImage *barnImage = [UIImage imageNamed:@"barn" inBundle:[NSBundle bundleForClass:[DummyAssetClass class]] compatibleWithTraitCollection:nil];
    BONChain *imageChain = BONChain.new.image(barnImage);
    BONChain *textChain = BONChain.new.string(@"concatenate me!");

    [imageChain appendLink:textChain];

    BONAssertEquivalentStrings(imageChain.attributedString, @"{image36x36}concatenate me!")
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
    [everything appendLink:BONChain.new.string(@"\U000A1337") separator:BONSpecial.figureDash];
    [everything appendLink:BONChain.new.string(@"\u20AB")];

    NSAttributedString *kitchenSinkAttributedString = everything.attributedString;
    BONAssertEquivalentStrings(kitchenSinkAttributedString, @"neonسلام🚲{figureDash}򡌷₫");
}

- (void)testEmptyString
{
    BONChain *emptyChain = BONChain.new.string(@"");
    BONAssertEquivalentStrings(emptyChain.attributedString, @"");
}

@end
