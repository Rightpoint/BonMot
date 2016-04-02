//
//  BONChain_Private.h
//  BonMot
//
//  Created by Zev Eisenberg on 4/1/16.
//
//

#import "BONChain.h"
#import "BONCompatibility.h"
#import "BONText.h"

@interface BONChain ()

/**
 *  The @c BONText that backs @c BONChain.
 */
@property (BONNonnull, strong, nonatomic, readwrite) BONText *text;

@end
