//
//  SwipeableTableViewCell.h
//  SwipableTableCellTest
//
//  Created by Erich Binder on 1/29/14.
//  Copyright (c) 2014 embinder. All rights reserved.
//

#define SWIPABLE_REUSE_IDENTIFIER @"SwipableReuseIdentifier"

@protocol SwipeableCellLeftSideButtonDelegate <NSObject>
@optional
- (void)swipeableCellLeftSideButtonTouchedForIndexPath:(NSIndexPath *)indexPath withButtonIndex:(int)buttonIndex;
@end

@protocol SwipeableCellRightSideButtonDelegate <NSObject>
@optional
- (void)swipeableCellRightSideButtonTouchedForIndexPath:(NSIndexPath *)indexPath withButtonIndex:(int)buttonIndex;
@end

@interface SwipeableTableViewCell : UITableViewCell
{
    __weak id <SwipeableCellLeftSideButtonDelegate> leftSideButtonDelegate;
    __weak id <SwipeableCellRightSideButtonDelegate> rightSideButtonDelegate;
}

@property (nonatomic, weak) id <SwipeableCellLeftSideButtonDelegate> leftSideButtonDelegate;
@property (nonatomic, weak) id <SwipeableCellRightSideButtonDelegate> rightSideButtonDelegate;

@property (nonatomic, strong) NSMutableArray *leftButtonImageNames;
@property (nonatomic, strong) NSMutableArray *rightButtonImageNames;
@property (nonatomic, readonly) NSMutableArray *leftButtons;
@property (nonatomic, readonly) NSMutableArray *rightButtons;
@property (nonatomic, readonly) float leftConstraint;
@property (nonatomic, readonly) float rightConstraint;

@property (nonatomic, strong) UIView *mainView;

- (void)setLeftButtonImageNames:(NSMutableArray *)leftButtonImageNames;
- (void)setRightButtonImageNames:(NSMutableArray *)rightButtonImageNames;

- (void)resetPan;

@end
