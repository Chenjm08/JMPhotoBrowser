//
//  JMPhotoBrowserView.h
//  PaintingPuzzle
//
//  Created by chenjiemin on 15/5/10.
//  Copyright (c) 2015年 chenjiemin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPhotoBrowserCell.h"

@class JMPhotoBrowserView;

@protocol JMPhotoBrowserDataSource <NSObject>

- (NSInteger)numberOfPhotosInPhotoBrowser:(JMPhotoBrowserView *)browser;
- (JMPhotoBrowserCell *)photoBrowser:(JMPhotoBrowserView *)browser cellAtIndex:(NSInteger)index;

@end

@protocol JMPhotoBrowserViewDelegate <NSObject>

- (CGFloat)photoBrowser:(JMPhotoBrowserView *)browser heightForIndex:(NSInteger)index;
- (CGFloat)photoBrowser:(JMPhotoBrowserView *)browser widthForIndex:(NSInteger)index;
- (void)photoBrowser:(JMPhotoBrowserView *)browser didSelectAtIndex:(NSInteger)index;

@end


@interface JMPhotoBrowserView : UIView
@property (nonatomic, weak) id <JMPhotoBrowserDataSource> dataSource;
@property (nonatomic, weak) id <JMPhotoBrowserViewDelegate> delegate;

- (JMPhotoBrowserCell *)dequeueReusableCell;

- (void)setContentOffset:(CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)setContentOffset:(CGPoint)contentOffset animatedTime:(CGFloat)animatedTime;

@end

