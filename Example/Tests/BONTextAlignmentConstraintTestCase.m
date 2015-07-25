//
//  BONTextAlignmentConstraintTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 7/21/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

#import "BONBaseTestCase.h"
#import "BONTextAlignmentConstraint.h"

static UILabel *testLabel(NSString *text, CGFloat fontSize)
{
    UILabel *label = nil;
    if ( text && fontSize > 0.0f ) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = text;
        label.font = [UIFont systemFontOfSize:fontSize];
    }

    return label;
}

@interface BONTextAlignmentConstraintTestCase : BONBaseTestCase

@end

@implementation BONTextAlignmentConstraintTestCase

- (void)testTopConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeTop];

    BONAssertCGFloatsCloseEnough(constraint.constant, 0.0f);
}

- (void)testCapHeightConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeCapHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeCapHeight];

    BONAssertCGFloatsCloseEnough(constraint.constant, 7.854f);
}

- (void)testXHeightConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeXHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeXHeight];

    BONAssertCGFloatsCloseEnough(constraint.constant, 14.355f);
}

- (void)testTopToCapHeightConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeCapHeight];

    BONAssertCGFloatsCloseEnough(constraint.constant, 11.9f);
}

- (void)testCapHeightToTopConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeCapHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeTop];

    BONAssertCGFloatsCloseEnough(constraint.constant, -4.046f);
}

- (void)testTopToXHeightConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeXHeight];

    BONAssertCGFloatsCloseEnough(constraint.constant, 21.75f);
}

- (void)testXHeightToTopConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeXHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeTop];

    BONAssertCGFloatsCloseEnough(constraint.constant, -7.395f);
}

- (void)testCapHeightToXHeightConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeCapHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeXHeight];

    BONAssertCGFloatsCloseEnough(constraint.constant, 17.704f);
}

- (void)testXHeightToCapHeightConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    BONTextAlignmentConstraint *constraint = [BONTextAlignmentConstraint constraintWithItem:left
                                                                                  attribute:BONConstraintAttributeXHeight
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:right
                                                                                  attribute:BONConstraintAttributeCapHeight];

    BONAssertCGFloatsCloseEnough(constraint.constant, 4.505f);
}

- (void)testFirstBaselineConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    XCTAssertThrows([BONTextAlignmentConstraint constraintWithItem:left
                                                         attribute:BONConstraintAttributeFirstBaseline
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:right
                                                         attribute:BONConstraintAttributeFirstBaseline]);
}

- (void)testLastBaselineConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    XCTAssertThrows([BONTextAlignmentConstraint constraintWithItem:left
                                                         attribute:BONConstraintAttributeLastBaseline
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:right
                                                         attribute:BONConstraintAttributeLastBaseline]);
}

- (void)testBottomConstraint
{
    UILabel *left = testLabel(@"left", 17.0f);
    UILabel *right = testLabel(@"right", 50.0f);

    XCTAssertThrows([BONTextAlignmentConstraint constraintWithItem:left
                                                         attribute:BONConstraintAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:right
                                                         attribute:BONConstraintAttributeBottom]);
}

@end
