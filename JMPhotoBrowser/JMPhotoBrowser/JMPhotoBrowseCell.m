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
@synthesize imageView = _imageView;
@synthesize label = _label;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userSubviews = [[NSMutableArray alloc] init];
        self.index = 0;
        
        [self initImgView];
        [self initLabel];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userSubviews = [[NSMutableArray alloc] init];
        
        [self initImgView];
        [self initLabel];
    }
    
    return self;
}

- (void)initImgView
{
    self.imageView = ({
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [super addSubview:imgView];
        imgView;
    });
}

- (void)initLabel
{
    self.label = ({
        UILabel *label = [[UILabel alloc] init];
        [super addSubview:label];
        label;
    });
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
    
    [self.userSubviews removeAllObjects];
}


@end
