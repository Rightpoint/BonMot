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

@property (strong, nonatomic, readwrite) BONText *text;
@property (strong, nonatomic, readonly) BONChain *copyWithoutNextText;

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

- (instancetype)copyWithoutNextText
{
    __typeof(self) copy = self.copy;
    copy.text.nextText = nil;
    return copy;
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
        typeof(self) newChain = self.copyWithoutNextText;
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
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.font = font;
        return newChain;
    };

    return [fontBlock copy];
}

- (BONChainColor)textColor
{
    BONChainColor colorBlock = ^(UIColor *color) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.textColor = color;
        return newChain;
    };

    return [colorBlock copy];
}

- (BONChainColor)backgroundColor
{
    BONChainColor colorBlock = ^(UIColor *color) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.backgroundColor = color;
        return newChain;
    };

    return [colorBlock copy];
}

- (BONChainAdobeTracking)adobeTracking
{
    BONChainAdobeTracking adobeTrackingBlock = ^(NSInteger adobeTracking) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.adobeTracking = adobeTracking;
        return newChain;
    };

    return [adobeTrackingBlock copy];
}

- (BONChainPointTracking)pointTracking
{
    BONChainPointTracking pointTrackingBlock = ^(CGFloat pointTracking) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.pointTracking = pointTracking;
        return newChain;
    };

    return [pointTrackingBlock copy];
}

- (BONChainLineHeight)lineHeightMultiple
{
    BONChainLineHeight lineHeightMultipleBlock = ^(CGFloat lineHeightMultiple) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.lineHeightMultiple = lineHeightMultiple;
        return newChain;
    };

    return [lineHeightMultipleBlock copy];
}

- (BONChainBaselineOffset)baselineOffset
{
    BONChainBaselineOffset baselineOffsetBlock = ^(CGFloat baselineOffset) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.baselineOffset = baselineOffset;
        return newChain;
    };

    return [baselineOffsetBlock copy];
}

- (BONChainFigureCase)figureCase
{
    BONChainFigureCase figureCaseBlock = ^(BONFigureCase figureCase) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.figureCase = figureCase;
        return newChain;
    };

    return [figureCaseBlock copy];
}

- (BONChainFigureSpacing)figureSpacing
{
    BONChainFigureSpacing figureSpacingBlock = ^(BONFigureSpacing figureSpacing) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.figureSpacing = figureSpacing;
        return newChain;
    };

    return [figureSpacingBlock copy];
}

- (BONChainString)string
{
    BONChainString stringBlock = ^(NSString *string) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.string = string;
        return newChain;
    };

    return [stringBlock copy];
}

- (BONChainImage)image
{
    BONChainImage imageBlock = ^(UIImage *image) {
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.image = image;
        return newChain;
    };

    return [imageBlock copy];
}

- (BONChainIndentSpacer)indentSpacer
{
    BONChainIndentSpacer indentSpacerBlock = ^(CGFloat indentSpacer) {
        NSAssert(indentSpacer > 0.0f, @"Indent spacer values must be greater than zero. Received %@", @(indentSpacer));
        typeof(self) newChain = self.copyWithoutNextText;
        newChain.text.indentSpacer = indentSpacer;
        return newChain;
    };

    return [indentSpacerBlock copy];
}

- (void)appendLink:(id<BONChainable>)link
{
    [self appendLink:link separator:nil];
}

- (void)appendLink:(id<BONChainable>)link separator:(NSString *)separator
{
    if (separator.length > 0) {
        // Recursion!
        [self appendLink:self.string(separator)]; // add the sparator, with the same properties as self, to the end of the chain.
    }

    [self.class appendText:link.text toEndOfText:self.text];
}

#pragma mark - Private

+ (void)appendText:(BONText *)suffix toEndOfText:(BONText *)prefix
{
    if (prefix.nextText) {
        // Recursion!
        [self appendText:suffix toEndOfText:prefix.nextText];
    }
    else {
        prefix.nextText = suffix;
    }
}

@end
