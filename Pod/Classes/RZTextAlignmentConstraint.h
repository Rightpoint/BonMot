//
//  RZTextAlignmentConstraint.h
//  Pods
//
//  Created by Zev Eisenberg on 5/2/15.
//
//

@import UIKit;

typedef NS_ENUM(NSUInteger, RZConstraintAttribute) {
    RZConstraintAttributeUnspecified = 0,
    RZConstraintAttributeTop,
    RZConstraintAttributeCapHeight,
    RZConstraintAttributeXHeight,
    RZConstraintAttributeFirstBaseline,
    RZConstraintAttributeLastBaseline,
    RZConstraintAttributeBottom,
};

NSString *stringFromRZConstraintAttribute(RZConstraintAttribute attribute);
RZConstraintAttribute RZConstraintAttributeFromString(NSString *string);

@interface RZTextAlignmentConstraint : NSLayoutConstraint

@property (nonatomic) RZConstraintAttribute firstItemRZAttribute;
@property (nonatomic) RZConstraintAttribute secondItemRZAttribute;

@property (copy, nonatomic) IBInspectable NSString *firstAlignment;
@property (copy, nonatomic) IBInspectable NSString *secondAlignment;

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(RZConstraintAttribute)attr1
                         relatedBy:(NSLayoutRelation)relation
                            toItem:(id)view2
                         attribute:(RZConstraintAttribute)attr2;

@end
