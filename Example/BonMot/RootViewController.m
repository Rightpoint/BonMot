//
//  ViewController.m
//  BonMot
//
//  Created by Zev Eisenberg on 04/17/2015.
//  Copyright (c) 2014 Zev Eisenberg. All rights reserved.
//

#import "RootViewController.h"

// Cells
#import "ColorCell.h"
#import "TrackingCell.h"
#import "LineHeightCell.h"
#import "FigureStyleCell.h"
#import "BaselineCapHeightCell.h"
#import "ProgrammaticBaselineCapHeightCell.h"
#import "InlineImagesCell.h"
#import "SpecialCharactersCell.h"
#import "BaselineOffsetCell.h"
#import "ConcatenationCell.h"

@interface RootViewController ()

@property (copy, nonatomic) NSArray *cellClasses;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 123.0f;

    self.cellClasses = @[
                         [ColorCell class],
                         [TrackingCell class],
                         [LineHeightCell class],
                         [FigureStyleCell class],
                         [BaselineCapHeightCell class],
                         [ProgrammaticBaselineCapHeightCell class],
                         [InlineImagesCell class],
                         [SpecialCharactersCell class],
                         [BaselineOffsetCell class],
                         [ConcatenationCell class],
                         ];

    for ( Class CellClass in self.cellClasses ) {
        NSAssert([CellClass respondsToSelector:@selector(reuseIdentifier)],
                 @"Cells must inherit from %@", NSStringFromClass([AbstractCell class]));

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
             @"Cells must inherit from %@", NSStringFromClass([AbstractCell class]));

    return [CellClass title];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class CellClass = self.cellClasses[indexPath.section];
    NSAssert([CellClass respondsToSelector:@selector(reuseIdentifier)],
             @"Cells must inherit from %@", NSStringFromClass([AbstractCell class]));

    BaselineOffsetCell *cell = [tableView dequeueReusableCellWithIdentifier:[CellClass reuseIdentifier]];
    return cell;
}

@end
