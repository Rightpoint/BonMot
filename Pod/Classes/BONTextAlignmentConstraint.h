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

NSString *_Nonnull stringFromBONConstraintAttribute(BONConstraintAttribute attribute);
BONConstraintAttribute BONConstraintAttributeFromString(NSString *_Nonnull string);

@interface BONTextAlignmentConstraint : NSLayoutConstraint

@property (nonatomic) BONConstraintAttribute firstItemBONAttribute;
@property (nonatomic) BONConstraintAttribute secondItemBONAttribute;

@property (copy, nonatomic, nullable) IBInspectable NSString *firstAlignment;
@property (copy, nonatomic, nullable) IBInspectable NSString *secondAlignment;

+ (nonnull instancetype)constraintWithItem:(nonnull id)view1
                                 attribute:(BONConstraintAttribute)attr1
                                 relatedBy:(NSLayoutRelation)relation
                                    toItem:(nonnull id)view2
                                 attribute:(BONConstraintAttribute)attr2;

@end
