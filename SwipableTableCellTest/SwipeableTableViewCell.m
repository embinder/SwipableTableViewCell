//
//  SwipeableTableViewCell.m
//  SwipableTableCellTest
//
//  Created by Erich Binder on 1/29/14.
//  Copyright (c) 2014 embinder. All rights reserved.
//

#define CONSTRAINT_PADDING 15

CF_ENUM(NSInteger , Side)
{
    LEFT = 0,
    RIGHT
};

#import "SwipeableTableViewCell.h"

@implementation SwipeableTableViewCell
{
    CGPoint _touchPoint;
}

static NSString *reuseIdentifier;

@synthesize leftSideButtonDelegate, rightSideButtonDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addMainView];
    }
    return self;
}

- (void)addMainView
{
    _mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
    _mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_mainView];
}

- (NSMutableArray *)getButtonsForImageNames:(NSMutableArray *)imageNames
{
    NSMutableArray *buttons = [NSMutableArray new];

    for (int i = 0; i < imageNames.count; i++)
    {
        UIImage *buttonImage = [UIImage imageNamed:imageNames[i]];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        [buttons addObject:button];
    }

    return buttons;
}

- (void)placeButtons:(NSMutableArray *)buttons onSide:(enum Side)side
{
    NSMutableArray *localButtons;
    localButtons =  (side == LEFT) ? _leftButtons : _rightButtons;

    for (UIButton *button in localButtons)
    {
        [button removeFromSuperview];
    }

    localButtons = buttons;

    if (side == LEFT)
    {
        _leftButtons = [NSMutableArray new];
    }
    else
    {
        _rightButtons = [NSMutableArray new];
    }

    UIButton *previousButton;
    for (UIButton *button in localButtons)
    {
        [self.contentView addSubview:button];

        float buttonX;

        if (side == LEFT)
        {
            buttonX = (previousButton) ? previousButton.frame.origin.x + previousButton.frame.size.width : 0;
            [button addTarget:self action:@selector(leftButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [_leftButtons addObject:button];
        }
        else
        {
            buttonX = (previousButton) ? previousButton.frame.origin.x - previousButton.frame.size.width : self.contentView.frame.size.width - button.frame.size.width;
            [button addTarget:self action:@selector(rightButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [_rightButtons addObject:button];
        }

        button.frame = CGRectMake(buttonX, 0, button.frame.size.width, button.frame.size.height);

        previousButton = button;
    }

    [self.contentView addSubview:_mainView];
}

#pragma mark Swipe animation methods
- (void)animateMainViewTo:(CGPoint)point withDuration:(float)duration withBouce:(BOOL)bounce
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFromValue:[NSValue valueWithCGPoint:CGPointMake(_mainView.center.x, _mainView.center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
    [animation setDuration:duration];
    _mainView.layer.position = CGPointMake(point.x, point.y);
    if (bounce) [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :1 :1]];
    [_mainView.layer addAnimation:animation forKey:@"position"];
}

#pragma mark Pan animation methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetOtherCells];

    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint newLocation = [touch locationInView:self];
    CGPoint translation = CGPointMake(newLocation.x - _touchPoint.x, newLocation.y - _touchPoint.y);

    if (fabsf(translation.x) < fabsf(translation.y))
    {
        //return;
    }

    _touchPoint = newLocation;

    float newCenterX = _mainView.center.x + translation.x;
    if (newCenterX > _leftConstraint + CONSTRAINT_PADDING)
    {
        newCenterX = _leftConstraint + CONSTRAINT_PADDING;
    }
    else if (newCenterX < _rightConstraint - CONSTRAINT_PADDING)
    {
        newCenterX = _rightConstraint - CONSTRAINT_PADDING;
    }

    _mainView.center = CGPointMake(newCenterX, _mainView.center.y);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_mainView.center.x > _rightConstraint && _mainView.center.x < self.contentView.center.x)
    {
        [self resetPan];
    }
    else if (_mainView.center.x < _rightConstraint && _mainView.center.x >= _rightConstraint - CONSTRAINT_PADDING && _mainView.center.x < self.contentView.center.x)
    {
        [self animateMainViewTo:CGPointMake(_rightConstraint, self.contentView.center.y) withDuration:0.2 withBouce:YES];
    }
    else if (_mainView.center.x < _leftConstraint && _mainView.center.x > self.contentView.center.x)
    {
        [self resetPan];
    }
    else if (_mainView.center.x > _leftConstraint && _mainView.center.x <= _leftConstraint + CONSTRAINT_PADDING && _mainView.center.x > self.contentView.center.x)
    {
        [self animateMainViewTo:CGPointMake(_leftConstraint, self.contentView.center.y) withDuration:0.2 withBouce:YES];
    }
}

- (void)resetOtherCells
{
    NSArray *cells = [self.getParentTableView visibleCells];
    for (UITableViewCell *cell in cells)
    {
        if (cell != self && [cell isKindOfClass:[SwipeableTableViewCell class]])
        {
            SwipeableTableViewCell *swipeableCell = (SwipeableTableViewCell *)cell;
            [swipeableCell resetPan];
        }
    }
}

- (void)resetPan
{
    [self animateMainViewTo:CGPointMake(self.contentView.center.x, self.contentView.center.y) withDuration:0.15 withBouce:NO];
}

#pragma mark Button touch methods
- (void)leftButtonTouch:(UIButton *)button
{
    if (self.leftSideButtonDelegate != nil && [self.leftSideButtonDelegate respondsToSelector:@selector(swipeableCellLeftSideButtonTouchedForIndexPath:withButtonIndex:)])
    {
        [self.leftSideButtonDelegate swipeableCellLeftSideButtonTouchedForIndexPath:self.getIndexPath withButtonIndex:(int) button.tag];
    }
}

- (void)rightButtonTouch:(UIButton *)button
{
    if (self.rightSideButtonDelegate != nil && [self.rightSideButtonDelegate respondsToSelector:@selector(swipeableCellLeftSideButtonTouchedForIndexPath:withButtonIndex:)])
    {
        [self.rightSideButtonDelegate swipeableCellRightSideButtonTouchedForIndexPath:self.getIndexPath withButtonIndex:(int) button.tag];
    }
}

- (UITableView *)getParentTableView
{
    id view = [self superview];
    while (![view isKindOfClass:[UITableView class]])
    {
        view = [view superview];
    }

    UITableView *tableView = (UITableView *)view;
    return tableView;
}

- (NSIndexPath *)getIndexPath
{
    UITableView *tableView = self.getParentTableView;
    return [tableView indexPathForCell:self];
}

#pragma mark Custom button name array setters
- (void)setLeftButtonImageNames:(NSMutableArray *)leftButtonImageNames
{
    _leftButtonImageNames = leftButtonImageNames;

    NSMutableArray *buttons = [self getButtonsForImageNames:_leftButtonImageNames];
    [self placeButtons:buttons onSide:LEFT];

    if (_leftButtons.count > 0)
    {
        UIButton *innerMostLeftButton = [_leftButtons objectAtIndex:_leftButtons.count - 1];
        _leftConstraint = self.contentView.center.x + innerMostLeftButton.frame.origin.x + innerMostLeftButton.frame.size.width;
    }
}

- (void)setRightButtonImageNames:(NSMutableArray *)rightButtonImageNames
{
    _rightButtonImageNames = rightButtonImageNames;

    NSMutableArray *buttons = [self getButtonsForImageNames:_rightButtonImageNames];
    [self placeButtons:buttons onSide:RIGHT];

    if (_rightButtonImageNames.count > 0)
    {
        UIButton *innerMostRightButton = [_rightButtons objectAtIndex:_rightButtons.count - 1];
        _rightConstraint = self.contentView.center.x - (self.contentView.frame.size.width - innerMostRightButton.frame.origin.x);
    }
}

#pragma mark Dequeue cell
- (void)prepareForReuse
{
    self.leftButtonImageNames = [NSMutableArray new];
    self.rightButtonImageNames = [NSMutableArray new];
    _mainView.center = self.contentView.center;
}

@end