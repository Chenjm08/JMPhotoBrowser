//
//  JMBrowserCell.m
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/16.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import "JMBrowseCell.h"

@implementation JMBrowseCell
@synthesize index;

@synthesize touchDownTarget;
@synthesize touchUpInsideTarget;
@synthesize touchUpOutsideTarget;
@synthesize touchCancelTarget;

@synthesize touchDownAction;
@synthesize touchUpInsideAction;
@synthesize touchUpOutsideAction;
@synthesize touchcancelAction;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (UIControlEventTouchDown == (controlEvents & UIControlEventTouchDown)) {
        self.touchDownTarget = target;
        self.touchDownAction = action;
    }
    
    if (UIControlEventTouchUpInside == (controlEvents & UIControlEventTouchUpInside)) {
        self.touchUpInsideTarget = target;
        self.touchUpInsideAction = action;
    }
    
    if (UIControlEventTouchUpOutside == (controlEvents & UIControlEventTouchUpOutside)) {
        self.touchUpOutsideTarget = target;
        self.touchUpOutsideAction = action;
    }
    
    if (UIControlEventTouchCancel == (controlEvents & UIControlEventTouchCancel)) {
        self.touchCancelTarget = target;
        self.touchcancelAction = action;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    PerformSelector(self.touchDownTarget, self.touchDownAction, self);
    if (self.touchDownTarget && [self.touchDownTarget respondsToSelector:self.touchDownAction]) {
        [self.touchDownTarget respondsToSelector:self.touchDownAction];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, point)) {
        PerformSelector(self.touchUpInsideTarget, self.touchUpInsideAction, self);
    }
    else {
        PerformSelector(self.touchUpOutsideTarget, self.touchUpOutsideAction, self);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    PerformSelector(self.touchCancelTarget, self.touchcancelAction, self);

}

@end
