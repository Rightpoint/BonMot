//
//  BONTag.h
//  BonMot
//
//  Created by Nora Trapp on 5/11/16.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BONCompatibility.h"

@protocol BONTextable;

@interface BONTag : NSObject <NSCopying>

@property (copy, nonatomic, readonly, BONNonnull) NSString *startTag;
@property (copy, nonatomic, readonly, BONNonnull) NSString *endTag;
@property (copy, nonatomic, readonly, BONNonnull) NSString *escapeString;
@property (copy, nonatomic, readonly, BONNonnull) id<BONTextable> textable;

- (BONNonnull instancetype)initWithStartTag:(BONNonnull NSString *)startTag endTag:(BONNonnull NSString *)endTag escapeString:(BONNonnull NSString *)escapeString textable:(BONNonnull id<BONTextable>)textable;
- (BONNonnull instancetype)initWithTag:(BONNonnull NSString *)tag textable:(BONNonnull id<BONTextable>)textable;

@end

/**
 *  Create a tag with a custom start/end/escape combination.
 *
 *  @param startTag     The start tag.
 *  @param endTag       The end tag.
 *  @param escapeString The escape string.
 *  @param textable     The style to apply.
 *
 *  @return A @p BONTag instance representing the tag.
 */
NS_INLINE BONTag *BONCNonnull BONTagComplexMake(NSString *BONCNonnull startTag, NSString *BONCNonnull endTag, NSString *BONCNonnull escapeString, id<BONTextable> BONCNonnull textable) NS_SWIFT_UNAVAILABLE("Use BONTag(startTag:endTag:escapeString:textable:)")
{
    return [[BONTag alloc] initWithStartTag:startTag endTag:endTag escapeString:escapeString textable:textable];
}

/**
 *  Create a tag using the default start and end formats and using \ as an escape character. Example:
 *  @code
 *  <tagName>Normal String</tagName>
 *  <tagName>String with escaped \</tagName></tagName>
 *  @endcode
 *
 *  @param tag       The tag string.
 *  @param textable  The style to apply.
 *
 *  @return A @p BONTag instance representing the tag.
 */
NS_INLINE BONTag *BONCNonnull BONTagMake(NSString *BONCNonnull tag, id<BONTextable> BONCNonnull textable) NS_SWIFT_UNAVAILABLE("Use BONTag(tag:textable:)")
{
    return [[BONTag alloc] initWithTag:tag textable:textable];
}

/**
 *  Create an array of tag objects from a dictionary of ["tag": textable]
 *
 *  @param dictionary A dictionary of tags mapped to textables.
 *
 *  @return An array of @p BONTag objects representing the tags in the dictionary.
 */
NS_INLINE BONGeneric(NSArray, BONTag *) * BONCNonnull BONTagsFromDictionary(BONGeneric(NSDictionary, NSString *, id<BONTextable>) * BONCNonnull dictionary)
{
    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *key in dictionary) {
        id<BONTextable> textable = dictionary[key];
        [tags addObject:BONTagMake(key, textable)];
    }
    return tags;
}
