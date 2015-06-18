//
//  RZManuscriptTestCase.m
//  BonMot
//
//  Created by Zev Eisenberg on 6/16/15.
//  Copyright (c) 2015 Zev Eisenberg. All rights reserved.
//

@import XCTest;
@import UIKit;

#import <manuscript/RZChainLink.h>

@interface RZManuscriptTestCase : XCTestCase

@end

@implementation RZManuscriptTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testManuscript
{
    RZChainLink *chainLink = RZCursive.string(@"Hello, testing world").font([UIFont preferredFontForTextStyle:UIFontTextStyleBody]).textColor([UIColor redColor]);
    NSAttributedString *attributedString = chainLink.attributedString;
    XCTAssertEqualObjects(attributedString.string, @"Hello, testing world");

    __block NSUInteger count = 0;
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        XCTAssertEqual(count, 0);

        NSParagraphStyle *defaultParagraphStyle = [[NSParagraphStyle alloc] init];

        NSDictionary *testDict = @{
                                   NSForegroundColorAttributeName: [UIColor redColor],
                                   NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                   NSParagraphStyleAttributeName: defaultParagraphStyle,
                                   };
        XCTAssertEqualObjects(attrs, testDict);
        
        count++;
    }];
}

@end
