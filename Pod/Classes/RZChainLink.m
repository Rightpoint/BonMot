//
//  RZChainLink.m
//  Pods
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

#import "RZChainLink.h"

#import <manuscript/RZManuscript.h>

@interface RZChainLink ()

@property (strong, nonatomic) RZManuscript *manuscript;

@end

@implementation RZChainLink

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _manuscript = [[RZManuscript alloc] init];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) chainLink = [[self.class alloc] init];
    chainLink.manuscript = self.manuscript.copy;
    return chainLink;
}

- (NSAttributedString *)attributedString
{
    return self.manuscript.attributedString;
}

- (NSDictionary *)attributes
{
    return self.manuscript.attributes;
}

- (RZChainLinkFontNameAndSize)fontNameAndSize
{
    RZChainLinkFontNameAndSize fontNameAndSizeBlock = ^(NSString *fontName, CGFloat fontSize) {
        typeof(self) newChainLink = self.copy;
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        NSAssert(font, @"No font returned from [UIFont fontWithName:%@ size:%@]", fontName, @(fontSize));
        newChainLink.manuscript.font = font;
        return newChainLink;
    };

    return [fontNameAndSizeBlock copy];
}

- (RZChainLinkFont)font
{
    RZChainLinkFont fontBlock = ^(UIFont *font) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.font = font;
        return newChainLink;
    };

    return [fontBlock copy];
}

- (RZChainLinkColor)textColor
{
    RZChainLinkColor colorBlock = ^(UIColor *color) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.textColor = color;
        return newChainLink;
    };

    return [colorBlock copy];
}

- (RZChainLinkColor)backgroundColor
{
    RZChainLinkColor colorBlock = ^(UIColor *color) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.backgroundColor = color;
        return newChainLink;
    };

    return [colorBlock copy];
}

- (RZChainLinkAdobeTracking)adobeTracking
{
    RZChainLinkAdobeTracking adobeTrackingBlock = ^(NSInteger adobeTracking) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.adobeTracking = adobeTracking;
        newChainLink.manuscript.pointTracking = 0.0f;
        return newChainLink;
    };

    return [adobeTrackingBlock copy];
}

- (RZChainLinkPointTracking)pointTracking
{
    RZChainLinkPointTracking pointTrackingBlock = ^(CGFloat pointTracking) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.pointTracking = pointTracking;
        newChainLink.manuscript.adobeTracking = 0;
        return newChainLink;
    };

    return [pointTrackingBlock copy];
}

- (RZChainLinkLineHeight)lineHeightMultiple
{
    RZChainLinkLineHeight lineHeightMultipleBlock = ^(CGFloat lineHeightMultiple) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.lineHeightMultiple = lineHeightMultiple;
        return newChainLink;
    };

    return [lineHeightMultipleBlock copy];
}

- (RZChainLinkBaselineOffset)baselineOffset
{
    RZChainLinkBaselineOffset baselineOffsetBlock = ^(CGFloat baselineOffset) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.baselineOffset = baselineOffset;
        return newChainLink;
    };

    return [baselineOffsetBlock copy];
}

- (RZChainLinkFigureCase)figureCase
{
    RZChainLinkFigureCase figureCaseBlock = ^(RZFigureCase figureCase) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.figureCase = figureCase;
        return newChainLink;
    };

    return [figureCaseBlock copy];
}

- (RZChainLinkFigureSpacing)figureSpacing
{
    RZChainLinkFigureSpacing figureSpacingBlock = ^(RZFigureSpacing figureSpacing) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.figureSpacing = figureSpacing;
        return newChainLink;
    };

    return [figureSpacingBlock copy];
}

- (RZChainLinkString)string
{
    RZChainLinkString stringBlock = ^(NSString *string) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.string = string;
        return newChainLink;
    };

    return [stringBlock copy];
}

- (RZChainLinkImage)image
{
    RZChainLinkImage imageBlock = ^(UIImage *image) {
        typeof(self) newChainLink = self.copy;
        newChainLink.manuscript.image = image;
        return newChainLink;
    };
    
    return [imageBlock copy];
}

- (RZChainLinkAppend)append
{
    RZChainLinkAppend appendBlock = ^(id chainLinkOrManuscript) {
        RZManuscript *manuscriptToAppend = nil;
        if ( [chainLinkOrManuscript isKindOfClass:[RZChainLink class]] ) {
            manuscriptToAppend = [chainLinkOrManuscript manuscript];
        }
        else if ( [chainLinkOrManuscript isKindOfClass:[RZManuscript class]] ) {
            manuscriptToAppend = chainLinkOrManuscript;
        }
        else {
            NSAssert(NO, @"Expected chainLinkOrManuscript to be of class RZChainLink or RZManuscript, but it was of type %@: %@", [chainLinkOrManuscript class], chainLinkOrManuscript);
        }
        self.manuscript.nextManuscript = manuscriptToAppend.copy;
        __typeof(self) newChainLink = [[self.class alloc] init];
        newChainLink.manuscript = self.manuscript.nextManuscript;
        return newChainLink;
    };

    return [appendBlock copy];
}

@end
