//
//  BONFigureTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 3/24/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import CoreText.CTFontManager;
@import CoreText.SFNTLayoutTypes;

@import BonMot;

static const CGFloat kBONPointSize = 20.0;
static NSString *const kBONEBGaramond = @"EBGaramond12-Regular";
static NSString *const kBONFutura = @"Futura-Medium";

@interface BONFigureTestCase : BONBaseTestCase

@end

@implementation BONFigureTestCase

+ (void)setUp
{
    [super setUp];

    [self loadEBGaramondFont];
}

+ (UIFont *)fontFromFont:(UIFont *)font figureStyleDict:(BONStringDict *)figureStyleDict
{
    BONGeneric(NSDictionary, NSString *, BONGeneric(NSArray, BONStringDict *)*)*featureSettingsAttributes = @{
        UIFontDescriptorFeatureSettingsAttribute : @[
            figureStyleDict,
        ],
    };

    UIFontDescriptor *sourceDescriptor = font.fontDescriptor;
    UIFontDescriptor *controlDescriptor = [sourceDescriptor fontDescriptorByAddingAttributes:featureSettingsAttributes];
    UIFont *newFont = [UIFont fontWithDescriptor:controlDescriptor size:kBONPointSize];

    return newFont;
}

- (void)testFigureCase
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"1234")
            .fontNameAndSize(kBONEBGaramond, kBONPointSize)
            .figureCase(BONFigureCaseOldstyle)
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"1234");

    NSParagraphStyle *controlParagraphStyle = [[NSParagraphStyle alloc] init];

    UIFont *baseFont = [UIFont fontWithName:kBONEBGaramond size:kBONPointSize];

    BONStringDict *figureCaseDictionary = @{
        UIFontFeatureTypeIdentifierKey : @(kNumberCaseType),
        UIFontFeatureSelectorIdentifierKey : @(kLowerCaseNumbersSelector),
    };

    UIFont *controlFont = [self.class fontFromFont:baseFont figureStyleDict:figureCaseDictionary];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 4) : @{
            NSFontAttributeName : controlFont,
            NSParagraphStyleAttributeName : controlParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testFigureCaseDoesNotAffectFontsThatDoNotSupportIt
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"1234")
            .fontNameAndSize(kBONFutura, kBONPointSize)
            .figureCase(BONFigureCaseOldstyle)
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"1234");

    NSParagraphStyle *controlParagraphStyle = [[NSParagraphStyle alloc] init];

    // Fonts that don't support figure case won't be affected
    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 4) : @{
            NSFontAttributeName : [UIFont fontWithName:kBONFutura size:kBONPointSize],
            NSParagraphStyleAttributeName : controlParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testFigureSpacing
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"1234")
            .fontNameAndSize(kBONEBGaramond, kBONPointSize)
            .figureSpacing(BONFigureSpacingTabular)
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"1234");

    NSParagraphStyle *controlParagraphStyle = [[NSParagraphStyle alloc] init];

    UIFont *baseFont = [UIFont fontWithName:kBONEBGaramond size:kBONPointSize];

    BONStringDict *figureSpaceDictionary = @{
        UIFontFeatureTypeIdentifierKey : @(kNumberSpacingType),
        UIFontFeatureSelectorIdentifierKey : @(kMonospacedNumbersSelector),
    };

    UIFont *controlFont = [self.class fontFromFont:baseFont figureStyleDict:figureSpaceDictionary];

    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 4) : @{
            NSFontAttributeName : controlFont,
            NSParagraphStyleAttributeName : controlParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

- (void)testFigureSpacingDoesNotAffectFontsThatDoNotSupportIt
{
    NSAttributedString *attributedString =
        BONChain.new
            .string(@"1234")
            .fontNameAndSize(kBONFutura, kBONPointSize)
            .figureSpacing(BONFigureSpacingTabular)
            .attributedString;

    XCTAssertEqualObjects(attributedString.string, @"1234");

    NSParagraphStyle *controlParagraphStyle = [[NSParagraphStyle alloc] init];

    // Fonts that don't support figure spacing won't be affected
    NSDictionary *controlAttributes = @{
        BONValueFromRange(0, 4) : @{
            NSFontAttributeName : [UIFont fontWithName:kBONFutura size:kBONPointSize],
            NSParagraphStyleAttributeName : controlParagraphStyle,
        },
    };

    BONAssertAttributedStringHasAttributes(attributedString, controlAttributes);
}

@end
