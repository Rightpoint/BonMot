//
//  BONChainLink.m
//  Pods
//
//  Created by Zev Eisenberg on 4/24/15.
//
//

#import "BONChainLink.h"

#import <BonMot/BONTextConfiguration.h>

@interface BONChainLink ()

@property (strong, nonatomic) BONTextConfiguration *textConfiguration;

@end

@implementation BONChainLink

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _textConfiguration = [[BONTextConfiguration alloc] init];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    __typeof(self) chainLink = [[self.class alloc] init];
    chainLink.textConfiguration = self.textConfiguration.copy;
    return chainLink;
}

- (NSAttributedString *)attributedString
{
    return self.textConfiguration.attributedString;
}

- (NSDictionary *)attributes
{
    return self.textConfiguration.attributes;
}

- (BONChainLinkFontNameAndSize)fontNameAndSize
{
    BONChainLinkFontNameAndSize fontNameAndSizeBlock = ^(NSString *fontName, CGFloat fontSize) {
        typeof(self) newChainLink = self.copy;
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        NSAssert(font, @"No font returned from [UIFont fontWithName:%@ size:%@]", fontName, @(fontSize));
        newChainLink.textConfiguration.font = font;
        return newChainLink;
    };

    return [fontNameAndSizeBlock copy];
}

- (BONChainLinkFont)font
{
    BONChainLinkFont fontBlock = ^(UIFont *font) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.font = font;
        return newChainLink;
    };

    return [fontBlock copy];
}

- (BONChainLinkColor)textColor
{
    BONChainLinkColor colorBlock = ^(UIColor *color) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.textColor = color;
        return newChainLink;
    };

    return [colorBlock copy];
}

- (BONChainLinkColor)backgroundColor
{
    BONChainLinkColor colorBlock = ^(UIColor *color) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.backgroundColor = color;
        return newChainLink;
    };

    return [colorBlock copy];
}

- (BONChainLinkAdobeTracking)adobeTracking
{
    BONChainLinkAdobeTracking adobeTrackingBlock = ^(NSInteger adobeTracking) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.adobeTracking = adobeTracking;
        newChainLink.textConfiguration.pointTracking = 0.0f;
        return newChainLink;
    };

    return [adobeTrackingBlock copy];
}

- (BONChainLinkPointTracking)pointTracking
{
    BONChainLinkPointTracking pointTrackingBlock = ^(CGFloat pointTracking) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.pointTracking = pointTracking;
        newChainLink.textConfiguration.adobeTracking = 0;
        return newChainLink;
    };

    return [pointTrackingBlock copy];
}

- (BONChainLinkLineHeight)lineHeightMultiple
{
    BONChainLinkLineHeight lineHeightMultipleBlock = ^(CGFloat lineHeightMultiple) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.lineHeightMultiple = lineHeightMultiple;
        return newChainLink;
    };

    return [lineHeightMultipleBlock copy];
}

- (BONChainLinkBaselineOffset)baselineOffset
{
    BONChainLinkBaselineOffset baselineOffsetBlock = ^(CGFloat baselineOffset) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.baselineOffset = baselineOffset;
        return newChainLink;
    };

    return [baselineOffsetBlock copy];
}

- (BONChainLinkFigureCase)figureCase
{
    BONChainLinkFigureCase figureCaseBlock = ^(RZFigureCase figureCase) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.figureCase = figureCase;
        return newChainLink;
    };

    return [figureCaseBlock copy];
}

- (BONChainLinkFigureSpacing)figureSpacing
{
    BONChainLinkFigureSpacing figureSpacingBlock = ^(RZFigureSpacing figureSpacing) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.figureSpacing = figureSpacing;
        return newChainLink;
    };

    return [figureSpacingBlock copy];
}

- (BONChainLinkString)string
{
    BONChainLinkString stringBlock = ^(NSString *string) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.string = string;
        return newChainLink;
    };

    return [stringBlock copy];
}

- (BONChainLinkImage)image
{
    BONChainLinkImage imageBlock = ^(UIImage *image) {
        typeof(self) newChainLink = self.copy;
        newChainLink.textConfiguration.image = image;
        return newChainLink;
    };
    
    return [imageBlock copy];
}

- (BONChainLinkAppend)append
{
    BONChainLinkAppend appendBlock = ^(id chainLinkOrTextConfiguration) {
        BONTextConfiguration *textConfigurationToAppend = nil;
        if ( [chainLinkOrTextConfiguration isKindOfClass:[BONChainLink class]] ) {
            textConfigurationToAppend = [chainLinkOrTextConfiguration textConfiguration];
        }
        else if ( [chainLinkOrTextConfiguration isKindOfClass:[BONTextConfiguration class]] ) {
            textConfigurationToAppend = chainLinkOrTextConfiguration;
        }
        else {
            NSAssert(NO, @"Expected chainLinkOrTextConfiguration to be of class BONChainLink or BONTextConfiguration, but it was of type %@: %@", [chainLinkOrTextConfiguration class], chainLinkOrTextConfiguration);
        }
        self.textConfiguration.nextTextConfiguration = textConfigurationToAppend.copy;
        __typeof(self) newChainLink = [[self.class alloc] init];
        newChainLink.textConfiguration = self.textConfiguration.nextTextConfiguration;
        return newChainLink;
    };

    return [appendBlock copy];
}

- (BONChainLinkAppendWithSeparator)appendWithSeparator
{
    BONChainLinkAppendWithSeparator appendBlock = ^(NSString *separator, id chainLinkOrTextConfiguration) {
        self.textConfiguration.trailingString = separator;
        BONTextConfiguration *textConfigurationToAppend = nil;
        if ( [chainLinkOrTextConfiguration isKindOfClass:[BONChainLink class]] ) {
            textConfigurationToAppend = [chainLinkOrTextConfiguration textConfiguration];
        }
        else if ( [chainLinkOrTextConfiguration isKindOfClass:[BONTextConfiguration class]] ) {
            textConfigurationToAppend = chainLinkOrTextConfiguration;
        }
        else {
            NSAssert(NO, @"Expected chainLinkOrTextConfiguration to be of class BONChainLink or BONTextConfiguration, but it was of type %@: %@", [chainLinkOrTextConfiguration class], chainLinkOrTextConfiguration);
        }
        self.textConfiguration.nextTextConfiguration = textConfigurationToAppend.copy;
        __typeof(self) newChainLink = [[self.class alloc] init];
        newChainLink.textConfiguration = self.textConfiguration.nextTextConfiguration;
        return newChainLink;
    };

    return [appendBlock copy];
}

@end
