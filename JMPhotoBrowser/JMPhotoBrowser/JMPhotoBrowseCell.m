//
//  JMPhotoBrowserCell.m
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/10.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import "JMPhotoBrowseCell.h"

@implementation JMPhotoBrowseCell
@synthesize userSubviews = _userSubviews;
@synthesize index = _index;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userSubviews = [[NSMutableArray alloc] init];
        self.index = 0;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userSubviews = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    
    [self.userSubviews addObject:view];
}

- (void)removeFromSuperview
{
    [self removeUserSubviews];
    
    [super removeFromSuperview];
}

- (void)removeUserSubviews
{
    for (UIView *view in self.userSubviews) {
        [view removeFromSuperview];
    }
}


@end
