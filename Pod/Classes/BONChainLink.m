//
//  BONChainLink.m
//  Pods
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

#import "BONChainLink.h"

#import <BonMot/BONText.h>

@interface BONChainLink ()

@property (strong, nonatomic) BONText *text;

@end

@implementation BONChainLink

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _text = [[BONText alloc] init];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) chainLink = [[self.class alloc] init];
    chainLink.text = self.text.copy;
    return chainLink;
}

- (NSAttributedString *)attributedString
{
    return self.text.attributedString;
}

- (NSDictionary *)attributes
{
    return self.text.attributes;
}

- (BONChainLinkFontNameAndSize)fontNameAndSize
{
    BONChainLinkFontNameAndSize fontNameAndSizeBlock = ^(NSString *fontName, CGFloat fontSize) {
        typeof(self) newChainLink = self.copy;
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        NSAssert(font, @"No font returned from [UIFont fontWithName:%@ size:%@]", fontName, @(fontSize));
        newChainLink.text.font = font;
        return newChainLink;
    };

    return [fontNameAndSizeBlock copy];
}

- (BONChainLinkFont)font
{
    BONChainLinkFont fontBlock = ^(UIFont *font) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.font = font;
        return newChainLink;
    };

    return [fontBlock copy];
}

- (BONChainLinkColor)textColor
{
    BONChainLinkColor colorBlock = ^(UIColor *color) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.textColor = color;
        return newChainLink;
    };

    return [colorBlock copy];
}

- (BONChainLinkColor)backgroundColor
{
    BONChainLinkColor colorBlock = ^(UIColor *color) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.backgroundColor = color;
        return newChainLink;
    };

    return [colorBlock copy];
}

- (BONChainLinkAdobeTracking)adobeTracking
{
    BONChainLinkAdobeTracking adobeTrackingBlock = ^(NSInteger adobeTracking) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.adobeTracking = adobeTracking;
        newChainLink.text.pointTracking = 0.0f;
        return newChainLink;
    };

    return [adobeTrackingBlock copy];
}

- (BONChainLinkPointTracking)pointTracking
{
    BONChainLinkPointTracking pointTrackingBlock = ^(CGFloat pointTracking) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.pointTracking = pointTracking;
        newChainLink.text.adobeTracking = 0;
        return newChainLink;
    };

    return [pointTrackingBlock copy];
}

- (BONChainLinkLineHeight)lineHeightMultiple
{
    BONChainLinkLineHeight lineHeightMultipleBlock = ^(CGFloat lineHeightMultiple) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.lineHeightMultiple = lineHeightMultiple;
        return newChainLink;
    };

    return [lineHeightMultipleBlock copy];
}

- (BONChainLinkBaselineOffset)baselineOffset
{
    BONChainLinkBaselineOffset baselineOffsetBlock = ^(CGFloat baselineOffset) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.baselineOffset = baselineOffset;
        return newChainLink;
    };

    return [baselineOffsetBlock copy];
}

- (BONChainLinkFigureCase)figureCase
{
    BONChainLinkFigureCase figureCaseBlock = ^(RZFigureCase figureCase) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.figureCase = figureCase;
        return newChainLink;
    };

    return [figureCaseBlock copy];
}

- (BONChainLinkFigureSpacing)figureSpacing
{
    BONChainLinkFigureSpacing figureSpacingBlock = ^(RZFigureSpacing figureSpacing) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.figureSpacing = figureSpacing;
        return newChainLink;
    };

    return [figureSpacingBlock copy];
}

- (BONChainLinkString)string
{
    BONChainLinkString stringBlock = ^(NSString *string) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.string = string;
        return newChainLink;
    };

    return [stringBlock copy];
}

- (BONChainLinkImage)image
{
    BONChainLinkImage imageBlock = ^(UIImage *image) {
        typeof(self) newChainLink = self.copy;
        newChainLink.text.image = image;
        return newChainLink;
    };
    
    return [imageBlock copy];
}

- (BONChainLinkAppend)append
{
    BONChainLinkAppend appendBlock = ^(id chainLinkOrText) {
        BONText *textToAppend = nil;
        if ( [chainLinkOrText isKindOfClass:[BONChainLink class]] ) {
            textToAppend = [(BONChainLink *)chainLinkOrText text];
        }
        else if ( [chainLinkOrText isKindOfClass:[BONText class]] ) {
            textToAppend = chainLinkOrText;
        }
        else {
            NSAssert(NO, @"Expected chainLinkOrText to be of class BONChainLink or BONText, but it was of type %@: %@", [chainLinkOrText class], chainLinkOrText);
        }
        self.text.nextText = textToAppend.copy;
        __typeof(self) newChainLink = [[self.class alloc] init];
        newChainLink.text = self.text.nextText;
        return newChainLink;
    };

    return [appendBlock copy];
}

- (BONChainLinkAppendWithSeparator)appendWithSeparator
{
    BONChainLinkAppendWithSeparator appendBlock = ^(NSString *separator, id chainLinkOrText) {
        self.text.trailingString = separator;
        BONText *textToAppend = nil;
        if ( [chainLinkOrText isKindOfClass:[BONChainLink class]] ) {
            textToAppend = [(BONChainLink *)chainLinkOrText text];
        }
        else if ( [chainLinkOrText isKindOfClass:[BONText class]] ) {
            textToAppend = chainLinkOrText;
        }
        else {
            NSAssert(NO, @"Expected chainLinkOrText to be of class BONChainLink or BONText, but it was of type %@: %@", [chainLinkOrText class], chainLinkOrText);
        }
        self.text.nextText = textToAppend.copy;
        __typeof(self) newChainLink = [[self.class alloc] init];
        newChainLink.text = self.text.nextText;
        return newChainLink;
    };

    return [appendBlock copy];
}

@end
