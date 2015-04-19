//
//  RZViewController.m
//  manuscript
//
//  Created by Zev Eisenberg on 04/17/2015.
//  Copyright (c) 2014 Zev Eisenberg. All rights reserved.
//

#import "RZViewController.h"

#import <Manuscript/RZManuscript.h>

@interface RZViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIFont *baseFont = [UIFont boldSystemFontOfSize:30];
    NSString *quote = @"Outside of a dog, a book is a man’s best friend. Inside of a dog, it’s too dark to read.";
    NSAttributedString *attributedString = RZManuscript.font(baseFont).adobeTracking(200).lineHeightMultiple(3.0f).string(quote).write;

    self.label.attributedText = attributedString;

    RZManuscript *manuscriptForLater = RZManuscript.font(baseFont).pointTracking(200).string(quote);
    NSAttributedString *otherAttributedString = manuscriptForLater.write;
    NSLog(@"Attributed String: %@", otherAttributedString);

    NSDictionary *justTheAttributes = manuscriptForLater.attributes;
    NSLog(@"Just the attributes: %@", justTheAttributes);

}

@end
