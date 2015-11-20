//
//  BONTextAlignmentConstraint.h
//  Pods
//
//  Created by Zev Eisenberg on 5/2/15.
//
//

@import UIKit;

typedef NS_ENUM(NSUInteger, BONConstraintAttribute) {
    BONConstraintAttributeUnspecified = 0,
    BONConstraintAttributeTop,
    BONConstraintAttributeCapHeight,
    BONConstraintAttributeXHeight,
    BONConstraintAttributeFirstBaseline,
    BONConstraintAttributeLastBaseline,
    BONConstraintAttributeBottom,
};

NSString *stringFromBONConstraintAttribute(BONConstraintAttribute attribute);
BONConstraintAttribute BONConstraintAttributeFromString(NSString *string);

@interface BONTextAlignmentConstraint : NSLayoutConstraint

@property (nonatomic) BONConstraintAttribute firstItemBONAttribute;
@property (nonatomic) BONConstraintAttribute secondItemBONAttribute;

@property (copy, nonatomic) IBInspectable NSString *firstAlignment;
@property (copy, nonatomic) IBInspectable NSString *secondAlignment;

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(BONConstraintAttribute)attr1
                         relatedBy:(NSLayoutRelation)relation
                            toItem:(id)view2
                         attribute:(BONConstraintAttribute)attr2;

@end
