//
//  BONTextable.h
//  BonMot
//
//  Created by Zev Eisenberg on 10/9/15.
//
//

@import Foundation;

#import "BONCompatibility.h"

@class BONText;

BON_ASSUME_NONNULL_BEGIN

/**
 *  Objects conforming to this protocol can be used in BonMot chaining operations.
 */
@protocol BONTextable <NSObject, NSCopying>

@property (strong, nonatomic, readonly) BONText *text;

@end

BON_ASSUME_NONNULL_END
