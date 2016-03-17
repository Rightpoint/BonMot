//
//  BONTextAlignmentConstraint.m
//  BonMot
//
//  Created by Zev Eisenberg on 5/2/15.
//
//

#import "BONTextAlignmentConstraint.h"

typedef NS_ENUM(NSUInteger, BONItemOrdinality) {
    BONItemOrdinalityUnknown = 0,
    BONItemOrdinalityFirst,
    BONItemOrdinalitySecond,
};

static void *const kBONTextAlignmentConstraintContext = (void *)&kBONTextAlignmentConstraintContext;

NSString *stringFromBONConstraintAttribute(BONConstraintAttribute attribute)
{
    NSString *string = nil;
    switch (attribute) {
        case BONConstraintAttributeUnspecified: {
            string = @"unspecified";
            break;
        }
        case BONConstraintAttributeTop: {
            string = @"top";
            break;
        }
        case BONConstraintAttributeCapHeight: {
            string = @"cap height";
            break;
        }
        case BONConstraintAttributeXHeight: {
            string = @"x-height";
            break;
        }
        case BONConstraintAttributeFirstBaseline: {
            string = @"first baseline";
            break;
        }
        case BONConstraintAttributeLastBaseline: {
            string = @"last baseline";
            break;
        }
        case BONConstraintAttributeBottom: {
            string = @"bottom";
            break;
        }
    }
    return string;
}

NSString *BONCNonnull normalizeString(NSString *BONCNonnull string)
{
    NSString *lowercaseString = [string lowercaseString];

    // strip all non-letter characters
    BONGeneric(NSArray, NSString *)*lettersOnlyComponents = [lowercaseString componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]];
    NSString *lettersOnlyString = [lettersOnlyComponents componentsJoinedByString:@""];

    BONGeneric(NSArray, NSString *)*noWhitespaceComponents = [lettersOnlyString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *noWhitespaceString = [noWhitespaceComponents componentsJoinedByString:@""];

    return noWhitespaceString;
}

BONConstraintAttribute BONConstraintAttributeFromString(NSString *string)
{
    static BONGeneric(NSDictionary, NSString *, NSNumber *)*s_mappings = nil;
    if (!s_mappings) {
        s_mappings = @{
            @"unspecified" : @(BONConstraintAttributeUnspecified),
            @"top" : @(BONConstraintAttributeTop),
            @"capheight" : @(BONConstraintAttributeCapHeight),
            @"xheight" : @(BONConstraintAttributeXHeight),
            @"firstbaseline" : @(BONConstraintAttributeFirstBaseline),
            @"lastbaseline" : @(BONConstraintAttributeLastBaseline),
            @"bottom" : @(BONConstraintAttributeBottom),
        };
    }

    NSString *normalizedString = normalizeString(string);

#if !defined(NS_BLOCK_ASSERTIONS)
    // Test our assumption that none of the mapping strings ends in 's'
    for (NSString *mappingString in s_mappings) {
        NSCAssert(![mappingString hasSuffix:@"s"], @"This code assumes we can just strip trailing 's'es off the end of the passed string, but now that s_mappings contains a string with a trailing 's', this is no longer the case.");
    }
#endif

    // Remove trailing s, if present, to handle plural case
    if ([normalizedString hasSuffix:@"s"]) {
        normalizedString = [normalizedString substringToIndex:normalizedString.length - 1];
    }

    NSCAssert(![normalizedString isEqualToString:@"baseline"], @"You must specify whether to align to the first baseline or last baseline of a label, even if it is a single-line label.");

    NSNumber *attributeNumber = s_mappings[normalizedString];
    BONConstraintAttribute attribute = BONConstraintAttributeUnspecified;
    if (attributeNumber) {
        attribute = attributeNumber.unsignedIntegerValue;
    }

    return attribute;
}

NSLayoutAttribute requiredLayoutAttributeForBONConstraintAttribute(BONConstraintAttribute bonConstraintAttribute)
{
    NSLayoutAttribute nsAttribute;
    switch (bonConstraintAttribute) {
        case BONConstraintAttributeTop:           // fall through
        case BONConstraintAttributeCapHeight:     // fall through
        case BONConstraintAttributeFirstBaseline: // fall through
        case BONConstraintAttributeXHeight: {
            nsAttribute = NSLayoutAttributeTop;
            break;
        }
        case BONConstraintAttributeLastBaseline: // fall through
        case BONConstraintAttributeBottom: {
            nsAttribute = NSLayoutAttributeBottom;
            break;
        }
        case BONConstraintAttributeUnspecified: {
            nsAttribute = NSLayoutAttributeNotAnAttribute;
            break;
        }
    }

    return nsAttribute;
}

@interface BONTextAlignmentConstraint ()

@property (strong, nonatomic) id strongItem1;
@property (strong, nonatomic) id strongItem2;

@end

@implementation BONTextAlignmentConstraint

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(BONConstraintAttribute)attr1
                         relatedBy:(NSLayoutRelation)relation
                            toItem:(id)view2
                         attribute:(BONConstraintAttribute)attr2
{
    NSLayoutAttribute item1NSLayoutAttribute = requiredLayoutAttributeForBONConstraintAttribute(attr1);
    NSLayoutAttribute item2NSLayoutAttribute = requiredLayoutAttributeForBONConstraintAttribute(attr2);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:view1
                                                                                  attribute:item1NSLayoutAttribute
                                                                                  relatedBy:relation
                                                                                     toItem:view2
                                                                                  attribute:item2NSLayoutAttribute
                                                                                 multiplier:1.0
                                                                                   constant:0.0];
    constraint.strongItem1 = view1;
    constraint.strongItem2 = view2;
    constraint.firstItemBONAttribute = attr1;
    constraint.secondItemBONAttribute = attr2;

    [constraint setUpObservers];

    CGFloat distanceFromTop1 = [constraint distanceFromTopOfItem:BONItemOrdinalityFirst];
    CGFloat distanceFromTop2 = [constraint distanceFromTopOfItem:BONItemOrdinalitySecond];

    CGFloat difference = distanceFromTop2 - distanceFromTop1;
    constraint.constant = difference;
    return constraint;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpObservers];
}

- (void)dealloc
{
    [self tearDownObservers];
}

- (void)setFirstAlignment:(NSString *)firstAlignment
{
    if ((_firstAlignment || firstAlignment) && ![_firstAlignment isEqualToString:firstAlignment]) {
        _firstAlignment = firstAlignment.copy;
        self.firstItemBONAttribute = BONConstraintAttributeFromString(firstAlignment);
    }
}

- (void)setSecondAlignment:(NSString *)secondAlignment
{
    if ((_secondAlignment || secondAlignment) && ![_secondAlignment isEqualToString:secondAlignment]) {
        _secondAlignment = secondAlignment.copy;
        self.secondItemBONAttribute = BONConstraintAttributeFromString(secondAlignment);
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(BONStringDict *)change context:(void *)context
{
    if (context == kBONTextAlignmentConstraintContext) {
        [self updateConstant];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Private

- (void)setUpObservers
{
    NSString *firstItemFontKeyPath = [@[
        NSStringFromSelector(@selector(firstItem)),
        NSStringFromSelector(@selector(font)),
    ] componentsJoinedByString:@"."];

    NSString *secondItemFontKeyPath = [@[
        NSStringFromSelector(@selector(secondItem)),
        NSStringFromSelector(@selector(font)),
    ] componentsJoinedByString:@"."];

    [self addObserver:self forKeyPath:firstItemFontKeyPath options:0 context:kBONTextAlignmentConstraintContext];
    [self addObserver:self forKeyPath:secondItemFontKeyPath options:0 context:kBONTextAlignmentConstraintContext];

    // Call Observer method once initially
    [self updateConstant];
}

- (void)tearDownObservers
{
    NSString *firstItemFontKeyPath = [@[
        NSStringFromSelector(@selector(firstItem)),
        NSStringFromSelector(@selector(font)),
    ] componentsJoinedByString:@"."];

    NSString *secondItemFontKeyPath = [@[
        NSStringFromSelector(@selector(secondItem)),
        NSStringFromSelector(@selector(font)),
    ] componentsJoinedByString:@"."];

    [self removeObserver:self forKeyPath:firstItemFontKeyPath context:kBONTextAlignmentConstraintContext];
    [self removeObserver:self forKeyPath:secondItemFontKeyPath context:kBONTextAlignmentConstraintContext];
}

- (void)updateConstant
{
    CGFloat firstItemDistanceFromTop = [self distanceFromTopOfItem:BONItemOrdinalityFirst];
    CGFloat secondItemDistanceFromTop = [self distanceFromTopOfItem:BONItemOrdinalitySecond];

    CGFloat offset = secondItemDistanceFromTop - firstItemDistanceFromTop;
    self.constant = offset;
}

- (CGFloat)distanceFromTopOfItem:(BONItemOrdinality)ordinality
{
    id item;
    BONConstraintAttribute bonConstraintAttribute;
    switch (ordinality) {
        case BONItemOrdinalityFirst:
            item = self.firstItem;
            bonConstraintAttribute = self.firstItemBONAttribute;
            break;
        case BONItemOrdinalitySecond:
            item = self.secondItem;
            bonConstraintAttribute = self.secondItemBONAttribute;
            break;
        case BONItemOrdinalityUnknown:
            [NSException raise:NSInternalInconsistencyException format:@"Requesting distance from top of unknown item"];
            break;
    }

    CGFloat distanceFromTop = 0.0;

    if (bonConstraintAttribute != BONConstraintAttributeTop) {
        if ([item respondsToSelector:@selector(font)]) {
            UIFont *font = [item font];

            CGFloat topToBaseline = font.ascender;

            switch (bonConstraintAttribute) {
                case BONConstraintAttributeCapHeight: {
                    CGFloat baselineToCapHeight = font.capHeight;
                    distanceFromTop = topToBaseline - baselineToCapHeight;
                    break;
                }
                case BONConstraintAttributeXHeight: {
                    CGFloat baselineToXHeight = font.xHeight;
                    distanceFromTop = topToBaseline - baselineToXHeight;
                    break;
                }
                case BONConstraintAttributeTop: {
                    [NSException raise:NSInternalInconsistencyException format:@"Should never get here, because the BONConstraintAttributeTop should be handled above"];
                    break;
                }
                case BONConstraintAttributeFirstBaseline: // fall through
                case BONConstraintAttributeLastBaseline:  // fall through
                case BONConstraintAttributeBottom: {
                    [NSException raise:NSInternalInconsistencyException format:@"%@ alignment is not currently supported with %@. Please check https://github.com/Raizlabs/BonMot/issues/37 for progress on this issue.", stringFromBONConstraintAttribute(bonConstraintAttribute), NSStringFromClass(self.class)];
                    break;
                }
                case BONConstraintAttributeUnspecified: {
                    [NSException raise:NSInternalInconsistencyException format:@"Attempt to reason about unspecified constraint attribute"];
                }
            }
        }
    }

    return distanceFromTop;
}

@end
