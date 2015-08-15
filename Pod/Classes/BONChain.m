//
//  BONChain.m
//  Pods
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

#import "BONChain.h"

#import "BONText.h"
#import "BONText_Private.h"

@interface BONChain ()

@property (strong, nonatomic) BONText *text;

@end

@implementation BONChain

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
    __typeof(self) chain = [[self.class alloc] init];
    chain.text = self.text.copy;
    return chain;
}

- (NSAttributedString *)attributedString
{
    return self.text.attributedString;
}

- (NSDictionary *)attributes
{
    return self.text.attributes;
}

- (BONChainFontNameAndSize)fontNameAndSize
{
    BONChainFontNameAndSize fontNameAndSizeBlock = ^(NSString *fontName, CGFloat fontSize) {
        typeof(self) newChain = self.copy;
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        NSAssert(font, @"No font returned from [UIFont fontWithName:%@ size:%@]", fontName, @(fontSize));
        newChain.text.font = font;
        return newChain;
    };

    return [fontNameAndSizeBlock copy];
}

- (BONChainFont)font
{
    BONChainFont fontBlock = ^(UIFont *font) {
        typeof(self) newChain = self.copy;
        newChain.text.font = font;
        return newChain;
    };

    return [fontBlock copy];
}

- (BONChainColor)textColor
{
    BONChainColor colorBlock = ^(UIColor *color) {
        typeof(self) newChain = self.copy;
        newChain.text.textColor = color;
        return newChain;
    };

    return [colorBlock copy];
}

- (BONChainColor)backgroundColor
{
    BONChainColor colorBlock = ^(UIColor *color) {
        typeof(self) newChain = self.copy;
        newChain.text.backgroundColor = color;
        return newChain;
    };

    return [colorBlock copy];
}

- (BONChainAdobeTracking)adobeTracking
{
    BONChainAdobeTracking adobeTrackingBlock = ^(NSInteger adobeTracking) {
        typeof(self) newChain = self.copy;
        newChain.text.adobeTracking = adobeTracking;
        newChain.text.pointTracking = 0.0f;
        return newChain;
    };

    return [adobeTrackingBlock copy];
}

- (BONChainPointTracking)pointTracking
{
    BONChainPointTracking pointTrackingBlock = ^(CGFloat pointTracking) {
        typeof(self) newChain = self.copy;
        newChain.text.pointTracking = pointTracking;
        newChain.text.adobeTracking = 0;
        return newChain;
    };

    return [pointTrackingBlock copy];
}

- (BONChainLineHeight)lineHeightMultiple
{
    BONChainLineHeight lineHeightMultipleBlock = ^(CGFloat lineHeightMultiple) {
        typeof(self) newChain = self.copy;
        newChain.text.lineHeightMultiple = lineHeightMultiple;
        return newChain;
    };

    return [lineHeightMultipleBlock copy];
}

- (BONChainBaselineOffset)baselineOffset
{
    BONChainBaselineOffset baselineOffsetBlock = ^(CGFloat baselineOffset) {
        typeof(self) newChain = self.copy;
        newChain.text.baselineOffset = baselineOffset;
        return newChain;
    };

    return [baselineOffsetBlock copy];
}

- (BONChainFigureCase)figureCase
{
    BONChainFigureCase figureCaseBlock = ^(BONFigureCase figureCase) {
        typeof(self) newChain = self.copy;
        newChain.text.figureCase = figureCase;
        return newChain;
    };

    return [figureCaseBlock copy];
}

- (BONChainFigureSpacing)figureSpacing
{
    BONChainFigureSpacing figureSpacingBlock = ^(BONFigureSpacing figureSpacing) {
        typeof(self) newChain = self.copy;
        newChain.text.figureSpacing = figureSpacing;
        return newChain;
    };

    return [figureSpacingBlock copy];
}

- (BONChainString)string
{
    BONChainString stringBlock = ^(NSString *string) {
        typeof(self) newChain = self.copy;
        newChain.text.string = string;
        return newChain;
    };

    return [stringBlock copy];
}

- (BONChainImage)image
{
    BONChainImage imageBlock = ^(UIImage *image) {
        typeof(self) newChain = self.copy;
        newChain.text.image = image;
        return newChain;
    };
    
    return [imageBlock copy];
}

- (BONChainAppend)append
{
    BONChainAppend appendBlock = ^(id chainOrText) {
        BONText *textToAppend = nil;
        if ( [chainOrText isKindOfClass:[BONChain class]] ) {
            textToAppend = [(BONChain *)chainOrText text];
        }
        else if ( [chainOrText isKindOfClass:[BONText class]] ) {
            textToAppend = chainOrText;
        }
        else {
            NSAssert(NO, @"Expected chainOrText to be of class BONChain or BONText, but it was of type %@: %@", [chainOrText class], chainOrText);
        }
        self.text.nextText = textToAppend.copy;
        __typeof(self) newChain = [[self.class alloc] init];
        newChain.text = self.text.nextText;
        return newChain;
    };

    return [appendBlock copy];
}

- (BONChainAppendWithSeparator)appendWithSeparator
{
    BONChainAppendWithSeparator appendBlock = ^(NSString *separator, id chainOrText) {
        self.text.trailingString = separator;
        self.text.internalIndentSpacer = nil;
        BONText *textToAppend = nil;
        if ( [chainOrText isKindOfClass:[BONChain class]] ) {
            textToAppend = [(BONChain *)chainOrText text];
        }
        else if ( [chainOrText isKindOfClass:[BONText class]] ) {
            textToAppend = chainOrText;
        }
        else {
            NSAssert(NO, @"Expected chainOrText to be of class BONChain or BONText, but it was of type %@: %@", [chainOrText class], chainOrText);
        }
        self.text.nextText = textToAppend.copy;
        __typeof(self) newChain = [[self.class alloc] init];
        newChain.text = self.text.nextText;
        return newChain;
    };

    return [appendBlock copy];
}

- (BONChainIndentSpacer)indentSpacer
{
    BONChainIndentSpacer indentSpacerBlock = ^(CGFloat indentSpacer) {
        NSAssert(indentSpacer > 0.0f, @"Indent spacer values must be greater than zero. Received %@", @(indentSpacer));
        typeof(self) newChain = self.copy;
        newChain.text.indentSpacer = indentSpacer;
        newChain.text.trailingString = nil;
        return newChain;
    };

    return [indentSpacerBlock copy];
}

@end
