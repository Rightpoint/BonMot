//
//  BONBaseTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 7/10/15.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"

@import CoreText.CTFontManager;

NSValue *BONValueFromRange(NSUInteger location, NSUInteger length)
{
    NSRange range = NSMakeRange(location, length);
    NSValue *value = [NSValue valueWithRange:range];
    return value;
}

@implementation BONBaseTestCase : XCTestCase

+ (void)loadEBGaramondFont
{
    // Can't include font the normal (Plist) way for logic tests, so load it the hard way
    // Source: http://stackoverflow.com/questions/14735522/can-i-embed-a-custom-font-in-a-bundle-and-access-it-from-an-ios-framework
    // Method: https://marco.org/2012/12/21/ios-dynamic-font-loading
    NSError *fontError;
    NSString *fontPath = [[NSBundle bundleForClass:[DummyAssetClass class]] pathForResource:@"EBGaramond12-Regular" ofType:@"otf"];
    NSData *garamondData = [NSData dataWithContentsOfFile:fontPath options:0 error:&fontError];
    if (!garamondData) {
        NSAssert(NO, @"Error loading font file: %@", fontError);
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)garamondData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);

    CFErrorRef fontManagerError;
    if (!CTFontManagerRegisterGraphicsFont(font, &fontManagerError)) {
        CFStringRef errorDescription = CFErrorCopyDescription(fontManagerError);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}

@end
