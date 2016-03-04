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

@property (copy, nonatomic) IBInspectable NSString *_Nullable firstAlignment;
@property (copy, nonatomic) IBInspectable NSString *_Nullable secondAlignment;

+ (instancetype _Nonnull)constraintWithItem:(id _Nonnull)view1
                                  attribute:(BONConstraintAttribute)attr1
                                  relatedBy:(NSLayoutRelation)relation
                                     toItem:(id _Nonnull)view2
                                  attribute:(BONConstraintAttribute)attr2;

@end
