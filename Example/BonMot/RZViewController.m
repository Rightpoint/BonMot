//
//  RZViewController.m
//  BonMot
//
//  Created by Zev Eisenberg on 04/17/2015.
//  Copyright (c) 2014 Zev Eisenberg. All rights reserved.
//

#import "RZViewController.h"

// Cells
#import "RZColorCell.h"
#import "RZTrackingCell.h"
#import "RZLineHeightCell.h"
#import "RZFigureStyleCell.h"
#import "RZBaselineCapHeightCell.h"
#import "RZInlineImagesCell.h"
#import "RZBaselineOffsetCell.h"
#import "RZConcatenationCell.h"

// Pods
#import <BonMot/BONChainLink.h>

@interface RZViewController ()

@property (copy, nonatomic) NSArray *cellClasses;

@end

@implementation RZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 123.0f;

    self.cellClasses = @[
                         [RZColorCell class],
                         [RZTrackingCell class],
                         [RZLineHeightCell class],
                         [RZFigureStyleCell class],
                         [RZBaselineCapHeightCell class],
                         [RZInlineImagesCell class],
                         [RZBaselineOffsetCell class],
                         [RZConcatenationCell class],
                         ];

    for ( Class CellClass in self.cellClasses ) {
        NSAssert([CellClass respondsToSelector:@selector(reuseIdentifier)],
                 @"Cells must inherit from %@", NSStringFromClass([RZAbstractCell class]));

        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(CellClass) bundle:nil]
             forCellReuseIdentifier:[CellClass reuseIdentifier]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellClasses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Class CellClass = self.cellClasses[section];
    NSAssert([CellClass respondsToSelector:@selector(title)],
             @"Cells must inherit from %@", NSStringFromClass([RZAbstractCell class]));

    return [CellClass title];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class CellClass = self.cellClasses[indexPath.section];
    NSAssert([CellClass respondsToSelector:@selector(reuseIdentifier)],
             @"Cells must inherit from %@", NSStringFromClass([RZAbstractCell class]));

    RZBaselineOffsetCell *cell = [tableView dequeueReusableCellWithIdentifier:[CellClass reuseIdentifier]];
    return cell;
}

@end
