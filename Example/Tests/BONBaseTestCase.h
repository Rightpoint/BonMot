//
//  BONBaseTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 7/10/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

@import XCTest;

OBJC_EXTERN NSValue *BONValueFromRange(NSUInteger location, NSUInteger length);

/**
 *  Uses XCTest assertions to check that the attributes of @c attributedString match the attributes and ranges in @c controlAttributes.
 *
 *  @param attributedString  The attributed string to validate.
 *  @param controlAttributes A dictionary whose keys are @c NSValue objects containing @c NSRange structs, and whose values are attributes dictionaries.
 */
#define BONAssertAttributedStringHasAttributes(attributedString, controlAttributes) \
NSMutableDictionary *mutableControlAttributes = controlAttributes.mutableCopy; \
[attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) { \
    NSValue *testRangeValue = [NSValue valueWithRange:range]; \
    NSDictionary *controlAttrs = controlAttributes[testRangeValue]; \
    XCTAssertNotNil(controlAttrs, @"Attributed String had attributes that were not accounted for at %@: %@", NSStringFromRange(range), attrs); \
    XCTAssertEqualObjects(attrs, controlAttrs); \
    [mutableControlAttributes removeObjectForKey:testRangeValue]; \
}]; \
XCTAssertEqual(mutableControlAttributes.count, 0, @"Some attributes not found in string: %@", controlAttributes); \

@interface BONBaseTestCase : XCTestCase

@end
