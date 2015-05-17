//
//  JMBrowserCell.h
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/16.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBrowseCell : UIView
//UIControlEventTouchDown           = 1 <<  0,      // on all touch downs
//UIControlEventTouchDownRepeat     = 1 <<  1,      // on multiple touchdowns (tap count > 1)
//UIControlEventTouchDragInside     = 1 <<  2,
//UIControlEventTouchDragOutside    = 1 <<  3,
//UIControlEventTouchDragEnter      = 1 <<  4,
//UIControlEventTouchDragExit       = 1 <<  5,
//UIControlEventTouchUpInside       = 1 <<  6,
//UIControlEventTouchUpOutside      = 1 <<  7,
//UIControlEventTouchCancel         = 1 <<  8,
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) id touchDownTarget;
@property (nonatomic, assign) id touchUpInsideTarget;
@property (nonatomic, assign) id touchUpOutsideTarget;
@property (nonatomic, assign) id touchCancelTarget;

@property (nonatomic, assign) SEL touchDownAction;
@property (nonatomic, assign) SEL touchUpInsideAction;
@property (nonatomic, assign) SEL touchUpOutsideAction;
@property (nonatomic, assign) SEL touchcancelAction;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
