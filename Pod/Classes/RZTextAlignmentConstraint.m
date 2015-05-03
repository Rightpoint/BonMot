//
//  RZTextAlignmentConstraint.m
//  Pods
//
//  Created by Zev Eisenberg on 5/2/15.
//
//

#import "RZTextAlignmentConstraint.h"

// Utilities
#import <RZDataBinding/NSObject+RZDataBinding.h>

typedef NS_ENUM(NSUInteger, RZItemOrdinality) {
    RZItemOrdinalityUnknown = 0,
    RZItemOrdinalityFirst,
    RZItemOrdinalitySecond,
};

static void* const kRZTextAlignmentConstraintContext = (void *)&kRZTextAlignmentConstraintContext;

NSString *stringFromRZConstraintAttribute(RZConstraintAttribute attribute)
{
    NSString *string = nil;
    switch ( attribute ) {
        case RZConstraintAttributeUnspecified: {
            string = @"unspecified";
            break;
        }
        case RZConstraintAttributeTop: {
            string = @"top";
            break;
        }
        case RZConstraintAttributeCapHeight: {
            string = @"cap height";
            break;
        }
        case RZConstraintAttributeXHeight: {
            string = @"x-height";
            break;
        }
        case RZConstraintAttributeFirstBaseline: {
            string = @"first baseline";
            break;
        }
        case RZConstraintAttributeLastBaseline: {
            string = @"last baseline";
            break;
        }
        case RZConstraintAttributeBottom: {
            string = @"bottom";
            break;
        }
    }
    return string;
}

NSString *normalizeString(NSString *string)
{
    NSString *lowercaseString = [string lowercaseString];

    // strip all non-letter characters
    NSArray *lettersOnlyComponents = [lowercaseString componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]];
    NSString *lettersOnlyString = [lettersOnlyComponents componentsJoinedByString:nil];

    NSArray *noWhitespaceComponents = [lettersOnlyString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *noWhitespaceString = [noWhitespaceComponents componentsJoinedByString:nil];

    return noWhitespaceString;
}


RZConstraintAttribute RZConstraintAttributeFromString(NSString *string)
{
    static NSDictionary *s_mappings = nil;
    if ( !s_mappings ) {
        s_mappings = @{
                       @"unspecified": @(RZConstraintAttributeUnspecified),
                       @"top": @(RZConstraintAttributeTop),
                       @"capheight": @(RZConstraintAttributeCapHeight),
                       @"xheight": @(RZConstraintAttributeXHeight),
                       @"firstbaseline": @(RZConstraintAttributeFirstBaseline),
                       @"lastbaseline": @(RZConstraintAttributeLastBaseline),
                       @"bottom": @(RZConstraintAttributeBottom),
                       };
    }

    NSString *normalizedString = normalizeString(string);

#if !defined(NS_BLOCK_ASSERTIONS)
    // Test our assumption that none of the mapping strings ends in 's'
    for ( NSString *mappingString in s_mappings ) {
        NSCAssert(![mappingString hasSuffix:@"s"], @"This code assumes we can just strip trailing 's'es off the end of the passed string, but now that s_mappings contains a string with a trailing 's', this is no longer the case.");
    }
#endif

    // Remove trailing s, if present, to handle plural case
    if ( [normalizedString hasSuffix:@"s"] ) {
        normalizedString = [normalizedString substringToIndex:normalizedString.length - 1];
    }

    NSCAssert(![normalizedString isEqualToString:@"baseline"], @"You must specify whether to align to the first baseline or last baseline of a label, even if it is a single-line label.");

    NSNumber *attributeNumber = s_mappings[normalizedString];
    RZConstraintAttribute attribute = RZConstraintAttributeUnspecified;
    if ( attributeNumber ) {
        attribute = attributeNumber.unsignedIntegerValue;
    }

    return attribute;
}

NSLayoutAttribute requiredLayoutAttributeForRZConstraintAttribute(RZConstraintAttribute rzAttribute)
{
    NSLayoutAttribute nsAttribute;
    switch ( rzAttribute ) {
        case RZConstraintAttributeTop: // fall through
        case RZConstraintAttributeCapHeight: // fall through
        case RZConstraintAttributeFirstBaseline: // fall through
        case RZConstraintAttributeXHeight: {
            nsAttribute = NSLayoutAttributeTop;
            break;
        }
        case RZConstraintAttributeLastBaseline: // fall through
        case RZConstraintAttributeBottom: {
            nsAttribute = NSLayoutAttributeBottom;
            break;
        }
        case RZConstraintAttributeUnspecified: {
            nsAttribute = NSLayoutAttributeNotAnAttribute;
            break;
        }
    }

    return nsAttribute;
}

@implementation RZTextAlignmentConstraint

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(RZConstraintAttribute)attr1
                         relatedBy:(NSLayoutRelation)relation
                            toItem:(id)view2
                         attribute:(RZConstraintAttribute)attr2
{
    [NSException raise:NSInternalInconsistencyException format:@"This hasn't been implemented yet"];
    // TODO: this
    return nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureObservers];
}

- (void)setFirstAlignment:(NSString *)firstAlignment
{
    if ( (_firstAlignment || firstAlignment) && ![_firstAlignment isEqualToString:firstAlignment] ) {
        _firstAlignment = firstAlignment.copy;
        self.firstItemRZAttribute = RZConstraintAttributeFromString(firstAlignment);
    }
}

- (void)setSecondAlignment:(NSString *)secondAlignment
{
    if ( (_secondAlignment || secondAlignment) && ![_secondAlignment isEqualToString:secondAlignment] ) {
        _secondAlignment = secondAlignment.copy;
        self.secondItemRZAttribute = RZConstraintAttributeFromString(secondAlignment);
    }
}

#pragma mark - Private

- (void)configureObservers
{
    NSString *firstItemFontKeyPath = [@[
                                        NSStringFromSelector(@selector(firstItem)),
                                        NSStringFromSelector(@selector(font)),
                                        ] componentsJoinedByString:@"."];

    NSString *secondItemFontKeyPath = [@[
                                         NSStringFromSelector(@selector(secondItem)),
                                         NSStringFromSelector(@selector(font)),
                                         ] componentsJoinedByString:@"."];

    [self rz_addTarget:self
                action:@selector(updateConstant)
      forKeyPathChange:firstItemFontKeyPath];

    [self rz_addTarget:self
                action:@selector(updateConstant)
      forKeyPathChange:secondItemFontKeyPath];

    [self updateConstant]; // work around issue with RZDataBinding where callImmediately doesn't work if the key path can't be fully resolved: https://github.com/Raizlabs/RZDataBinding/issues/34
}

- (void)updateConstant
{
    CGFloat firstItemDistanceFromTop = [self distanceFromTopOfItem:RZItemOrdinalityFirst];
    CGFloat secondItemDistanceFromTop = [self distanceFromTopOfItem:RZItemOrdinalitySecond];

    CGFloat offset = secondItemDistanceFromTop - firstItemDistanceFromTop;
    self.constant = offset;
}

- (CGFloat)distanceFromTopOfItem:(RZItemOrdinality)ordinality
{
    id item;
    RZConstraintAttribute rzAttribute;
    switch ( ordinality ) {
        case RZItemOrdinalityFirst:
            item = self.firstItem;
            rzAttribute = self.firstItemRZAttribute;
            break;
        case RZItemOrdinalitySecond:
            item = self.secondItem;
            rzAttribute = self.secondItemRZAttribute;
            break;
        case RZItemOrdinalityUnknown:
            [NSException raise:NSInternalInconsistencyException format:@"Requesting distance from top of unknown item"];
            break;
    }

    CGFloat distanceFromTop = 0.0f;

    if ( rzAttribute != RZConstraintAttributeTop ) {
        if ( [item respondsToSelector:@selector(font)] ) {
            UIFont *font = [item font];

            CGFloat topToBaseline = font.ascender;

            switch ( rzAttribute ) {
                case RZConstraintAttributeCapHeight: {
                    CGFloat baselineToCapHeight = font.capHeight;
                    distanceFromTop = topToBaseline - baselineToCapHeight;
                    break;
                }
                case RZConstraintAttributeXHeight: {
                    CGFloat baselineToXHeight = font.xHeight;
                    distanceFromTop = topToBaseline - baselineToXHeight;
                    break;
                }
                case RZConstraintAttributeTop: {
                    [NSException raise:NSInternalInconsistencyException format:@"Should never get here, because the RZConstraintAttributeTop should be handled above"];
                    break;
                }
                case RZConstraintAttributeFirstBaseline: // fall through
                case RZConstraintAttributeLastBaseline: // fall through
                case RZConstraintAttributeBottom: // fall through
                case RZConstraintAttributeUnspecified: {
                    [NSException raise:NSInternalInconsistencyException format:@"Not implemented yet"];
                    break;
                }
            }
        }
    }

    return distanceFromTop;
}

@end
