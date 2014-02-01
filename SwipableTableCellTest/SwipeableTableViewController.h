//
//  SwipeableTableViewController.h
//  SwipableTableCellTest
//
//  Created by Erich Binder on 1/29/14.
//  Copyright (c) 2014 embinder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeableTableViewCell.h"

@interface SwipeableTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SwipeableCellLeftSideButtonDelegate, SwipeableCellRightSideButtonDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end