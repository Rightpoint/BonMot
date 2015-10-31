//
//  BONDebugStringTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 10/30/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

#import <BonMot/BonMot.h>

@interface BONDebugStringTestCase : BONBaseTestCase

@end

@implementation BONDebugStringTestCase

- (void)testEmptyString
{
    BONText *text = BONChain.new.text;
    NSString *debugString = [text debugString];
    XCTAssertEqualObjects(debugString, @"(empty string)");
}

- (void)testNormalCharacters
{
    XCTAssertEqualObjects([BONChain.new.string(@"BonMot").text debugString], @"B\no\nn\nM\no\nt");

    XCTAssertEqualObjects([BONChain.new.string(@"Bon Mot").text debugString], @"B\no\nn\n (Space)\nM\no\nt");

    XCTAssertEqualObjects([BONChain.new.string(@"Bon\tMot").text debugString], @"B\no\nn\n\t(Tab)\nM\no\nt");

    XCTAssertEqualObjects([BONChain.new.string(@"Bon\nMot").text debugString], @"B\no\nn\n (Line Feed)\nM\no\nt");
}

- (void)testUnassignedCharacters
{
    XCTAssertEqualObjects([BONChain.new.string(@"->\U000A1138<-").text debugString], @"-\n>\n\U000A1138(\\N{<unassigned-A1138>})\n<\n-");
}

- (void)testPilcrowBecausePilcrowsAreCool
{
    XCTAssertEqualObjects([BONChain.new.string(@"Pilcrow¶").text debugString], @"P\ni\nl\nc\nr\no\nw\n¶(\\N{PILCROW SIGN})");
}

- (void)testEmoji
{
    XCTAssertEqualObjects([BONChain.new.string(@"Floppy💾Disk").text debugString], @"F\nl\no\np\np\ny\n💾(\\N{FLOPPY DISK})\nD\ni\ns\nk");
}

- (void)testSpecialCharacters
{
    NSString *string = [NSString stringWithFormat:@"a%@b%@c%@d", BONSpecial.enSpace, BONSpecial.zeroWidthSpace, BONSpecial.narrowNoBreakSpace];
    NSString *controlString = [NSString stringWithFormat:@"a\n%@(\\N{EN SPACE})\nb\n%@(\\N{ZERO WIDTH SPACE})\nc\n%@(\\N{NARROW NO-BREAK SPACE})\nd", BONSpecial.enSpace, BONSpecial.zeroWidthSpace, BONSpecial.narrowNoBreakSpace];
    XCTAssertEqualObjects([BONChain.new.string(string).text debugString], controlString);
}

- (void)testImage
{
    UIImage *image = [UIImage imageNamed:@"circuit" inBundle:[NSBundle bundleForClass:[BONChain class]] compatibleWithTraitCollection:nil];
    BONText *singleImage = BONChain.new.image(image).text;
    XCTAssertEqualObjects([singleImage debugStringIncludeImageAddresses:NO], @"(attached image of size: {36, 36})");

    NSString *debugStringWithAddresses = [singleImage debugString];
    NSString *imagePattern = @"\\(<UIImage: 0x[0-9a-f]{6,12}>, \\{36, 36\\}\\)";

    NSError *expressionError;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:imagePattern options:0 error:&expressionError];
    XCTAssertNotNil(expression);
    if (!expression) {
        NSLog(@"Error creating expression: %@", expressionError);
    }

    NSUInteger singleMatches = [expression numberOfMatchesInString:debugStringWithAddresses
                                                     options:NSMatchingAnchored
                                                       range:NSMakeRange(0, debugStringWithAddresses.length)];
    XCTAssertEqual(singleMatches, 1);

    BONChain *longer = BONChain.new.string(@"pre");
    [longer appendLink:singleImage];
    [longer appendLink:BONChain.new.string(@"post")];

    XCTAssertEqualObjects([longer.text debugStringIncludeImageAddresses:NO], @"p\nr\ne\n(attached image of size: {36, 36})\np\no\ns\nt");

    NSString *longerDebugStringWithAddresses = [longer.text debugString];

    NSUInteger longerMatches = [expression numberOfMatchesInString:longerDebugStringWithAddresses
                                                           options:0
                                                             range:NSMakeRange(0, longerDebugStringWithAddresses.length)];
    XCTAssertEqual(longerMatches, 1);

    XCTAssertEqualObjects([longer.text debugString], [longer.text debugStringIncludeImageAddresses:YES]);
}

- (void)testSomeOfEverything
{
    UIImage *image = [UIImage imageNamed:@"robot" inBundle:[NSBundle bundleForClass:[BONChain class]] compatibleWithTraitCollection:nil];

    BONChain *everything = BONChain.new;
    [everything appendLink:BONChain.new.string(@"aluminium")];
    [everything appendLink:BONChain.new.string(@"זְאֵב")];
    [everything appendLink:BONChain.new.string(@"🐺")];
    [everything appendLink:BONChain.new.string(@"\U000A1337") separator:BONSpecial.figureDash];
    [everything appendLink:BONChain.new.image(image)];

    NSString *controlString = [NSString stringWithFormat:@"a\nl\nu\nm\ni\nn\ni\nu\nm\nזְ(\\N{HEBREW LETTER ZAYIN}\\N{HEBREW POINT SHEVA})\nאֵ(\\N{HEBREW LETTER ALEF}\\N{HEBREW POINT TSERE})\nב(\\N{HEBREW LETTER BET})\n🐺(\\N{WOLF FACE})\n%@(\\N{FIGURE DASH})\n\U000A1337(\\N{<unassigned-A1337>})\n(attached image of size: {36, 36})", BONSpecial.figureDash];
    XCTAssertEqualObjects([everything.text debugStringIncludeImageAddresses:NO], controlString);
}

@end
