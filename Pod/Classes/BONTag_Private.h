//
//  BONTag_Private.h
//  BonMot
//
//  Created by Nora Trapp on 5/11/16.
//  Copyright © 2015 Zev Eisenberg. All rights reserved.
//

#import "BONTag.h"

@interface BONTag ()

@property (strong, nonatomic, BONNonnull) BONGeneric(NSMutableArray, NSValue *) * ranges;

/**
 *  Finds all escaped tags within a given string.
 *
 *  @param string                The @p string to search. The @p string will be mutated to strip escape characters.
 *  @param tags                  The tags to search for.
 *
 *  @return An array of ranges representing the escaped tags.
 */
+ (BONNonnull BONGeneric(NSArray, NSValue *) *)escapedRangesInString:(NSString *BONCNonnull *BONCNonnull)string withTags:(BONNonnull BONGeneric(NSArray, BONTag *) *)tags;

/**
 *  Search through a string to find the next matching string that is not in an escaped range.
 *
 *  @param string         The string to look for.
 *  @param stringToSearch The string to search within.
 *  @param escapedRanges  The ranges to ignore matches within.
 *  @param range          The range of @p string to search.
 *
 *  @return The range of the matched string. If the string is not found, location will be @p NSNotFound.
 */
+ (NSRange)firstOccurrenceOfString:(BONNonnull NSString *)string inString:(BONNonnull NSString *)stringToSearch ignoringRanges:(BONNonnull BONGeneric(NSArray, NSValue *) *)escapedRanges inRange:(NSRange)range;

/**
 *  Find all tagged strings within a given string.
 *
 *  @param string    The @p string to search. The @p string will be mutated to strip valid tags.
 *  @param tags      The tags to search for.
 *
 *  @return An array of tags with the matching ranges defined.
 */
+ (BONNonnull BONGeneric(NSArray, BONTag *) *)rangesInString:(NSString *BONCNonnull *BONCNonnull)string betweenTags:(BONNonnull BONGeneric(NSArray, BONTag *) *)tags;

@end
