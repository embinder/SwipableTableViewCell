//
//  SwipeableTableViewController.m
//  SwipableTableCellTest
//
//  Created by Erich Binder on 1/29/14.
//  Copyright (c) 2014 embinder. All rights reserved.
//

#import "SwipeableTableViewController.h"

@interface SwipeableTableViewController ()

@end

@implementation SwipeableTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[SwipeableTableViewCell class] forCellReuseIdentifier:SWIPABLE_REUSE_IDENTIFIER];

    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwipeableTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SWIPABLE_REUSE_IDENTIFIER];
    cell.leftButtonImageNames = [NSMutableArray arrayWithArray:@[@"shape", @"shape"]];
    cell.rightButtonImageNames = [NSMutableArray arrayWithArray:@[@"shape"]];
    cell.leftSideButtonDelegate = self;
    cell.rightSideButtonDelegate = self;

    return cell;
}

#pragma mark SwipeableTableViewCell delegate methods
- (void)swipeableCellLeftSideButtonTouchedForIndexPath:(NSIndexPath *)indexPath withButtonIndex:(int)buttonIndex
{
    NSLog(@"Touch Left %ld - %ld", (long)indexPath.row, (long)buttonIndex);
}

- (void)swipeableCellRightSideButtonTouchedForIndexPath:(NSIndexPath *)indexPath withButtonIndex:(int)buttonIndex
{
    NSLog(@"Touch Right %ld - %ld", (long)indexPath.row, (long)buttonIndex);
}

@end