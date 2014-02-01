//
//  AppDelegate.h
//  SwipableTableCellTest
//
//  Created by Erich Binder on 1/29/14.
//  Copyright (c) 2014 embinder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SwipeableTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SwipeableTableViewController *viewController;

@end