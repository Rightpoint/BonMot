//
//  BONTextAlignmentConstraint.h
//  BonMot
//
//  Created by Zev Eisenberg on 5/2/15.
//
//

@import UIKit;

#import "BONCompatibility.h"

typedef NS_ENUM(NSUInteger, BONConstraintAttribute) {
    BONConstraintAttributeUnspecified = 0,
    BONConstraintAttributeTop,
    BONConstraintAttributeCapHeight,
    BONConstraintAttributeXHeight,
    BONConstraintAttributeFirstBaseline,
    BONConstraintAttributeLastBaseline,
    BONConstraintAttributeBottom,
};

NSString *BONCNonnull stringFromBONConstraintAttribute(BONConstraintAttribute attribute);
BONConstraintAttribute BONConstraintAttributeFromString(NSString *BONCNonnull string);

@interface BONTextAlignmentConstraint : NSLayoutConstraint

@property (nonatomic) BONConstraintAttribute firstItemBONAttribute;
@property (nonatomic) BONConstraintAttribute secondItemBONAttribute;

@property (copy, nonatomic, BONNullable) IBInspectable NSString *firstAlignment;
@property (copy, nonatomic, BONNullable) IBInspectable NSString *secondAlignment;

+ (BONNonnull instancetype)constraintWithItem:(BONNonnull id)view1
                                    attribute:(BONConstraintAttribute)attr1
                                    relatedBy:(NSLayoutRelation)relation
                                       toItem:(BONNonnull id)view2
                                    attribute:(BONConstraintAttribute)attr2;

@end
