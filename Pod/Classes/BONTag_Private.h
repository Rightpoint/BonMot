//
//  BONTag_Private.h
//  Pods
//
//  Created by Nora Trapp on 5/11/16.
//
//

#import "BONTag.h"

@interface BONTag ()

@property (strong, nonatomic, BONNonnull) BONGeneric(NSMutableArray, NSValue *) * ranges;

/**
 *  Finds all escaped tags within a given string.
 *
 *  @param string                The string to search.
 *  @param tags                  The tags to search for.
 *  @param stripEscapeCharacters If YES, the escape characters will be removed from the string and the resulting ranges.
 *
 *  @return An array of ranges representing the escaped tags.
 */
+ (BONNonnull BONGeneric(NSArray, NSValue *) *)escapedRangesInString:(NSString *BONCNonnull *BONCNonnull)string withTags:(BONNonnull BONGeneric(NSArray, BONTag *) *)tags stripEscapeCharacters:(BOOL)stripEscapeCharacters;

/**
 *  Search through a string to find the next matching string that is not in an escaped range.
 *
 *  @param string         The string to look for.
 *  @param stringToSearch The string to search within.
 *  @param escapedRanges  The ranges to ignore matches within.
 *  @param range          The range of @p string to search within.
 *
 *  @return The range of the matched string. If the string is not found, location will be NSNotFound.
 */
+ (NSRange)findNextString:(BONNonnull NSString *)string inString:(BONNonnull NSString *)stringToSearch ignoringRanges:(BONNonnull BONGeneric(NSArray, NSValue *) *)escapedRanges range:(NSRange)range;

/**
 *  Find all tagged strings within a given string.
 *
 *  @param string    The string to search.
 *  @param tags      The tags to search for.
 *  @param stripTags If YES, the start and end tags will be stripped from the string and the resulting ranges.
 *
 *  @return An array of tags with the matching ranges defined.
 */
+ (BONNonnull BONGeneric(NSArray, BONTag *) *)rangesInString:(NSString *BONCNonnull *BONCNonnull)string betweenTags:(BONNonnull BONGeneric(NSArray, BONTag *) *)tags stripTags:(BOOL)stripTags;

@end
