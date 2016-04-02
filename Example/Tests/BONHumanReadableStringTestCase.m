//
//  BONHumanReadableStringTestCase.m
//  BonMot
//
//  Created by Eliot Williams on 3/9/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

static const double kBONEpsilon = 0.0001;
static const double kBONOneThird = 1.0 / 3.0;
static const double kBONTwoThirds = 2.0 / 3.0;

OBJC_EXTERN NSString *BONDoubleRoundedString(double theDouble);
OBJC_EXTERN NSString *BONPrettyStringFromCGSize(CGSize size);

@import BonMot;

@interface BONHumanReadableStringTestCase : BONBaseTestCase

@end

@implementation BONHumanReadableStringTestCase

+ (UIImage *)dummyImageOfSize:(CGSize)size scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);

    [[UIColor redColor] setFill];
    UIRectFill(CGRectMake(0.0, 0.0, size.width, size.height));

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)testDoubleRoundedString
{
    NSString *basic = BONDoubleRoundedString(1.0);
    XCTAssertEqualObjects(basic, @"1");

    NSString *epsilonTest = BONDoubleRoundedString(1.0000001);
    XCTAssertEqualObjects(epsilonTest, @"1");

    NSString *negative = BONDoubleRoundedString(-1.0);
    XCTAssertEqualObjects(negative, @"-1");

    NSString *smallFractional = BONDoubleRoundedString(7 + kBONTwoThirds);
    XCTAssertEqualObjects(smallFractional, @"7.667");

    NSString *largeFractional = BONDoubleRoundedString(13682 + kBONOneThird);
    XCTAssertEqualObjects(largeFractional, @"13682.333");

    NSString *halfFractional = BONDoubleRoundedString(12345.5);
    XCTAssertEqualObjects(halfFractional, @"12345.5");
}

- (void)testPrettyCGSize
{
    NSString *basic = BONPrettyStringFromCGSize(CGSizeMake(1.0, 1.0));
    XCTAssertEqualObjects(basic, @"1x1");

    NSString *fractions = BONPrettyStringFromCGSize(CGSizeMake(13.5, 827 + kBONOneThird));
    XCTAssertEqualObjects(fractions, @"13.5x827.333");

    NSString *bigFractions = BONPrettyStringFromCGSize(CGSizeMake(2468.0 + kBONTwoThirds, -4272.5));
    XCTAssertEqualObjects(bigFractions, @"2468.667x-4272.5");
}

- (void)testDummyImageMaker
{
    UIImage *image1x = [self.class dummyImageOfSize:CGSizeMake(1.0, 1.0) scale:1.0];
    XCTAssertEqualWithAccuracy(image1x.size.width, 1.0, kBONEpsilon);
    XCTAssertEqualWithAccuracy(image1x.size.height, 1.0, kBONEpsilon);

    UIImage *image2x = [self.class dummyImageOfSize:CGSizeMake(1.0, 1.0) scale:2.0];
    XCTAssertEqualWithAccuracy(image2x.size.width, 1.0, kBONEpsilon);
    XCTAssertEqualWithAccuracy(image2x.size.height, 1.0, kBONEpsilon);

    UIImage *image3x = [self.class dummyImageOfSize:CGSizeMake(1.0, 1.0) scale:2.0];
    XCTAssertEqualWithAccuracy(image3x.size.width, 1.0, kBONEpsilon);
    XCTAssertEqualWithAccuracy(image3x.size.height, 1.0, kBONEpsilon);

    UIImage *imageFractional3x = [self.class dummyImageOfSize:CGSizeMake(3.0 + kBONOneThird, 10.0 + kBONTwoThirds) scale:3.0];
    XCTAssertEqualWithAccuracy(imageFractional3x.size.width, 3.333333333, kBONEpsilon);
    XCTAssertEqualWithAccuracy(imageFractional3x.size.height, 10.66666666, kBONEpsilon);
}

- (void)testBasicImageReplacementString
{
    UIImage *image = [self.class dummyImageOfSize:CGSizeMake(36.0, 36.0) scale:1.0];
    BONChain *imageChain = BONChain.new.image(image);
    BONChain *textChain = BONChain.new.string(@"concatenate me!");

    [imageChain appendLink:textChain];

    BONAssertEquivalentStrings(imageChain.attributedString, @"{image36x36}concatenate me!");
}

- (void)testNoImageSizeReplacementString
{
    UIImage *image = [self.class dummyImageOfSize:CGSizeMake(36.0, 36.0) scale:1.0];
    BONChain *imageChain = BONChain.new.image(image);
    BONChain *textChain = BONChain.new.string(@"concatenate me!");

    [imageChain appendLink:textChain];

    NSString *humanReadableString = [imageChain.attributedString bon_humanReadableStringIncludingImageSize:NO];
    XCTAssertEqualObjects(humanReadableString, @"{image}concatenate me!");
}

- (void)testBonMotLogoImageReplacementString
{
    UIImage *bonMotLogoImage = [UIImage imageNamed:@"BonMot-logo" inBundle:[NSBundle bundleForClass:[DummyAssetClass class]] compatibleWithTraitCollection:nil];
    BONChain *secondImageChain = BONChain.new.image(bonMotLogoImage);

    BONAssertEquivalentStrings(secondImageChain.attributedString, @"{image443x138}");
}

- (void)testImagesOfDifferentScales
{
    UIImage *image1x = [self.class dummyImageOfSize:CGSizeMake(320.0, 188.0) scale:1.0];
    BONChain *chain1x = BONChain.new.image(image1x);

    BONAssertEquivalentStrings(chain1x.attributedString, @"{image320x188}");

    UIImage *image2x = [self.class dummyImageOfSize:CGSizeMake(640.0, 376.0) scale:1.0];
    BONChain *chain2x = BONChain.new.image(image2x);

    BONAssertEquivalentStrings(chain2x.attributedString, @"{image640x376}");

    UIImage *image3x = [self.class dummyImageOfSize:CGSizeMake(750.0, 441.0) scale:1.0];
    BONChain *chain3x = BONChain.new.image(image3x);

    BONAssertEquivalentStrings(chain3x.attributedString, @"{image750x441}");
}

- (void)testFractionalImagesOfDifferentScales
{
    UIImage *fractionalImage2x = [self.class dummyImageOfSize:CGSizeMake(640.5, 376.5) scale:2.0];
    BONChain *fractionalChain2x = BONChain.new.image(fractionalImage2x);

    BONAssertEquivalentStrings(fractionalChain2x.attributedString, @"{image640.5x376.5}");

    UIImage *fractionalImage3x = [self.class dummyImageOfSize:CGSizeMake(750.0 + kBONOneThird, 441.0 + kBONTwoThirds) scale:3.0];
    BONChain *fractionalChain3x = BONChain.new.image(fractionalImage3x);

    BONAssertEquivalentStrings(fractionalChain3x.attributedString, @"{image750.333x441.667}");
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

- (void)testNewLines
{
    BONGeneric(NSArray, NSString *)*lineBreakCharacters = @[
        BONSpecial.lineFeed,
        BONSpecial.verticalTab,
        BONSpecial.formFeed,
        BONSpecial.carriageReturn,
        BONSpecial.nextLine,
        BONSpecial.lineSeparator,
        BONSpecial.paragraphSeparator,
    ];

    BONChain *lineBreaksChain = BONChain.new;

    for (NSUInteger i = 0; i < lineBreakCharacters.count; i++) {
        NSString *character = lineBreakCharacters[i];
        [lineBreaksChain appendLink:BONChain.new.string(character) separator:@(i).stringValue];
    }

    [lineBreaksChain appendLink:BONChain.new.string(@(lineBreakCharacters.count).stringValue)];

    NSAttributedString *lineBreaksAttributedString = lineBreaksChain.attributedString;
    NSString *controlLineBreaksString = @"0{lineFeed}1{verticalTab}2{formFeed}3{carriageReturn}4{nextLine}5{lineSeparator}6{paragraphSeparator}7";

    BONAssertEquivalentStrings(lineBreaksAttributedString, controlLineBreaksString);

    BONChain *carriageReturnLineFeedChain = BONChain.new.string(@"foo\r\nbar");
    NSAttributedString *carriageReturnLineFeedAttributedString = carriageReturnLineFeedChain.attributedString;
    NSString *carriageReturnLineFeedControlString = @"foo{carriageReturn}{lineFeed}bar";

    BONAssertEquivalentStrings(carriageReturnLineFeedAttributedString, carriageReturnLineFeedControlString);

    BONChain *escapedCharactersChain = BONChain.new.string(@"backslash-n\n\\n\r\\r");
    BONAssertEquivalentStrings(escapedCharactersChain.attributedString, @"backslash-n{lineFeed}\\n{carriageReturn}\\r");
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
