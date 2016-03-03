//
//  UITextField+BonMotUtilities.h
//  BonMot
//
//  Created by Nora Trapp on 3/2/16.
//
//

@import UIKit;
@protocol BONChainable;

@interface UITextField (BonMotUtilities)

/**
 *  Assign a @p BONChainable object to apply to the label text. When a new value is assigned to @p text the chain attributes will be applied.
 *  If a new value is assigned directly to @p attributedText the @p bonChainable property will be set to @p nil.
 */
@property (copy, nonatomic) id<BONChainable> bonChainable;

@end
